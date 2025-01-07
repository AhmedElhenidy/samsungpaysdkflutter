import 'package:samsung_pay_sdk_flutter/model/amount_box_control.dart';
import 'package:samsung_pay_sdk_flutter/model/custom_sheet.dart';
import 'package:samsung_pay_sdk_flutter/spay_core.dart';
import '../util/Strings.dart';

import '../main.dart';

class AmountDetailControls{

  String AMOUNT_CONTROL_ID = "amountControlId";
  String PRODUCT_ITEM_ID = "productItemId";
  String PRODUCT_TAX_ID = "productTaxId";
  String PRODUCT_SHIPPING_ID = "productShippingId";
  String PRODUCT_FUEL_ID = "productFuelId";
  String DECIMAL_VALUE_ZERO = "00";

  double mDiscountedProductAmount = 1000.0;
  double mTaxAmount = 50.0;
  double mShippingAmount = 10.0;
  double mAddedShippingAmount = 0.0;
  double mAddedBillingAmount = 0.0;
  double mProductAmount = 1000.0;

  AmountBoxControl makeAmountControl(String currency) {
    AmountBoxControl amountBoxControl = AmountBoxControl(AMOUNT_CONTROL_ID, currency);
    amountBoxControl.addItem(
        PRODUCT_ITEM_ID,
        Strings.amount_control_name_item,
        mDiscountedProductAmount,
        "");
    amountBoxControl.addItem(
        PRODUCT_TAX_ID,
        Strings.amount_control_name_tax,
        mTaxAmount + mAddedBillingAmount,
        "");
    amountBoxControl.addItem(
        PRODUCT_SHIPPING_ID,
        Strings.amount_control_name_shipping,
        mShippingAmount + mAddedShippingAmount,
        "");
    amountBoxControl.setAmountTotal(totalAmount(), amountFormat());
    return amountBoxControl;
  }

  double totalAmount()
  {
    //TODO Get data from UI
    return mProductAmount + mTaxAmount + mAddedBillingAmount + mShippingAmount + mAddedShippingAmount;
  }
  String amountFormat()
  {
    String selectedString = MyHomePage.amountFormatList.first;
    switch (selectedString) {
      case "FORMAT_TOTAL_PRICE_ONLY":
        selectedString = SpaySdk.FORMAT_TOTAL_PRICE_ONLY;
        break;
      case "FORMAT_TOTAL_ESTIMATED_AMOUNT":
        selectedString = SpaySdk.FORMAT_TOTAL_ESTIMATED_AMOUNT;
        break;
      case "FORMAT_TOTAL_ESTIMATED_CHARGE":
        selectedString = SpaySdk.FORMAT_TOTAL_ESTIMATED_CHARGE;
        break;
      case "FORMAT_TOTAL_ESTIMATED_FARE":
        selectedString = SpaySdk.FORMAT_TOTAL_ESTIMATED_FARE;
        break;
      case "FORMAT_TOTAL_FREE_TEXT_ONLY":
        selectedString = SpaySdk.FORMAT_TOTAL_FREE_TEXT_ONLY;
        break;
      case "FORMAT_TOTAL_AMOUNT_PENDING":
        selectedString = SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING;
        break;
      case "FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY":
        selectedString = SpaySdk.FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY;
        break;
      case "FORMAT_TOTAL_PENDING":
        selectedString = SpaySdk.FORMAT_TOTAL_PENDING;
        break;
      case "FORMAT_TOTAL_PENDING_TEXT_ONLY":
        selectedString = SpaySdk.FORMAT_TOTAL_PENDING_TEXT_ONLY;
        break;
      default:
        print("Wrong Amount Format!");
    }
    return selectedString;
  }

  CustomSheet updateAmountControl(CustomSheet sheet) {
    AmountBoxControl amountBoxControl = sheet.getSheetControl(AMOUNT_CONTROL_ID) as AmountBoxControl;
    amountBoxControl.updateValue(PRODUCT_ITEM_ID, mDiscountedProductAmount);
    amountBoxControl.updateValue(PRODUCT_TAX_ID, mTaxAmount + mAddedBillingAmount);
    amountBoxControl.updateValue(PRODUCT_SHIPPING_ID, mShippingAmount + mAddedShippingAmount);
    // if (!amountBoxControl.existItem(PRODUCT_FUEL_ID)) {
    //   amountBoxControl.addItem(
    //       3,
    //       PRODUCT_FUEL_ID,
    //       mContext.getString(R.string.amount_control_name_fuel),
    //       0.0,
    //       mContext.getString(
    //           R.string.amount_control_pending
    //       )
    //   );
    // } else {
    //   amountBoxControl.updateValue(
    //       PRODUCT_FUEL_ID,
    //       0.0,
    //       mContext.getString(R.string.amount_control_pending)
    //   );
    // }
    // amountBoxControl.setAmountTotal(totalAmount, amountFormat);
    amountBoxControl.setAmountTotal(totalAmount(), amountFormat());
    sheet.updateControl(amountBoxControl);
    return sheet;
  }

  void setAddedShippingAmount(double? amount) {
    mAddedShippingAmount = amount!;
  }
}