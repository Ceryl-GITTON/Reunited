package com.reunited.countdown.reunited_countdown;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

/**
 * Implementation of App Widget functionality.
 */
public class ReunitedCountdownWidgetProvider extends AppWidgetProvider {
    
    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.reunited_countdown_widget);
        
        // Get shared preferences for widget data
        SharedPreferences prefs = context.getSharedPreferences("group.reunited.countdown", Context.MODE_PRIVATE);
        
        // Read data from shared preferences
        String status = prefs.getString("status", "counting");
        String title = prefs.getString("title", "Retrouvailles 💖");
        String message = prefs.getString("message", "Bientôt les retrouvailles!");
        String reunionDate = prefs.getString("reunion_date", "15 septembre 2025");
        
        // Update title
        views.setTextViewText(R.id.widget_title, title);
        views.setTextViewText(R.id.widget_date, reunionDate);
        views.setTextViewText(R.id.widget_message, message);
        
        if ("completed".equals(status)) {
            // La date est passée
            views.setTextViewText(R.id.widget_days, "🎉");
            views.setTextViewText(R.id.widget_hours, "💖");
            views.setTextViewText(R.id.widget_minutes, "🎊");
        } else {
            // Afficher le compte à rebours
            int days = prefs.getInt("days", 0);
            int hours = prefs.getInt("hours", 0);
            int minutes = prefs.getInt("minutes", 0);
            
            views.setTextViewText(R.id.widget_days, String.valueOf(days));
            views.setTextViewText(R.id.widget_hours, String.format("%02d", hours));
            views.setTextViewText(R.id.widget_minutes, String.format("%02d", minutes));
        }
        
        // Setup click intent to open app
        Intent intent = new Intent(context, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
            context, 
            0, 
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );
        views.setOnClickPendingIntent(R.id.countdown_container, pendingIntent);
        
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}
