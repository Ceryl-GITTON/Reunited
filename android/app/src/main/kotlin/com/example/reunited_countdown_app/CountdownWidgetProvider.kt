package com.example.reunited_countdown_app

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.util.Calendar
import java.util.concurrent.TimeUnit

class CountdownWidgetProvider : AppWidgetProvider() {
    
    companion object {
        private const val ACTION_UPDATE_WIDGET = "com.example.reunited_countdown_app.UPDATE_WIDGET"
    }
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        // Programmer la prochaine mise à jour dans 1 seconde
        scheduleNextUpdate(context)
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        if (ACTION_UPDATE_WIDGET == intent.action) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, CountdownWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }
    
    private fun scheduleNextUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CountdownWidgetProvider::class.java).apply {
            action = ACTION_UPDATE_WIDGET
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Programmer la prochaine mise à jour dans 30 secondes (minimum raisonnable)
        val nextUpdate = System.currentTimeMillis() + 30000
        alarmManager.setExact(AlarmManager.RTC, nextUpdate, pendingIntent)
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
            val seconds = TimeUnit.MILLISECONDS.toSeconds(timeLeft) % 60
            
            when {
                days > 0 -> String.format("%dd %02d:%02d:%02d", days, hours, minutes, seconds)
                hours > 0 -> String.format("%02d:%02d:%02d", hours, minutes, seconds)
                minutes > 0 -> String.format("%02d:%02d", minutes, seconds)
                else -> String.format("%02ds", seconds)
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
        scheduleNextUpdate(context)
    }
    
    override fun onDisabled(context: Context) {
        // Dernier widget supprimé de l'écran d'accueil - arrêter les mises à jour
        super.onDisabled(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CountdownWidgetProvider::class.java).apply {
            action = ACTION_UPDATE_WIDGET
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}

