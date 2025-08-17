package com.example.reunited;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
import android.app.AlarmManager;
import android.app.PendingIntent;
import java.util.Calendar;
import java.util.concurrent.TimeUnit;

public class CountdownWidgetProvider extends AppWidgetProvider {
    
    private static final String ACTION_UPDATE_WIDGET = "com.example.reunited.UPDATE_WIDGET";
    
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
        
        // Programmer la prochaine mise à jour
        scheduleNextUpdate(context);
    }
    
    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        // Calculer le temps restant jusqu'au 15 août 2025
        Calendar target = Calendar.getInstance();
        target.set(2025, Calendar.AUGUST, 15, 0, 0, 0);
        target.set(Calendar.MILLISECOND, 0);
        
        long currentTime = System.currentTimeMillis();
        long targetTime = target.getTimeInMillis();
        long timeLeft = targetTime - currentTime;
        
        String countdownText;
        String subtitle = "💕";
        
        if (timeLeft > 0) {
            long days = TimeUnit.MILLISECONDS.toDays(timeLeft);
            long hours = TimeUnit.MILLISECONDS.toHours(timeLeft) % 24;
            long minutes = TimeUnit.MILLISECONDS.toMinutes(timeLeft) % 60;
            
            if (days > 0) {
                countdownText = String.format("%d jours\n%02d:%02d", days, hours, minutes);
            } else if (hours > 0) {
                countdownText = String.format("%02d:%02d", hours, minutes);
                subtitle = "Dernières heures ! 💕";
            } else {
                countdownText = String.format("%d min", minutes);
                subtitle = "Bientôt ! 💕";
            }
        } else {
            countdownText = "C'est le jour !";
            subtitle = "Retrouvailles ! 🎉💕";
        }
        
        // Créer les vues du widget
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.countdown_widget);
        views.setTextViewText(R.id.countdown_text, countdownText);
        views.setTextViewText(R.id.widget_title, "Retrouvailles");
        views.setTextViewText(R.id.subtitle, subtitle);
        
        // Intent pour ouvrir l'app au clic
        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);
        
        // Mettre à jour le widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
    
    private void scheduleNextUpdate(Context context) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, CountdownWidgetProvider.class);
        intent.setAction(ACTION_UPDATE_WIDGET);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        
        // Mettre à jour toutes les minutes
        long nextUpdate = System.currentTimeMillis() + 60000; // 1 minute
        alarmManager.setExact(AlarmManager.RTC, nextUpdate, pendingIntent);
    }
    
    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        
        if (ACTION_UPDATE_WIDGET.equals(intent.getAction())) {
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
            ComponentName componentName = new ComponentName(context, CountdownWidgetProvider.class);
            int[] appWidgetIds = appWidgetManager.getAppWidgetIds(componentName);
            onUpdate(context, appWidgetManager, appWidgetIds);
        }
    }
    
    @Override
    public void onEnabled(Context context) {
        super.onEnabled(context);
        // Premier widget ajouté
        scheduleNextUpdate(context);
    }
    
    @Override
    public void onDisabled(Context context) {
        super.onDisabled(context);
        // Dernier widget supprimé - annuler les mises à jour
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, CountdownWidgetProvider.class);
        intent.setAction(ACTION_UPDATE_WIDGET);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        alarmManager.cancel(pendingIntent);
    }
}
