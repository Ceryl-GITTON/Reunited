package com.reunited.countdown.reunited_countdown;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

public class CountdownWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // Log pour debug
        android.util.Log.d("CountdownWidget", "Widget onUpdate called");
        
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.countdown_widget);
        
        // Récupérer les données depuis SharedPreferences (même nom que Flutter)
        android.content.SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        boolean isTimeUp = prefs.getBoolean("flutter.widget_isTimeUp", false);
        String reunionDate = prefs.getString("flutter.widget_reunionDateFormatted", "");
        String timezone = prefs.getString("flutter.widget_timezone", "");
        
        // Mettre à jour les textes selon l'état
        if (isTimeUp) {
            // Mode célébration
            views.setTextViewText(R.id.widget_title, "🎉 C'est l'heure ! 🎉");
            views.setTextViewText(R.id.widget_days, "🎊");
            views.setTextViewText(R.id.widget_hours, "💕");
            views.setTextViewText(R.id.widget_minutes, "🎉");
            views.setTextViewText(R.id.widget_seconds, "💖");
        } else {
            // Mode compte à rebours normal
            views.setTextViewText(R.id.widget_title, "💕 Reunited Countdown");
            
            // Récupérer les valeurs séparées pour un bel affichage
            int days = prefs.getInt("flutter.widget_days", -1);
            int hours = prefs.getInt("flutter.widget_hours", -1);
            int minutes = prefs.getInt("flutter.widget_minutes", -1);
            int seconds = prefs.getInt("flutter.widget_seconds", -1);
            
            // Log pour debug
            android.util.Log.d("CountdownWidget", "Read values - Days: " + days + ", Hours: " + hours + ", Minutes: " + minutes + ", Seconds: " + seconds);
            
            // Si on n'a pas encore de données Flutter, afficher Loading...
            if (days == -1 || hours == -1 || minutes == -1 || seconds == -1) {
                views.setTextViewText(R.id.widget_days, "⏳");
                views.setTextViewText(R.id.widget_hours, "⏳");
                views.setTextViewText(R.id.widget_minutes, "⏳");
                views.setTextViewText(R.id.widget_seconds, "⏳");
                android.util.Log.d("CountdownWidget", "No Flutter data yet, showing loading...");
            } else {
                // Formater avec zéros en préfixe comme l'app (UNIQUEMENT les vraies données Flutter)
                views.setTextViewText(R.id.widget_days, String.format("%02d", days));
                views.setTextViewText(R.id.widget_hours, String.format("%02d", hours));
                views.setTextViewText(R.id.widget_minutes, String.format("%02d", minutes));
                views.setTextViewText(R.id.widget_seconds, String.format("%02d", seconds));
            }
        }
        
        // // Mettre à jour la date et lieu
        // if (!reunionDate.isEmpty()) {
        //     views.setTextViewText(R.id.widget_subtitle, "📅 " + reunionDate);
        // }
        
        // if (!timezone.isEmpty()) {
        //     views.setTextViewText(R.id.widget_location, "🌍 " + timezone);
        // }
        
        // Intent pour ouvrir l'app
        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent);
        
        // Mettre à jour le widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    public static void updateAllWidgets(Context context) {
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        android.content.ComponentName componentName = new android.content.ComponentName(context, CountdownWidgetProvider.class);
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(componentName);
        
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }
}
