package com.samsung.android.flutter.spay.sample.merchant.sample_merchant

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity: FlutterActivity() {

    private val CHANNEL = "spaysdkflutter.merchant.sample"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when(call.method){
                "getISOCountries" -> {
                    print(call.toString())
                    try {
                        result.success(createCountryList())
                    }catch (e: Exception){
                        result.error("404", e.localizedMessage, e.toString())
                        e.printStackTrace()
                    }
                }
            }

        }
    }

    private fun createCountryList() : List<String> {
        val codes = Locale.getISOCountries()
        val countryList = ArrayList<String>()
        for (code2Digit in codes) {
            val locale = Locale("", code2Digit)
            countryList.add(locale.isO3Country.toString())
        }
        countryList.sort()
        return countryList
    }
}
