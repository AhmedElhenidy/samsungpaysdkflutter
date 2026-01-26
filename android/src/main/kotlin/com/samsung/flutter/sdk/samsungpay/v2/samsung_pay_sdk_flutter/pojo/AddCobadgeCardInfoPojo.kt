package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName

data class AddCobadgeCardInfoPojo(

    @field:SerializedName("primaryAddCardInfo")
    val primaryAddCardInfo: JsonObject,

    @field:SerializedName("secondaryAddCardInfo")
    val secondaryAddCardInfo: JsonObject,
)