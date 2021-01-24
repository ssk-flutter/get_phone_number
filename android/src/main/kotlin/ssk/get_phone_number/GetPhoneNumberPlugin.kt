package ssk.get_phone_number

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONArray
import java.lang.ref.WeakReference
import java.util.*


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
            "getPhoneNumber" -> {
                try {
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
            "testPhoneNumber" -> {
                generateMobileNumber(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private val telephonyManager
        get() = activity.get()!!.getSystemService(Context.TELEPHONY_SERVICE) as
                TelephonyManager

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

    @SuppressLint("HardwareIds")
    private fun generateMobileNumber(result: Result) {
        val simJsonArray = JSONArray()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            for (subscriptionInfo in getSubscriptions()) {
                val simCard = SimCard(telephonyManager, subscriptionInfo)
                simJsonArray.put(simCard.toJSON())
            }
        }
        if (simJsonArray.length() == 0) {
            val simCard: SimCard? = getSingleSimCard()
            if (simCard != null) {
                simJsonArray.put(simCard.toJSON())
            }
        }
        if (simJsonArray.toString().isEmpty()) {
            Log.d("UNAVAILABLE", "No phone number on sim card#3")
            result.error("UNAVAILABLE", "No phone number on sim card", null)
        } else result.success(simJsonArray.toString())
    }

    @SuppressLint("HardwareIds")
    fun getSingleSimCard(): SimCard? {
        if (ActivityCompat.checkSelfPermission(activity.get()!!, Manifest.permission.READ_PHONE_NUMBERS) === PackageManager.PERMISSION_DENIED
                && ActivityCompat.checkSelfPermission(activity.get()!!, Manifest.permission.READ_PHONE_STATE) === PackageManager.PERMISSION_DENIED) {
            Log.e("UNAVAILABLE", "No phone number on sim card Permission Denied#2", null)
            return null
        } else if (telephonyManager.getLine1Number() == null || telephonyManager.getLine1Number().isEmpty()) {
            Log.e("UNAVAILABLE", "No phone number on sim card#2", null)
            return null
        }
        return SimCard(telephonyManager)
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    fun getSubscriptions(): List<SubscriptionInfo> {
        val subscriptionManager: SubscriptionManager = activity.get()!!.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
        if (ActivityCompat.checkSelfPermission(activity.get()!!, Manifest.permission.READ_PHONE_NUMBERS) === PackageManager.PERMISSION_DENIED
                && ActivityCompat.checkSelfPermission(activity.get()!!, Manifest.permission.READ_PHONE_STATE) === PackageManager.PERMISSION_DENIED) {
            Log.e("UNAVAILABLE", "No phone number on sim card Permission Denied#1", null)
            return ArrayList()
        } else if (subscriptionManager == null) {
            Log.e("UNAVAILABLE", "No phone number on sim card#1", null)
            return ArrayList()
        }
        return subscriptionManager.getActiveSubscriptionInfoList()
    }
}
