

import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

import '../main.dart';
import '../util/Strings.dart';

class ShippingAddressControls{

  bool mIsCustomErrorMessage = false;
  bool mNeedAllShippingMethodItems = false;

  AddressControl makeShippingAddress(SheetUpdatedListener shippingListener) {
    AddressControl shippingAddressControl = AddressControl(Strings.SHIPPING_ADDRESS_ID, SheetItemType.SHIPPING_ADDRESS.name);
    shippingAddressControl.address = buildShippingAddressInfo();
    shippingAddressControl.setAddressTitle(Strings.shipping_address);
    shippingAddressControl.sheetUpdatedListener = shippingListener;
    int displayOptionValue = SpaySdk.DISPLAY_OPTION_ADDRESSEE;
    if (MyHomePage.shippingAddressCB!) {
      displayOptionValue += SpaySdk.DISPLAY_OPTION_ADDRESS;
    }
    if (MyHomePage.shippingPhoneCB!) {
      displayOptionValue += SpaySdk.DISPLAY_OPTION_PHONE_NUMBER;
    }
    if (MyHomePage.shippingEmailCB!) {
      displayOptionValue += SpaySdk.DISPLAY_OPTION_EMAIL;
    }

    shippingAddressControl.displayOption = displayOptionValue;
    return shippingAddressControl;
  }

  Address buildShippingAddressInfo() {
    Address mAddress;
    mAddress = Address(addressee: "Adam",
        addressLine1: "708",
        addressLine2: "1st_Avenue_SE",
        city: "Bellevue",
        state: "WA",
        countryCode: "USA",
        postalCode: "98005",
        phoneNumber: "+18002563789",
        email: "sample@h.com");

    return mAddress;
  }

  SpinnerControl makeShippingMethodSpinnerControl(SheetUpdatedListener shippingMethodListener, double? selectedShippingMethod) {
    SpinnerControl spinnerControl = SpinnerControl(
      Strings.SHIPPING_METHOD_SPINNER_ID,
      Strings.shipping_method,
      SheetItemType.SHIPPING_METHOD_SPINNER.name
    );

    if(selectedShippingMethod == 0.0){
      spinnerControl.addItem(Strings.SHIPPING_METHOD_1, Strings.standard_shipping_free);
      spinnerControl.selectedItemId = Strings.SHIPPING_METHOD_1;
    }else if(selectedShippingMethod == 0.1){
      spinnerControl.addItem(Strings.SHIPPING_METHOD_2, Strings.two_days_shipping);
      spinnerControl.selectedItemId = Strings.SHIPPING_METHOD_2;
    }else if(selectedShippingMethod == 0.2){
      spinnerControl.addItem(Strings.SHIPPING_METHOD_3, Strings.one_day_shipping);
      spinnerControl.selectedItemId = Strings.SHIPPING_METHOD_3;
    }else {
      spinnerControl.addItem(Strings.SHIPPING_METHOD_1, Strings.standard_shipping_free);
      spinnerControl.selectedItemId = Strings.SHIPPING_METHOD_1;
    }

    if(mNeedAllShippingMethodItems){
      if(!spinnerControl.existItem(Strings.SHIPPING_METHOD_1)){
        spinnerControl.addItem(Strings.SHIPPING_METHOD_1, Strings.standard_shipping_free);
      }
      if(!spinnerControl.existItem(Strings.SHIPPING_METHOD_2)){
        spinnerControl.addItem(Strings.SHIPPING_METHOD_2, Strings.two_days_shipping);
      }
      if(!spinnerControl.existItem(Strings.SHIPPING_METHOD_3)){
        spinnerControl.addItem(Strings.SHIPPING_METHOD_3, Strings.one_day_shipping);
      }
    }

    spinnerControl.sheetUpdatedListener = shippingMethodListener;
    return spinnerControl;
  }

  int validateShippingAddress(Address? address, selectedItem) {
    mIsCustomErrorMessage = false;
    int ret = SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID;

    String selectedString = selectedItem;
    switch (selectedString) {
      case "ERROR_SHIPPING_ADDRESS_INVALID":
        ret = SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID;
        break;
      case "ERROR_SHIPPING_ADDRESS_NOT_EXIST":
        ret = SpaySdk.ERROR_SHIPPING_ADDRESS_NOT_EXIST;
        break;
      case "ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP":
        ret = SpaySdk.ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP;
        break;
      case "CUSTOM_ERROR_MESSAGE":
        mIsCustomErrorMessage = true;
        ret = SpaySdk.ERROR_NONE;
        break;
      case "ERROR_NONE":
        ret = SpaySdk.ERROR_NONE;
        break;
      default:
        ret = SpaySdk.ERROR_NONE;
        break;
    }
    return ret;
  }
}