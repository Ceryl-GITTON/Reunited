package com.reunited.countdown.reunited_countdown

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.reunited.countdown/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidget") {
                    try {
                        // Log des données reçues pour debug
                        val days = call.argument<Int>("days") ?: 0
                        val hours = call.argument<Int>("hours") ?: 0
                        val minutes = call.argument<Int>("minutes") ?: 0  
                        val seconds = call.argument<Int>("seconds") ?: 0
                        
                        println("MainActivity: Received widget data - Days: $days, Hours: $hours, Minutes: $minutes, Seconds: $seconds")
                        
                        // Sauvegarder aussi dans SharedPreferences pour que le widget puisse les lire
                        val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", 0)
                        val editor = prefs.edit()
                        
                        editor.putInt("flutter.widget_days", days)
                        editor.putInt("flutter.widget_hours", hours)
                        editor.putInt("flutter.widget_minutes", minutes)
                        editor.putInt("flutter.widget_seconds", seconds)
                        editor.putString("flutter.widget_timeRemaining", call.argument<String>("timeRemaining") ?: "")
                        editor.putString("flutter.widget_reunionDateFormatted", call.argument<String>("reunionDate") ?: "")
                        editor.putString("flutter.widget_timezone", call.argument<String>("timezone") ?: "")
                        editor.putBoolean("flutter.widget_isTimeUp", call.argument<Boolean>("isTimeUp") ?: false)
                        
                        editor.apply()
                        
                        // Mettre à jour tous les widgets
                        CountdownWidgetProvider.updateAllWidgets(applicationContext)
                        result.success("Widget updated successfully")
                    } catch (e: Exception) {
                        result.error("UPDATE_ERROR", "Failed to update widget", e.message)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
