package com.reunited.countdown.reunited_countdown;

import android.app.AlarmManager;
import android.app.PendingIntent;
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

    private static final String ACTION_UPDATE = "com.reunited.countdown.ACTION_WIDGET_UPDATE";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
        scheduleNextUpdate(context);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        String action = intent.getAction();
        if (ACTION_UPDATE.equals(action) || Intent.ACTION_BOOT_COMPLETED.equals(action)) {
            AppWidgetManager manager = AppWidgetManager.getInstance(context);
            int[] ids = manager.getAppWidgetIds(new ComponentName(context, CountdownWidgetProvider.class));
            if (ids != null && ids.length > 0) {
                for (int id : ids) {
                    updateWidget(context, manager, id);
                }
            }
            scheduleNextUpdate(context);
        }
    }

    @Override
    public void onEnabled(Context context) {
        scheduleNextUpdate(context);
    }

    @Override
    public void onDisabled(Context context) {
        cancelUpdates(context);
    }

    // --- Alarm scheduling ---

    private static void scheduleNextUpdate(Context context) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        if (alarmManager == null) return;
        PendingIntent pi = buildPendingIntent(context);
        long triggerAt = System.currentTimeMillis() + 1000;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (alarmManager.canScheduleExactAlarms()) {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, triggerAt, pi);
            } else {
                alarmManager.setAndAllowWhileIdle(AlarmManager.RTC, triggerAt, pi);
            }
        } else {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC, triggerAt, pi);
        }
    }

    private static void cancelUpdates(Context context) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        if (alarmManager == null) return;
        alarmManager.cancel(buildPendingIntent(context));
    }

    private static PendingIntent buildPendingIntent(Context context) {
        Intent intent = new Intent(context, CountdownWidgetProvider.class);
        intent.setAction(ACTION_UPDATE);
        return PendingIntent.getBroadcast(context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
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
                // Parse failed — fallback to pre-calculated values
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
        PendingIntent openPi = PendingIntent.getActivity(context, 0, openApp,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        views.setOnClickPendingIntent(R.id.widget_container, openPi);

        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    public static void updateAllWidgets(Context context) {
        AppWidgetManager manager = AppWidgetManager.getInstance(context);
        int[] ids = manager.getAppWidgetIds(new ComponentName(context, CountdownWidgetProvider.class));
        for (int id : ids) {
            updateWidget(context, manager, id);
        }
        // Restart the alarm chain (needed after fresh install or if chain was interrupted)
        scheduleNextUpdate(context);
    }

    // --- Countdown calculation ---

    // Returns [remainingSeconds] or null on parse error.
    // reunionDateStr is an ISO 8601 naive datetime representing the time in destTimezone.
    private static long[] calculateCountdown(String reunionDateStr, String timezone) {
        try {
            // Parse as if the date were UTC to get the "naive" epoch value
            SimpleDateFormat sdf = tryParse(reunionDateStr);
            if (sdf == null) return null;
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
            long reunionNaiveMs = sdf.parse(reunionDateStr).getTime();

            // Offset of the destination timezone (hours)
            int destOffsetHours = getTimezoneOffset(timezone);

            // Actual UTC epoch of the reunion
            long reunionUTC = reunionNaiveMs - (long) destOffsetHours * 3600_000L;

            long remainingMs = reunionUTC - System.currentTimeMillis();
            return new long[]{ Math.max(0, remainingMs / 1000) };
        } catch (Exception e) {
            return null;
        }
    }

    private static SimpleDateFormat tryParse(String s) {
        // Flutter emits: 2026-07-01T14:30:00.000 (with ms) or 2026-07-01T14:30:00
        if (s.length() >= 23 && s.charAt(19) == '.') {
            return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US);
        } else if (s.length() >= 19) {
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
