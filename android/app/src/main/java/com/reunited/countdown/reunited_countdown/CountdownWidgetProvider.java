package com.reunited.countdown.reunited_countdown;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.widget.RemoteViews;

import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.TimeZone;

public class CountdownWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
        startService(context);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            startService(context);
        }
    }

    @Override
    public void onEnabled(Context context) {
        startService(context);
    }

    // --- Service start ---

    static void startService(Context context) {
        Intent intent = new Intent(context, CountdownWidgetService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
        } else {
            context.startService(intent);
        }
    }

    // --- Widget rendering ---

    static void updateWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.countdown_widget);
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);

        String reunionDateStr = prefs.getString("flutter.reunionDate", null);
        String timezone = prefs.getString("flutter.selectedTimezone", "Indonesia");

        int days, hours, minutes, seconds;
        boolean isTimeUp;

        if (reunionDateStr != null) {
            long[] result = calculateCountdown(reunionDateStr, timezone);
            if (result == null) {
                days    = prefs.getInt("flutter.widget_days", -1);
                hours   = prefs.getInt("flutter.widget_hours", -1);
                minutes = prefs.getInt("flutter.widget_minutes", -1);
                seconds = prefs.getInt("flutter.widget_seconds", -1);
                isTimeUp = prefs.getBoolean("flutter.widget_isTimeUp", false);
            } else {
                long remainingSec = result[0];
                isTimeUp = remainingSec <= 0;
                days    = isTimeUp ? 0 : (int) (remainingSec / 86400);
                hours   = isTimeUp ? 0 : (int) ((remainingSec % 86400) / 3600);
                minutes = isTimeUp ? 0 : (int) ((remainingSec % 3600) / 60);
                seconds = isTimeUp ? 0 : (int) (remainingSec % 60);
            }
        } else {
            days    = prefs.getInt("flutter.widget_days", -1);
            hours   = prefs.getInt("flutter.widget_hours", -1);
            minutes = prefs.getInt("flutter.widget_minutes", -1);
            seconds = prefs.getInt("flutter.widget_seconds", -1);
            isTimeUp = prefs.getBoolean("flutter.widget_isTimeUp", false);
        }

        android.util.Log.d("CountdownWidget", "Read values - Days: " + days + ", Hours: " + hours + ", Minutes: " + minutes + ", Seconds: " + seconds);

        if (isTimeUp) {
            views.setTextViewText(R.id.widget_title, "🎉 C'est l'heure ! 🎉");
            views.setTextViewText(R.id.widget_days, "🎊");
            views.setTextViewText(R.id.widget_hours, "💕");
            views.setTextViewText(R.id.widget_minutes, "🎉");
            views.setTextViewText(R.id.widget_seconds, "💖");
        } else if (days == -1) {
            views.setTextViewText(R.id.widget_title, "💕 Reunited Countdown");
            views.setTextViewText(R.id.widget_days, "⏳");
            views.setTextViewText(R.id.widget_hours, "⏳");
            views.setTextViewText(R.id.widget_minutes, "⏳");
            views.setTextViewText(R.id.widget_seconds, "⏳");
        } else {
            views.setTextViewText(R.id.widget_title, "💕 Reunited Countdown");
            views.setTextViewText(R.id.widget_days,    String.format("%02d", days));
            views.setTextViewText(R.id.widget_hours,   String.format("%02d", hours));
            views.setTextViewText(R.id.widget_minutes, String.format("%02d", minutes));
            views.setTextViewText(R.id.widget_seconds, String.format("%02d", seconds));
        }

        Intent openApp = new Intent(context, MainActivity.class);
        android.app.PendingIntent openPi = android.app.PendingIntent.getActivity(context, 0, openApp,
                android.app.PendingIntent.FLAG_UPDATE_CURRENT | android.app.PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_container, openPi);

        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    public static void updateAllWidgets(Context context) {
        AppWidgetManager manager = AppWidgetManager.getInstance(context);
        int[] ids = manager.getAppWidgetIds(new ComponentName(context, CountdownWidgetProvider.class));
        for (int id : ids) {
            updateWidget(context, manager, id);
        }
    }

    // --- Countdown calculation ---

    private static long[] calculateCountdown(String reunionDateStr, String timezone) {
        try {
            SimpleDateFormat sdf = tryParse(reunionDateStr);
            if (sdf == null) return null;
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
            long reunionNaiveMs = sdf.parse(reunionDateStr).getTime();
            int destOffsetHours = getTimezoneOffset(timezone);
            long reunionUTC = reunionNaiveMs - (long) destOffsetHours * 3_600_000L;
            long remainingMs = reunionUTC - System.currentTimeMillis();
            return new long[]{ Math.max(0, remainingMs / 1000) };
        } catch (Exception e) {
            return null;
        }
    }

    private static SimpleDateFormat tryParse(String s) {
        if (s != null && s.length() >= 23 && s.charAt(19) == '.') {
            return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US);
        } else if (s != null && s.length() >= 19) {
            return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US);
        }
        return null;
    }

    private static int getTimezoneOffset(String timezone) {
        if ("France".equals(timezone)) {
            return TimeZone.getTimeZone("Europe/Paris")
                    .getOffset(System.currentTimeMillis()) / 3_600_000;
        } else if ("Indonesia".equals(timezone)) {
            return 7;
        }
        return 0;
    }
}
