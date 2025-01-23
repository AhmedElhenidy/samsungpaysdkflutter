import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';

/// This class provides AddressControl on custom payment sheet. 
///
/// AddressControl is used for displaying billing address or shipping address 
/// on custom payment sheet from "My Info" menu option on Samsung Wallet app. 
///  
/// [Caution]: AddressControl must be returned in onResult() on SheetUpdatedListener 
///            to remove progress bar on custom payment sheet. 
///

class AddressControl extends SheetControl{
  static const String EXTRA_DISPLAY_OPTION = "extra_display_option";

  SheetItem? sheetItem;
  Address? address;
  int? displayOption;
  int? errorCode;
  SheetUpdatedListener? sheetUpdatedListener;

  /// Constructor to create AddressControl. 
  ///
  ///  [Parameters:] 
  ///  [controlId] Unique ID to represent the AddressControl. 
  ///              This ID is used to compare and identify the other SheetControls. 
  ///
  /// [sheetItemType] SheetItemType represents billing address or shipping address. 
  ///       
  ///      The possible values are: 
  ///        [SheetItemType.BILLING_ADDRESS] 
  ///        [SheetItemType.ZIP_ONLY_ADDRESS] 
  ///        [SheetItemType.SHIPPING_ADDRESS] 
  ///      It is possible to show only one billing AddressControl and one shipping AddressControl. 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if controlId is null or empty. 
  /// Throws an [ArgumentError] if sheetItemType is not 
  ///         [sheetItemType.BILLING_ADDRESS] or 
  ///         [sheetItemType.ZIP_ONLY_ADDRESS] or 
  ///         [sheetItemType.SHIPPING_ADDRESS] 
  ///
  ///
  AddressControl(String controlId, String sheetItemType): super(controltype: Controltype.ADDRESS){
    setControlId(controlId);
    if ((sheetItemType == SheetItemType.BILLING_ADDRESS.name) || (sheetItemType == SheetItemType.SHIPPING_ADDRESS.name) || (sheetItemType == SheetItemType.ZIP_ONLY_ADDRESS.name)){
      sheetItem = SheetItem(sheetItemType: sheetItemType);
    } else {
      throw ArgumentError("AddressControl : sheetItemType must be either BILLING_ADDRESS or " + "SHIPPING_ADDRESS or" + "ZIP_ONLY_ADDRESS.");
    }
  }

  ///
  /// API to get address.  
  ///
  /// Return The address of the AddressControl.
  ///
  ///
  Address? getAddress(){
    return address;
  }

  ///
  /// API to set address.  
  ///
  ///  [Parameters:] 
  /// [address] Address to be set.  
  ///       
  ///       The possible values are: 
  ///         [SheetItemType.BILLING_ADDRESS] 
  ///         [SheetItemType.SHIPPING_ADDRESS] 
  ///       
  ///
  ///
  void setAddress(Address address){
    this.address=address;
  }

  ///
  /// API to get address title.  
  ///
  /// Return Title of the AddressControl.
  ///
  ///
  String? getAddressTitle(){
    return sheetItem?.title;
  }

  ///
  /// API to get address type.  
  ///
  /// Return SheetItemType of the AddressControl. 
  ///       
  ///      The returned value can be one of the following SheetItemTypes: 
  ///       [SheetItemType.BILLING_ADDRESS] 
  ///       [SheetItemType.SHIPPING_ADDRESS] 
  ///       
  ///
  ///
  SheetItemType? getAddressType(){
    if(sheetItem!.sheetItemType == SheetItemType.SHIPPING_ADDRESS.name) {
      return SheetItemType.SHIPPING_ADDRESS;
    } else {
      return SheetItemType.BILLING_ADDRESS;
    }
  }

  ///
  /// API to set address title.  
  ///
  ///  [Parameters:] 
  /// [title] Title of the AddressControl. 
  ///         If title is empty like "", then default title is displayed. 
  ///
  ///  [Exceptions:] 
  /// [Throws an [ArgumentError] if title is null. 
  ///
  ///
  void setAddressTitle(String title){
    sheetItem!.title= title;
  }

  ///
  /// API to get display option of [SheetItemType.SHIPPING_ADDRESS] on custom payment sheet.  
  ///
  /// Return Current display option of shipping address on custom payment sheet 
  ///       
  ///      The returned value will be a combination of below constants: 
  ///       [SpaySdk.DISPLAY_OPTION_ADDRESSEE] 
  ///       [SpaySdk.DISPLAY_OPTION_ADDRESS] 
  ///       [SpaySdk.DISPLAY_OPTION_PHONE_NUMBER] 
  ///       [SpaySdk.DISPLAY_OPTION_EMAIL] 
  ///       
  ///

  int? getDisplayOption(){
    return displayOption;
  }

  ///
  /// API to set display option of  [SheetItemType.SHIPPING_ADDRESS] on custom payment sheet.  
  ///
  ///  [Parameters:] 
  /// [displayOption]
  ///      Display option for shipping address on custom payment sheet 
  ///       
  ///      If displayOption is not set, then default addressControl is displayed on custom payment sheet.
  ///        
  ///      The possible value is combination of below constants: 
  ///      [SpaySdk.DISPLAY_OPTION_ADDRESSEE] 
  ///      [SpaySdk.DISPLAY_OPTION_ADDRESS] 
  ///      [SpaySdk.DISPLAY_OPTION_PHONE_NUMBER] 
  ///      [SpaySdk.DISPLAY_OPTION_EMAIL] 
  ///
  ///  [Exceptions:] 
  /// Throws an [ArgumentError] if [SheetItemType.SHIPPING_ADDRESS] is not set in constructor. 
  ///

  void setDisplayOption(int displayOption){
    if (sheetItem!.sheetItemType != SheetItemType.SHIPPING_ADDRESS.name) {
      throw ArgumentError("setDisplayOption : sheetItemType must be SHIPPING_ADDRESS.");
    }
    this.displayOption = displayOption;
    sheetItem!.extraValue={EXTRA_DISPLAY_OPTION:displayOption};
  }

  ///
  /// API to get error code of the AddressControl.  
  ///
  /// Return The error code.
  ///       
  ///      The returned value can be one of the following error codes: 
  ///        [SpaySdk.ERROR_BILLING_ADDRESS_INVALID] 
  ///        [SpaySdk.ERROR_BILLING_ADDRESS_NOT_EXIST] 
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID] 
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP] 
  ///        [SpaySdk.ERROR_SHIPPING_ADDRESS_NOT_EXIST] 
  ///
  ///
  int? getErrorCode(){
    return errorCode;
  }

  ///
  /// API to set error code of the AddressControl.  
  ///
  ///  [Parameters:] 
  /// [errorCode]
  ///  The possible values are: 
  ///             [SpaySdk.ERROR_BILLING_ADDRESS_INVALID] 
  ///              [SpaySdk.ERROR_BILLING_ADDRESS_NOT_EXIST] 
  ///              [SpaySdk.ERROR_SHIPPING_ADDRESS_INVALID] 
  ////             [SpaySdk.ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP] 
  ///              [SpaySdk.ERROR_SHIPPING_ADDRESS_NOT_EXIST] 
  ///
  ///
  void setErrorCode(int errorCode){
    this.errorCode = errorCode;
  }

  ///@nodoc
  factory AddressControl.fromJson(Map<String, dynamic> json, SheetUpdatedListener? sheetUpdatedListener){
    AddressControl addressControl = AddressControl(json["controlId"].toString(), SheetItem.fromJson(json["sheetItem"]).sheetItemType.toString());
    addressControl.sheetItem = SheetItem.fromJson(json["sheetItem"]);
    addressControl.address = Address.fromJson(json["address"]);
    addressControl.sheetUpdatedListener = sheetUpdatedListener;
    if(SheetItem.fromJson(json["sheetItem"]).sheetItemType.toString() == SheetItemType.SHIPPING_ADDRESS.name){
      addressControl.setDisplayOption(json["displayOption"] as int);
    }
    addressControl.setErrorCode(json["errorCode"] as int);
    return addressControl;
  }

  ///@nodoc
  Map<String, dynamic> toJson(){
    Map<String, dynamic> addressControl= {};
    addressControl["controltype"] = controltype.name;
    addressControl["controlId"] = controlId;
    if(sheetItem != null) {
      addressControl["sheetItem"] = sheetItem?.toJson();
    }
    if(address != null) {
      addressControl["address"] = address?.toJson();
    }
    if(displayOption != null) {
      addressControl["displayOption"] = displayOption;
    }
    if(errorCode != null) {
      addressControl["errorCode"] = errorCode;
    }
    if(sheetUpdatedListener != null) {
      addressControl["sheetUpdatedListener"] = true;
    } else {
      addressControl["sheetUpdatedListener"] = false;
    }
    return addressControl;
  }
}