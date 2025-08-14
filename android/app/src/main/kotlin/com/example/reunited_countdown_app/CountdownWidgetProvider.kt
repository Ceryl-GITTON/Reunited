package com.example.reunited_countdown_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.util.Calendar
import java.util.concurrent.TimeUnit

class CountdownWidgetProvider : AppWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
    
    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        // Date cible : 15 août 2025 à minuit
        val target = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 15, 0, 0, 0)
            set(Calendar.MILLISECOND, 0)
        }
        
        val currentTime = System.currentTimeMillis()
        val targetTime = target.timeInMillis
        val timeLeft = targetTime - currentTime
        
        val countdownText = if (timeLeft > 0) {
            val days = TimeUnit.MILLISECONDS.toDays(timeLeft)
            val hours = TimeUnit.MILLISECONDS.toHours(timeLeft) % 24
            val minutes = TimeUnit.MILLISECONDS.toMinutes(timeLeft) % 60
            
            when {
                days > 1 -> "$days jours"
                days == 1L -> "1 jour ${hours}h"
                hours > 0 -> "${hours}h ${minutes}min"
                else -> "${minutes} minutes"
            }
        } else {
            "Retrouvailles! 🎉"
        }
        
        // Mettre à jour le widget avec les nouvelles valeurs
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        views.setTextViewText(R.id.countdown_display, countdownText)
        views.setTextViewText(R.id.widget_title, "Retrouvailles")
        views.setTextViewText(R.id.widget_emoji, "💕")
        
        // Appliquer les mises à jour
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
    
    override fun onEnabled(context: Context) {
        // Premier widget ajouté à l'écran d'accueil
        super.onEnabled(context)
    }
    
    override fun onDisabled(context: Context) {
        // Dernier widget supprimé de l'écran d'accueil
        super.onDisabled(context)
    }
}
