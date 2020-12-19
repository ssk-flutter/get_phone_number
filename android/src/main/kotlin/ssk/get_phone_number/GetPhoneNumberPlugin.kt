package ssk.get_phone_number

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.lang.ref.WeakReference

/** GetPhoneNumberPlugin */
class GetPhoneNumberPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity = WeakReference<Activity>(null)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ssk.d/get_phone_number")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getPhoneNumber" -> {
                try {
                    val telephonyManager = activity.get()!!.getSystemService(Context.TELEPHONY_SERVICE) as
                            TelephonyManager
                    result.success(telephonyManager.line1Number ?: "")
                } catch (e: Exception) {
                    result.error("PERMISSION", "${e.message}", e.cause?.message)
                }
            }
            "hasPermission" -> {
                result.success(hasPermission())
            }
            "requestPermission" -> {
                ActivityCompat.requestPermissions(activity.get()!!, arrayOf(Manifest.permission.READ_PHONE_STATE), 10101)
                this.flutterResultPermission = result
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    private fun hasPermission() = listOf(
            Manifest.permission.READ_SMS,
            Manifest.permission.READ_PHONE_NUMBERS,
            Manifest.permission.READ_PHONE_STATE).any {
        ActivityCompat.checkSelfPermission(activity.get()!!, it) == PackageManager.PERMISSION_GRANTED
    }

    private var flutterResultPermission: MethodChannel.Result? = null

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String?>,
                                            grantResults: IntArray): Boolean {
        when (requestCode) {
            10101 -> {
                check(flutterResultPermission != null)
                flutterResultPermission?.success(grantResults.first() == PackageManager.PERMISSION_GRANTED)

                return true
            }
        }

        flutterResultPermission?.error("PERMISSION", "Permission is not granted.", null)
        return false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = WeakReference(binding.activity)
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
