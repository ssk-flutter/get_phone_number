package ssk.get_phone_number

import androidx.annotation.RequiresApi
import android.os.Build
import android.telephony.TelephonyManager
import android.telephony.SubscriptionInfo
import android.annotation.SuppressLint
import org.json.JSONObject
import org.json.JSONException

class SimCard {
    private var carrierName = ""
    private var displayName = ""
    private var slotIndex = 0
    private var number = ""
    private var countryIso = ""
    private var countryPhonePrefix = ""

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP_MR1)
    constructor(telephonyManager: TelephonyManager, subscriptionInfo: SubscriptionInfo) {
        carrierName = subscriptionInfo.carrierName.toString()
        displayName = subscriptionInfo.displayName.toString()
        slotIndex = subscriptionInfo.simSlotIndex
        number = subscriptionInfo.number
        if (subscriptionInfo.countryIso != null && !subscriptionInfo.countryIso.isEmpty()) countryIso = subscriptionInfo.countryIso else if (telephonyManager.simCountryIso != null) countryIso = telephonyManager.simCountryIso
        countryPhonePrefix = CountryToPhonePrefix.prefixFor(countryIso)
    }

    @SuppressLint("MissingPermission", "HardwareIds")
    constructor(telephonyManager: TelephonyManager) {
        if (telephonyManager.simOperator != null) carrierName = telephonyManager.simOperatorName
        if (telephonyManager.simOperator != null) displayName = telephonyManager.simOperatorName
        if (telephonyManager.simCountryIso != null) {
            countryIso = telephonyManager.simCountryIso
            countryPhonePrefix = CountryToPhonePrefix.prefixFor(countryIso)
        }
        if (telephonyManager.line1Number != null && !telephonyManager.line1Number.isEmpty()) {
            if (telephonyManager.line1Number.startsWith("0")) number = countryPhonePrefix + telephonyManager.line1Number.substring(1)
            number = telephonyManager.line1Number
        }
    }

    // final JSONArray jsonArray = new JSONArray();
    fun toJSON(): JSONObject {
        val json = JSONObject()
        try {
            json.put("carrierName", carrierName)
            json.put("displayName", displayName)
            json.put("slotIndex", slotIndex)
            json.put("number", number)
            json.put("countryIso", countryIso)
            json.put("countryPhonePrefix", countryPhonePrefix)
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return json
    }
}