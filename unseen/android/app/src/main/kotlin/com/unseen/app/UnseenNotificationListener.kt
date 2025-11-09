package com.unseen.app

import android.app.Notification
import android.content.Intent
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class UnseenNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "UnseenNotificationListener"

        // Supported messenger packages
        private val SUPPORTED_MESSENGERS = setOf(
            "com.whatsapp",
            "org.telegram.messenger",
            "com.facebook.orca",
            "com.instagram.android",
            "com.viber.voip",
            "jp.naver.line.android",
            "com.zhiliaoapp.musically"
        )

        // Shared instance for communication
        var instance: UnseenNotificationListener? = null
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d(TAG, "UnseenNotificationListener created")
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
        eventSink = null
        Log.d(TAG, "UnseenNotificationListener destroyed")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        super.onNotificationPosted(sbn)

        val packageName = sbn.packageName

        // Check if this is from a supported messenger
        if (!SUPPORTED_MESSENGERS.contains(packageName)) {
            return
        }

        Log.d(TAG, "Notification from: $packageName")

        try {
            val notification = sbn.notification
            val extras = notification.extras

            // Extract notification data
            val notificationData = hashMapOf<String, Any?>(
                "id" to sbn.key,
                "packageName" to packageName,
                "timestamp" to sbn.postTime,
                "title" to extras.getCharSequence(Notification.EXTRA_TITLE)?.toString(),
                "text" to extras.getCharSequence(Notification.EXTRA_TEXT)?.toString(),
                "subText" to extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString(),
                "bigText" to extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString(),
            )

            // Send to Flutter through EventChannel
            eventSink?.success(notificationData)

            Log.d(TAG, "Notification sent to Flutter: ${notificationData["title"]}")

        } catch (e: Exception) {
            Log.e(TAG, "Error processing notification", e)
            eventSink?.error("NOTIFICATION_ERROR", e.message, null)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        super.onNotificationRemoved(sbn)

        val packageName = sbn.packageName

        if (SUPPORTED_MESSENGERS.contains(packageName)) {
            Log.d(TAG, "Notification removed from: $packageName")

            // Potentially handle deleted messages here
            val deletedData = hashMapOf<String, Any?>(
                "id" to sbn.key,
                "packageName" to packageName,
                "deleted" to true
            )

            // Could send deletion event to Flutter
            // eventSink?.success(deletedData)
        }
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d(TAG, "Notification listener connected")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.d(TAG, "Notification listener disconnected")

        // Attempt to reconnect
        val intent = Intent(this, UnseenNotificationListener::class.java)
        startService(intent)
    }
}
