package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils
import com.google.gson.Gson
import com.samsung.android.sdk.samsungpay.v2.card.AddCardInfo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddCardInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.AddCardInfoConverter
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddCobadgeCardInfoPojo
import io.flutter.Log

object AddCobadgeCardInfoConverter{
    fun getAddCobadgeCardInfo(addCoBadgeCardInfoJsonString: String): ArrayList<AddCardInfo> {
        val addCobadgeCardInfoPojo = Gson().fromJson(addCoBadgeCardInfoJsonString, AddCobadgeCardInfoPojo::class.java)
        var addCobadgeCardInfo = ArrayList<AddCardInfo>()

        val primaryAddCardInfoPojo = Gson().fromJson(addCobadgeCardInfoPojo.primaryAddCardInfo.toString(), AddCardInfoPojo::class.java)
        addCobadgeCardInfo.add(AddCardInfo(primaryAddCardInfoPojo.cardType.toString(),primaryAddCardInfoPojo.tokenizationProvider.toString(),primaryAddCardInfoPojo.getBundle()))

        val secondaryAddCardInfoPojo = Gson().fromJson(addCobadgeCardInfoPojo.secondaryAddCardInfo.toString(), AddCardInfoPojo::class.java)
        addCobadgeCardInfo.add(AddCardInfo(secondaryAddCardInfoPojo.cardType.toString(),secondaryAddCardInfoPojo.tokenizationProvider.toString(),secondaryAddCardInfoPojo.getBundle()))

        return addCobadgeCardInfo
    }
}