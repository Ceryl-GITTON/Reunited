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
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.countdown_widget);
        
        // Récupérer les données depuis SharedPreferences
        android.content.SharedPreferences prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE);
        
        String timeRemaining = prefs.getString("timeRemaining", "Loading...");
        String reunionDate = prefs.getString("reunionDate", "");
        String timezone = prefs.getString("timezone", "");
        boolean isTimeUp = prefs.getBoolean("isTimeUp", false);
        
        // Mettre à jour les textes
        if (isTimeUp) {
            views.setTextViewText(R.id.widget_title, "💕 Reunited! 💕");
            views.setTextViewText(R.id.widget_countdown, "C'est le moment!");
        } else {
            views.setTextViewText(R.id.widget_title, "💕 Reunited Countdown");
            views.setTextViewText(R.id.widget_countdown, timeRemaining);
        }
        
        if (!reunionDate.isEmpty()) {
            views.setTextViewText(R.id.widget_subtitle, "📅 " + reunionDate);
        }
        
        if (!timezone.isEmpty()) {
            views.setTextViewText(R.id.widget_location, "🌍 " + timezone);
        }
        
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
