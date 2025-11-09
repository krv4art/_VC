package com.unseen.app

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NotificationChannelHandler(
    private val context: Context,
    methodChannel: MethodChannel,
    eventChannel: EventChannel
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    companion object {
        private const val TAG = "NotificationChannelHandler"
    }

    init {
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                result.success(true)
            }

            "isPermissionGranted" -> {
                val isGranted = isNotificationServiceEnabled()
                result.success(isGranted)
            }

            "openPermissionSettings" -> {
                openNotificationListenerSettings()
                result.success(null)
            }

            "startListening" -> {
                val isGranted = isNotificationServiceEnabled()
                if (isGranted) {
                    // Service should auto-start when enabled
                    result.success(true)
                } else {
                    result.success(false)
                }
            }

            "stopListening" -> {
                // NotificationListenerService stops automatically when disabled
                result.success(null)
            }

            "isMessengerSupported" -> {
                val packageName = call.argument<String>("packageName")
                val isSupported = packageName?.let {
                    isSupportedMessenger(it)
                } ?: false
                result.success(isSupported)
            }

            "getInstalledMessengers" -> {
                val installedMessengers = getInstalledMessengers()
                result.success(installedMessengers)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        UnseenNotificationListener.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        UnseenNotificationListener.eventSink = null
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val packageName = context.packageName
        val enabledListeners = Settings.Secure.getString(
            context.contentResolver,
            "enabled_notification_listeners"
        )

        return enabledListeners?.contains(packageName) == true
    }

    private fun openNotificationListenerSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    private fun isSupportedMessenger(packageName: String): Boolean {
        val supportedMessengers = setOf(
            "com.whatsapp",
            "org.telegram.messenger",
            "com.facebook.orca",
            "com.instagram.android",
            "com.viber.voip",
            "jp.naver.line.android",
            "com.zhiliaoapp.musically"
        )
        return supportedMessengers.contains(packageName)
    }

    private fun getInstalledMessengers(): List<String> {
        val supportedMessengers = listOf(
            "com.whatsapp",
            "org.telegram.messenger",
            "com.facebook.orca",
            "com.instagram.android",
            "com.viber.voip",
            "jp.naver.line.android",
            "com.zhiliaoapp.musically"
        )

        val packageManager = context.packageManager
        val installedMessengers = mutableListOf<String>()

        for (packageName in supportedMessengers) {
            try {
                packageManager.getPackageInfo(packageName, 0)
                installedMessengers.add(packageName)
            } catch (e: PackageManager.NameNotFoundException) {
                // Package not installed
            }
        }

        return installedMessengers
    }
}
