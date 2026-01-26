
import '../samsung_pay_sdk_flutter.dart';

/// This class provides APIs to fetch Payment information details with custom payment sheet information. 
/// That is, transaction details set by the merchant app.
///

class CustomSheetPaymentInfo {
  String? merchantId;
  String merchantName;
  String? orderNumber;
  AddressInPaymentSheet? addressInPaymentSheet;
  List<Brand>? allowedCardBrand;
  PaymentCardInfo? cardInfo;
  bool? isCardHolderNameRequired;
  bool? isRecurring;
  String? merchantCountryCode;
  CustomSheet customSheet;
  Map<String,dynamic>? extraPaymentInfo;


  CustomSheetPaymentInfo({
    required this.merchantName,
    required this.customSheet,
    this.orderNumber
  });

  /// API to set the address display option for payment sheet.
  ///
  /// [addressInPaymentSheet] Address UI to display on the payment sheet.
  ///

  void setAddressInPaymentSheet(AddressInPaymentSheet addressInPaymentSheet){
    this.addressInPaymentSheet = addressInPaymentSheet;
  }

  /// API to set the card brands list supported by merchant.
  ///
  /// [brands] Card brands supported by merchant for payment.
  ///

  void setAllowedCardBrands(List<Brand> brands){
    allowedCardBrand = brands;
  }

  /// API to set the flag if merchant wants to display card holder's name.  
  ///
  /// Set to 'true' if card holder's name should be displayed with card information on the payment sheet. 
  /// If issuer does not provide card holder's name, it will not be displayed.
  ///
  /// [isCardHolderNameRequired] True, if merchant wants to display card holder's name on the payment sheet.
  ///

  void setCardHolderNameEnabled(bool isCardHolderNameRequired){
    this.isCardHolderNameRequired = isCardHolderNameRequired;
  }

  /// API to set customSheet. 
  ///
  /// [customSheet] CustomSheet configured by merchant.
  ///

  void setCustomSheet(CustomSheet customSheet){
    this.customSheet = customSheet;
  }

  /// API to set the extra payment information data.
  ///
  /// [extraPaymentInfo] Extra PaymentInfo data.
  ///

  void setExtraPaymentInfo(Map<String,dynamic> extraPaymentInfo){
    this.extraPaymentInfo = extraPaymentInfo;
  }

  /// API to set the merchant country code.  
  /// This API internally verifies and sets two-letter merchant country code, if it is a valid country code.
  ///
  /// [merchantCountryCode] Country code, where merchant is operating.
  ///
  /// **Exceptions:**
  /// Throws an [ArgumentError] if merchantCountryCode is invalid. 
  ///

  void setMerchantCountryCode(String merchantCountryCode){
    this.merchantCountryCode = merchantCountryCode;
  }

  /// API to set the merchant reference ID.
  ///
  /// [merchantId] Merchant reference ID which can be used for merchant's own purpose. 
  ///         For example, if merchant uses a Payment Gateway which requires Payment Gateway User ID,
  ///         then merchantId field can be set with a Payment Gateway User ID. 
  ///

  void setMerchantId(String merchantId){
    this.merchantId = merchantId;
  }

  /// API to set the merchant name.
  ///
  /// [merchantName] Merchant name.
  ///

  void setMerchantName(String merchantName){
    this.merchantName = merchantName;
  }

  /// API to set the order number.
  /// [orderNumber] Order number sent by merchant for records. 
  /// The allowed characters are [A-Z][a-z][0-9,-] & up to 36 characters. 
  /// This field is mandatory for VISA.
  ///

  void setOrderNumber(String orderNumber){
    this.orderNumber = orderNumber;
  }

  /// API to set the card brand for payment transaction. 
  /// This API can be used with setPaymentCardLast4DPAN(String) or  
  /// setPaymentCardLast4FPAN(String) API method
  /// to designate specific card for the transaction. 
  ///
  /// [cardBrand] Card brand.
  ///

  void setPaymentCardBrand(Brand cardBrand){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] = cardBrand.name;
  }

  /// API to set the last 4 digits of DPAN for payment transaction. 
  /// This API can be used with setPaymentCardBrand(SpaySdk.Brand) API method
  /// to designate specific card for the transaction. 
  ///
  /// [last4digits] The last 4 digits of DPAN for payment transaction.
  ///

  void setPaymentCardLast4DPAN(String last4digits){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_LAST4_DPAN] = last4digits;
  }

  /// API to set the last 4 digits of FPAN for payment transaction. 
  /// This API can be used with setPaymentCardBrand(SpaySdk.Brand) API method
  /// to designate specific card for the transaction. 
  ///
  ///  [Parameters:] 
  /// [last4digits] The last 4 digits of FPAN for payment transaction.
  ///

  void setPaymentCardLast4FPAN(String last4digits){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_LAST4_FPAN] = last4digits;
  }

  /// API to set the shipping method for payment transaction. 
  ///
  /// [shippingMethod] Shipping method.
  ///

  void setPaymentShippingMethod(String shippingMethod){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_SHIPPING_METHOD] = shippingMethod;
  }

  /// API to set if payment is recurring.
  ///
  /// [isRecurring] True, if payment is recurring.
  ///

  void setRecurringEnabled(bool isRecurring){
    this.isRecurring = isRecurring;
  }

  /// API to set the transaction type for MADA payment transactions.
  ///
  /// This value is specifically supported for MADA tokens and will not apply to other token types.
  /// The possible values are: [TransactionType.PURCHASE] or [TransactionType.PREAUTHORIZATION].
  /// The default value is [TransactionType.PURCHASE].
  ///
  /// [transactionType] Transaction type for MADA payment.
  ///
  /// Since API Level 2.22
  ///
  void setTransactionType(TransactionType transactionType){
    _nullCheckExtraPaymentInfo();
    extraPaymentInfo![SpaySdk.EXTRA_ONLINE_TRANSACTION_TYPE] = transactionType.name;
  }

  /// API to get the transaction type for MADA payment transactions.
  ///
  /// Returns the transaction type set for MADA payments, or null if not set.
  ///
  /// Since API Level 2.22
  ///
  TransactionType? getTransactionType(){
    _nullCheckExtraPaymentInfo();
    if(extraPaymentInfo![SpaySdk.EXTRA_ONLINE_TRANSACTION_TYPE] == TransactionType.PURCHASE.name) {
      return TransactionType.PURCHASE;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_ONLINE_TRANSACTION_TYPE] == TransactionType.PREAUTHORIZATION.name) {
      return TransactionType.PREAUTHORIZATION;
    }
    return null;
  }

  ///@nodoc
  void _nullCheckExtraPaymentInfo(){
    if (this.extraPaymentInfo == null) {
      this.extraPaymentInfo = {};
    }
  }

  /// API to return the country code, where merchant is operating.
  /// Return Country code for region where merchant is operating.
  ///

  String? getMerchantCountryCode() {
    return merchantCountryCode;
  }

  /// API to return the merchant reference ID.
  ///
  /// Return Merchant reference ID which can be used for merchant's own purpose. 
  ///         For example, if merchant uses a Payment Gateway which requires Payment Gateway User ID,
  ///         then merchantId field can be set with a Payment Gateway User ID. 
  ///
  ///

  String? getMerchantId() {
    return merchantId;
  }

  /// API to return the merchant name.
  /// Return Merchant name.
  ///

  String getMerchantName() {
    return merchantName;
  }

  /// API to return the order number for transaction.
  /// Return Order number which is sent by merchant for records.
  ///

  String? getOrderNumber() {
    return orderNumber;
  }

  /// API to return the card brand which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return Card brand which was used in the current transaction.
  ///

  Brand? getPaymentCardBrand(){
    _nullCheckExtraPaymentInfo();
    if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.VISA.name) {
      return Brand.VISA;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.MASTERCARD.name) {
      return Brand.MASTERCARD;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.AMERICANEXPRESS.name) {
      return Brand.AMERICANEXPRESS;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.CHINAUNIONPAY.name) {
      return Brand.CHINAUNIONPAY;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.DISCOVER.name) {
      return Brand.DISCOVER;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.ECI.name) {
      return Brand.ECI;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.PAGOBANCOMAT.name) {
      return Brand.PAGOBANCOMAT;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.OCTOPUS.name) {
      return Brand.OCTOPUS;
    } else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.MADA.name) {
      return Brand.MADA;
    }else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.ELO.name) {
      return Brand.ELO;
    }else if(extraPaymentInfo![SpaySdk.EXTRA_CARD_BRAND] == Brand.UNKNOWN_CARD.name) {
      return Brand.UNKNOWN_CARD;
    }
    return Brand.UNKNOWN_CARD;
  }

  /// API to return the last 4 digits of DPAN which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return The last 4 digits of DPAN which was used in the current transaction.
  ///

  String? getPaymentCardLast4DPAN() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_LAST4_DPAN];
  }

  /// API to return the last 4 digits of FPAN which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return The last 4 digits of FPAN which was used in the current transaction.
  ///

  String? getPaymentCardLast4FPAN() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_LAST4_FPAN];
  }

  /// API to return the ISO currency code which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return Currency code which was used in the current transaction.
  ///

  String? getPaymentCurrencyCode() {
      for (SheetControl sheet in customSheet.getSheetControls()!) {
        if (sheet.controltype == Controltype.AMOUNTBOX) {
          AmountBoxControl amountBoxControl = sheet as AmountBoxControl;
          return amountBoxControl.currencyCode;
        }
      }
    return "";
  }

  /// API to return the shipping/delivery address which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return Shipping address which was used in the current transaction.
  ///

  Address? getPaymentShippingAddress() {
    for (SheetControl sheet in customSheet.getSheetControls()!) {
      if (sheet.controltype == Controltype.ADDRESS) {
        AddressControl addressControl = sheet as AddressControl;
        if (addressControl.getAddressType() == SheetItemType.SHIPPING_ADDRESS) {
          return addressControl.getAddress();
        }
      }
    }
      return null;
  }

  /// API to return the shipping method which was used in the current transaction. 
  /// Partner can get this information if needed. They can use this for their own purpose. 
  /// This API method can be used in
  /// [CustomSheetTransactionInfoListener.onSuccess(CustomSheetPaymentInfo, String, Bundle)] callback only. 
  ///
  /// This api is available only with US Samsung Wallet app. 
  /// Return Shipping method which was used in the current transaction.
  ///

  String getPaymentShippingMethod() {
    _nullCheckExtraPaymentInfo();
    return extraPaymentInfo![SpaySdk.EXTRA_SHIPPING_METHOD];
  }

  ///@nodoc
  factory CustomSheetPaymentInfo.fromJson(Map<String, dynamic> json, SheetUpdatedListener? sheetUpdatedListener){
    CustomSheet customSheet = CustomSheet();
    customSheet = CustomSheet.fromJson(json["customSheet"], sheetUpdatedListener);
    CustomSheetPaymentInfo customSheetPaymentInfo = CustomSheetPaymentInfo(merchantName: json["merchantName"].toString(), customSheet: customSheet);
    customSheetPaymentInfo.merchantId = json["merchantId"].toString();
    customSheetPaymentInfo.orderNumber = json["orderNumber"].toString();
    if(json["addressInPaymentSheet"] == AddressInPaymentSheet.DO_NOT_SHOW.name) {
      customSheetPaymentInfo.addressInPaymentSheet = AddressInPaymentSheet.DO_NOT_SHOW;
    } else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet = AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_BILLING_SPAY.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_BILLING_SPAY;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.NEED_SHIPPING_SPAY.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.NEED_SHIPPING_SPAY;
    else if(json["addressInPaymentSheet"] == AddressInPaymentSheet.SEND_SHIPPING.name)
      customSheetPaymentInfo.addressInPaymentSheet == AddressInPaymentSheet.SEND_SHIPPING;

    List<Brand> brandlist =[];
    if(json["allowedCardBrand"] == null){
      customSheetPaymentInfo.allowedCardBrand =  brandlist;
    }
    else{
      for(var brand in json["allowedCardBrand"]){
        if(brand == Brand.VISA.name) {
          brandlist.add(Brand.VISA);
        } else if(brand == Brand.MASTERCARD.name) {
          brandlist.add(Brand.MASTERCARD);
        } else if(brand == Brand.AMERICANEXPRESS.name) {
          brandlist.add(Brand.AMERICANEXPRESS);
        } else if(brand == Brand.CHINAUNIONPAY.name) {
          brandlist.add(Brand.CHINAUNIONPAY);
        } else if(brand == Brand.DISCOVER.name) {
          brandlist.add(Brand.DISCOVER);
        } else if(brand == Brand.ECI.name) {
          brandlist.add(Brand.ECI);
        } else if(brand == Brand.PAGOBANCOMAT.name) {
          brandlist.add(Brand.PAGOBANCOMAT);
        } else if(brand == Brand.OCTOPUS.name) {
          brandlist.add(Brand.OCTOPUS);
        }else if(brand == Brand.ELO.name) {
          brandlist.add(Brand.ELO);
        }else if(brand == Brand.MADA.name) {
          brandlist.add(Brand.MADA);
        }
      }
      customSheetPaymentInfo.allowedCardBrand =  brandlist;
    }
    customSheetPaymentInfo.isCardHolderNameRequired = json["isCardHolderNameRequired"];
    customSheetPaymentInfo.isRecurring = json["isRecurring"];
    customSheetPaymentInfo.merchantCountryCode = json["merchantCountryCode"].toString();
    customSheetPaymentInfo.extraPaymentInfo = json["extraPaymentInfo"];
    if(json["cardInfo"] != null) {
      customSheetPaymentInfo.cardInfo = PaymentCardInfo.fromJson(json["cardInfo"]);
    }

    return customSheetPaymentInfo;
  }

  ///@nodoc
  Map<String, dynamic> toJson() {
    Map<String,dynamic> customSheetPaymentInfoJson={};
    if(merchantId!= null) {
      customSheetPaymentInfoJson["merchantId"] = merchantId;
    }
    customSheetPaymentInfoJson["merchantName"] = merchantName;
    if(orderNumber != null){
      customSheetPaymentInfoJson["orderNumber"] = orderNumber;
    }
    if(addressInPaymentSheet?.name != null) {
      customSheetPaymentInfoJson["addressInPaymentSheet"] = addressInPaymentSheet?.name;
    }
    if(allowedCardBrand != null){
      customSheetPaymentInfoJson["allowedCardBrand"] = allowedCardBrand?.map((x) => x.name).toList();
    }
    if(isCardHolderNameRequired!= null) {
      customSheetPaymentInfoJson["isCardHolderNameRequired"] =
          isCardHolderNameRequired;
    }
    if(isRecurring != null) {
      customSheetPaymentInfoJson["isRecurring"] = isRecurring;
    }
    if(merchantCountryCode!= null) {
      customSheetPaymentInfoJson["merchantCountryCode"] = merchantCountryCode;
    }
    customSheetPaymentInfoJson["customSheet"] = customSheet.toJson();
    if(extraPaymentInfo != null){
      customSheetPaymentInfoJson["extraPaymentInfo"] = extraPaymentInfo;
    }
    return customSheetPaymentInfoJson;
  }
}
