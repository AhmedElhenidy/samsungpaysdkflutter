import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'samsung_pay_sdk_flutter.dart';

export 'samsung_pay_listener.dart';
export 'samsung_pay_sdk_flutter_method_channel.dart';
export 'samsung_pay_sdk_flutter_platform_interface.dart';
export 'spay_core.dart';
export 'model/add_card_info.dart';
export 'model/address.dart';
export 'model/address_control.dart';
export 'model/amount_box_control.dart';
export 'model/custom_sheet.dart';
export 'model/custom_sheet_payment_info.dart';
export 'model/partner_info.dart';
export 'model/payment_card_info.dart';
export 'model/plain_text_control.dart';
export 'model/sheet_control.dart';
export 'model/sheet_item.dart';
export 'model/spinner_control.dart';
export 'model/wallet_card.dart';
/// This class provides APIs to get the Samsung Pay status on the device.
/// Also, this class provides APIs to activate Samsung Pay on the device.
/// Partner apps must check the Samsung Pay status on the device
/// before performing any card management or payment operation.
class SamsungPaySdkFlutter {

  PartnerInfo? _partnerInfo;
  SamsungPaySdkFlutterPlatform? methodChannelSamsungPaySdkFlutter;

  /// API to initiate Samsung Wallet with Partner information.
  /// Partner (Issuers, Merchants, and so on) applications must call this
  /// to initiate Samsung Wallet before calling any API. 
  SamsungPaySdkFlutter(PartnerInfo partnerInfo){
    _partnerInfo=partnerInfo;
    _initSamsungPay(_partnerInfo);
  }

  Future<bool?>? _initSamsungPay(PartnerInfo? partnerInfo) {
    methodChannelSamsungPaySdkFlutter = SamsungPaySdkFlutterPlatform.instance = MethodChannelSamsungPaySdkFlutter();
    return methodChannelSamsungPaySdkFlutter?.initSamsungPay(partnerInfo);
  }

  /// API to get the Samsung Pay status on the device.
  /// Partner (Issuers, Merchants, and so on) applications must call this API to
  /// check the current state of Samsung Wallet before doing any operation.
  ///
  /// [statusListener] Callback through which the result is provided.
  ///
  /// On success, Samsung Pay status code is provided via [StatusListener.onSuccess].
  /// If Samsung Wallet is ready to be used, [SpaySdk.SPAY_READY] will be returned.
  /// Otherwise, [SpaySdk.SPAY_NOT_READY] or [SpaySdk.SPAY_NOT_SUPPORTED]
  /// or [SpaySdk.SPAY_NOT_ALLOWED_TEMPORALLY] can be returned
  /// with [SpaySdk.EXTRA_ERROR_REASON] from Bundle.
  ///
  /// Also, partner can get extra information from Bundle data:
  ///
  /// - [SpaySdk.EXTRA_COUNTRY_CODE]: Device Country code (ISO 3166-1 alpha-2)
  /// - [SpaySdk.EXTRA_MEMBER_ID]: String memberID (for Korean issuers only)
  ///
  /// On any failure, the failure code is provided via [StatusListener.onFail].
  ///
  /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] in detail.
  ///
  /// Throws [NullPointerException] if the callback passed is null.

  void getSamsungPayStatus(StatusListener statusListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.getSamsungPayStatus(statusListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  /// Returns the version code of the Samsung Pay SDK.
  Future<int> getVersionCode() async{
    return await methodChannelSamsungPaySdkFlutter!.getVersionCode();
  }
  /// Returns the version name of the Samsung Pay SDK.
  Future<String> getVersionName() async{
    return await methodChannelSamsungPaySdkFlutter!.getVersionName();
  }

  /// API to get the requested wallet information from Samsung Wallet. 
  /// Partner app can use this information to uniquely identify the user
  /// and Samsung Wallet app on a particular device.
  ///
  /// [statusListener] Callback through which the result is provided.
  /// On success, [StatusListener.onSuccess] is invoked with wallet information.  
  ///
  /// **Status:** [SpaySdk.ERROR_NONE]
  ///
  /// **Bundle Keys and Values:**
  /// - [SpaySdk.WALLET_DM_ID]: String Device Management ID
  ///   - VTS Usage: N/A
  ///   - MDES Usage: paymentAppInstanceId = DEVICE_ID + Padding("00") + WALLET_DM_ID
  ///     (If you need 'paymentAppInstanceId', you can generate it as above)
  ///
  /// - [SpaySdk.DEVICE_ID]: String Device ID
  ///   - VTS Usage: clientDeviceID
  ///   - MDES Usage: paymentAppInstanceId = DEVICE_ID + Padding("00") + WALLET_DM_ID
  ///
  /// - [SpaySdk.WALLET_USER_ID]: String Wallet User ID
  ///   - VTS Usage: clientWalletAccountID
  ///   - MDES Usage: paymentAppInstanceId = DEVICE_ID + Padding("00") + WALLET_DM_ID
  ///  
  /// On any failure, the error code is provided via [StatusListener.onFail].  
  ///
   /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] in details. 
  ///
  /// **Exceptions:**
  /// Throws an [ArgumentError] if parameters are null.
  ///
  Future<void> getWalletInfo(StatusListener statusListener) async {
    try{
      methodChannelSamsungPaySdkFlutter?.getWalletInfo(statusListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API to go to Samsung Pay update page.
  /// Partner app checks the Samsung Pay status with
  /// [getSamsungPayStatus] API.
  ///
  /// If the status is [SpaySdk.SPAY_NOT_READY] and
  /// [SpaySdk.EXTRA_ERROR_REASON] is [SpaySdk.ERROR_SPAY_APP_NEED_TO_UPDATE],
  /// partner app can call this API to go to update Samsung Wallet app.
  ///
  /// If Samsung Wallet App version is same or bigger than 2.1.00, it goes to
  /// "About SamsungPay" menu. If Samsung Wallet App version is lower than 2.1.00
  /// or KR device, it launches Samsung Wallet App main screen.
  Future<void> goToUpdatePage()async{
    await methodChannelSamsungPaySdkFlutter?.goToUpdatePage();
  }

  /// API to bring the Samsung Wallet app to a state in which cards can be added.
  /// Samsung Pay might be either in stub only state or Samsung Account is not signed in state.
  /// Partner app checks the Samsung Pay status with [getSamsungPayStatus] API.
  ///
  /// If the status is [SpaySdk.SPAY_NOT_READY] and
  /// [SpaySdk.EXTRA_ERROR_REASON] is [SpaySdk.ERROR_SPAY_SETUP_NOT_COMPLETED],
  /// partner app can call this API to launch Samsung Pay and user can sign in to the app.
  Future<void> activateSamsungPay() async{
    await methodChannelSamsungPaySdkFlutter?.activateSamsungPay();
  }
  /// API to add a card from partner app (example: issuer/bank app) to Samsung Pay.
  /// Partner app uses this API to add card to Samsung Pay by providing the required card details.
  /// This helps user to add their cards to Samsung Pay directly from partner app.
  void addCard(AddCardInfo addCardInfo,AddCardListener addCardListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.addCard(addCardInfo,addCardListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  /// API to add a co-badge card from partner app (example: issuer/bank app) to Samsung Pay.
  /// Partner app uses this API to add co-badge card to Samsung Pay by providing the required card details.
  /// This helps user to add their cards to Samsung Pay directly from partner app.
  void addCobadgeCard(AddCardInfo primaryAddCardInfo,AddCardInfo secondaryAddCardInfo,AddCardListener addCardListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.addCobadgeCard(primaryAddCardInfo,secondaryAddCardInfo,addCardListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API to get all the cards from Samsung Pay for the given filter.
  ///
  /// Since API level 2.13, [getAllCards] would return a card list in which a
  /// [WalletCard] of [SpaySdk.Brand.VISA] brand would hold a Token Reference ID
  /// as its [WalletCard.cardId] instead of a Provisioned Token ID in earlier API level.
  ///
  /// Since API level 1.4, partner must define issuer names as a card filter
  /// on Samsung Pay Developers while on-boarding.
  ///
  /// **Filter Keys:**
  /// - [SpaySdk.EXTRA_ISSUER_NAME]: String issuerName (issuerCode for Korean issuers)
  ///
  /// [getCardListener] Callback through which the result is provided.
  /// On success, [GetCardListener.onSuccess] is invoked with list of Cards.
  /// On any failure, the error code is provided via [GetCardListener.onFail].
  ///
  /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.
  ///
  /// Throws [NullPointerException] if listener is null.
  void getAllCards(GetCardListener getCardListener) {
    try{
      methodChannelSamsungPaySdkFlutter?.getAllCards(getCardListener);
    }on PlatformException catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }


  /// API to request card information of the available cards for payment using Samsung Wallet.
  ///
  /// The partner app can use this API to query available cards (user already has registered) in
  /// Samsung Wallet and decide whether to display Samsung Pay button or not on their application.
  /// For example, if merchant app supports only one specific card brand, but the user has not registered
  /// any card with the brand, then merchant app decides not to display the Samsung Pay button
  /// with this query.
  ///
  /// [paymentCardInfo] Filter to limit return cardInfo list. This is optional parameter.
  /// If the caller does not set any value, all the cards which are available for online (in-app)
  /// payment on Samsung Wallet are returned.
  ///
  /// [cardInfoListener] Callback through which the result is provided.
  /// On success, [CardInfoListener.onResult] is invoked with CardInfo list.
  /// On any failure, the failure code is provided via [CardInfoListener.onFailure].
  ///
  /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.
  ///
  /// **Exceptions:**
  /// Throws an [ArgumentError] if the CardInfoListener is null.
  void requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener){
    try{
      methodChannelSamsungPaySdkFlutter?.requestCardInfo(paymentCardInfo, cardInfoListener);
    }on PlatformException catch(e){
      print(e);
    }
  }


  /// API to request online(in-app) payment with Samsung Wallet.
  /// Partner app can use this API to make in-app purchase using Samsung Wallet from their
  /// application with custom payment sheet.
  ///
  /// [customSheetPaymentInfo] Custom sheet and payment information from partner app (merchant app).
  ///
  /// [customSheetTransactionInfoListener] Callback through which the result is provided.
  /// On success, [CustomSheetTransactionInfoListener.onSuccess] is invoked with payment credential.
  /// [CustomSheetTransactionInfoListener.onCardInfoUpdated] is invoked when user changes
  /// the card on the payment sheet in Samsung Wallet.
  /// On any failure, the failure error code and error data are provided via
  /// [CustomSheetTransactionInfoListener.onFailure].
  ///
  /// The failure code can be one of the following codes with bundle data:
  /// - [SpaySdk.ERROR_USER_CANCELED] (-7)
  /// - [SpaySdk.ERROR_DUPLICATED_SDK_API_CALLED] (-105)
  ///
  /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] for other status.
  ///
  /// **Exceptions:**
  /// - Throws an [ArgumentError] if parameters are null.
  /// - Throws an [ArgumentError] if Samsung Pay SDK Service is not available.
  /// - Throws an [ArgumentError] if mandatory custom sheet information and payment information values are not set.
  void startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener){
    try{
      methodChannelSamsungPaySdkFlutter?.startInAppPayWithCustomSheet(customSheetPaymentInfo, customSheetTransactionInfoListener);
    }on PlatformException catch(e){
      print(e);
    }
  }

  /// API to update sheet on the custom payment sheet.
  ///
  /// [customSheet] CustomSheet to be updated.
  ///
  /// [customErrorCode] Optional error code for custom error message.
  ///
  /// [customErrorMessage] Optional custom error message to display.
  ///
  /// **Exceptions:**
  /// - Throws an [ArgumentError] if service is disconnected.
  /// - Throws an [ArgumentError] if the sheetControl is null.
  /// - Throws an [Exception] if only one of customErrorCode or customErrorMessage is provided.
  ///
  void updateSheet(CustomSheet customSheet, {int? customErrorCode, String? customErrorMessage}) {
    if(customErrorCode==null && customErrorMessage==null)
    {
      methodChannelSamsungPaySdkFlutter?.updateSheet(customSheet);
    }
    else if(customErrorCode!=null && customErrorMessage!=null)
    {
      methodChannelSamsungPaySdkFlutter?.updateSheet(customSheet, customErrorCode: customErrorCode, customErrorMessage: customErrorMessage);
    }
    else
    {
      throw Exception("You must set errorCode and errorMessage.");
    }
  }
}
