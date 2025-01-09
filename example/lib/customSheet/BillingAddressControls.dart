import 'package:samsung_pay_sdk_flutter/model/address.dart';
import 'package:samsung_pay_sdk_flutter/model/address_control.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_listener.dart';
import 'package:samsung_pay_sdk_flutter/spay_core.dart';
import '../util/Strings.dart';

class BillingAddressControls{
  bool mNeedCustomErrorMessage = false;

  AddressControl makeBillingAddress(SheetUpdatedListener billingListener) {
    AddressControl billingAddressControl =
    AddressControl(Strings.BILLING_ADDRESS_ID, SheetItemType.BILLING_ADDRESS.name);
    billingAddressControl.setAddressTitle(Strings.billing_address);
    billingAddressControl.sheetUpdatedListener = billingListener;
    return billingAddressControl;
  }

  AddressControl makeBillingAddressWithZipCodeOnly(SheetUpdatedListener billingListener) {
    AddressControl billingAddressControl =
    AddressControl(Strings.BILLING_ADDRESS_ID, SheetItemType.ZIP_ONLY_ADDRESS.name);
    billingAddressControl.setAddressTitle(Strings.billing_address);
    billingAddressControl.sheetUpdatedListener = billingListener;
    return billingAddressControl;
  }

  int validateBillingAddress(Address? address, selectedItem) {
    mNeedCustomErrorMessage = false;
    if (address == null) {
      return SpaySdk.ERROR_BILLING_ADDRESS_INVALID;
    }
    int ret;
    String selectedString = selectedItem;
    switch (selectedString) {
      case "ERROR_BILLING_ADDRESS_INVALID":
        ret = SpaySdk.ERROR_BILLING_ADDRESS_INVALID;
        break;
      case "ERROR_BILLING_ADDRESS_NOT_EXIST":
        ret = SpaySdk.ERROR_BILLING_ADDRESS_NOT_EXIST;
        break;
      case "CUSTOM_ERROR_MESSAGE":
        mNeedCustomErrorMessage = true;
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

  Address buildBillingAddressInfo() {
    Address mAddress;
    mAddress = Address(addressee: "Fowziya",
        addressLine1: "100",
        addressLine2: "SRBD",
        city: "Dhaka",
        state: "dhk",
        countryCode: "USA",
        postalCode: "1206",
        phoneNumber: "+1234567",
        email: "ABC@h.com");

    return mAddress;
  }

}