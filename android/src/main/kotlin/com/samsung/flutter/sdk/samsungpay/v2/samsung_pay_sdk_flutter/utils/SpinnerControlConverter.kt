package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetControl
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItem
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetUpdatedListener
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SpinnerControl
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.SheetItemPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.SpinnerControlPojo
import java.util.ArrayList


object SpinnerControlConverter {
    fun getSpinnerControl (spinnerControlJsonString: String, sheetUpdatedListener: SheetUpdatedListener?): SpinnerControl {
        val spinnerControlPojo = Gson().fromJson(spinnerControlJsonString, SpinnerControlPojo::class.java)

        val itemList: ArrayList<SheetItem> = spinnerControlPojo.getSheetItem();
        val spinnerControl = SpinnerControl(spinnerControlPojo.controlId, spinnerControlPojo.getSheetItem().elementAt(0).title,spinnerControlPojo.getSheetItem().elementAt(0).sheetItemType)

        for (i in 1 until itemList.size) {
            val sheetItem = itemList[i]
            spinnerControl.addItem(sheetItem.id,sheetItem.sValue)
        }
        if(spinnerControlPojo.selectedItemId!=null)
            spinnerControl.selectedItemId=spinnerControlPojo.selectedItemId
        spinnerControl.sheetUpdatedListener = sheetUpdatedListener
        return spinnerControl
    }
    fun makeSpinnerControlJson(spinnerControl: SpinnerControl): JsonObject
    {
        var sheetItem = JsonArray()

        spinnerControl.items.forEach{

            if(it.sheetItemType!=null)
            {
                sheetItem.add(Gson().toJson(SheetItemPojo(it.id, it.title, null, null, it.sheetItemType.toString())))
            }
            else
            {
                sheetItem.add(Gson().toJson(SheetItemPojo(it.id, null, it.sValue, null)))
            }
        }
        return Gson().fromJson(Gson().toJson(SpinnerControlPojo(SheetControl.Controltype.SPINNER.name, spinnerControl.controlId, sheetItem,spinnerControl.selectedItemId)), JsonObject::class.java)
    }
}