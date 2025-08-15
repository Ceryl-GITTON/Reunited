package com.reunited.countdown.reunited_countdown

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.AlarmManager
import android.app.PendingIntent
import java.util.Calendar
import java.util.concurrent.TimeUnit

class CountdownWidgetProvider : AppWidgetProvider() {
    
    companion object {
        private const val ACTION_UPDATE_WIDGET = "com.reunited.countdown.reunited_countdown.UPDATE_WIDGET"
    }
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        
        // Programmer la prochaine mise à jour
        scheduleNextUpdate(context)
    }
    
    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        // Calculer le temps restant jusqu'au 15 août 2025
        val target = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 15, 0, 0, 0)
            set(Calendar.MILLISECOND, 0)
        }
        
        val currentTime = System.currentTimeMillis()
        val targetTime = target.timeInMillis
        val timeLeft = targetTime - currentTime
        
        val countdownText: String
        val subtitle: String
        
        if (timeLeft > 0) {
            val days = TimeUnit.MILLISECONDS.toDays(timeLeft)
            val hours = TimeUnit.MILLISECONDS.toHours(timeLeft) % 24
            val minutes = TimeUnit.MILLISECONDS.toMinutes(timeLeft) % 60
            
            when {
                days > 0 -> {
                    countdownText = String.format("%d jours\n%02d:%02d", days, hours, minutes)
                    subtitle = "💕"
                }
                hours > 0 -> {
                    countdownText = String.format("%02d:%02d", hours, minutes)
                    subtitle = "Dernières heures ! 💕"
                }
                else -> {
                    countdownText = String.format("%d min", minutes)
                    subtitle = "Bientôt ! 💕"
                }
            }
        } else {
            countdownText = "C'est le jour !"
            subtitle = "Retrouvailles ! 🎉💕"
        }
        
        // Créer les vues du widget
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        views.setTextViewText(R.id.countdown_display, countdownText)
        views.setTextViewText(R.id.widget_title, "Retrouvailles")
        
        // Intent pour ouvrir l'app au clic
        val intent = Intent().apply {
            setClassName(context, "com.reunited.countdown.reunited_countdown.MainActivity")
        }
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
        
        // Mettre à jour le widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
    
    private fun scheduleNextUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CountdownWidgetProvider::class.java).apply {
            action = ACTION_UPDATE_WIDGET
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        
        // Mettre à jour toutes les minutes
        val nextUpdate = System.currentTimeMillis() + 60000 // 1 minute
        alarmManager.setExact(AlarmManager.RTC, nextUpdate, pendingIntent)
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
    
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        // Premier widget ajouté
        scheduleNextUpdate(context)
    }
    
    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        // Dernier widget supprimé - annuler les mises à jour
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CountdownWidgetProvider::class.java).apply {
            action = ACTION_UPDATE_WIDGET
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        alarmManager.cancel(pendingIntent)
    }
}
