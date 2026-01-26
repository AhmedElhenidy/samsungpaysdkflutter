
import '../samsung_pay_sdk_flutter.dart';

/// The requested operation status is returned via this listener. 
/// Upon on success, status and extra data (if any) will be returned via onSuccess callback. 
/// On any failure, the error code and error reason is provided along with failure callback. 
///
/// See [getSamsungPayStatus(StatusListener)] 
/// See [getWalletInfo(List, StatusListener)] 
/// See [startSimplePay(CardInfo, StatusListener)] 
///

class StatusListener{
  /// Invoked when request operation is success.
  ///
  /// [status] Status code of the request. Refer to each of the APIs for details.
  ///
  /// [bundle] Extra data (if any) related to request. Extra data differs from APIs.
  Function(String status, Map<String, dynamic> bundle) onSuccess;

  /// Invoked when request operation has failed.
  ///
  /// [errorCode] Failure reason. Refer to each of the APIs for details.
  ///
  /// [bundle] Extra data (if any) related to request. Extra data differs from APIs.
  Function(String errorCode, Map<String, dynamic> bundle) onFail;
  StatusListener({required this.onSuccess, required this.onFail});
}

///
/// The requested add card operation status is returned via this listener. 
///
/// See [addCard(AddCardInfo addCardInfo,AddCardListener addCardListener)] 
///

class AddCardListener{
  /// Invoked when request operation is success.
  ///
  /// [status] Added card status.
  ///
  /// [card] Added card information.
  Function(String status, Map<String, dynamic> card) onSuccess;

  /// Invoked when request operation has failed.
  ///
  /// [errorCode] Failure reason.
  ///
  /// [bundle] Extra data (if any) related to request failure.
  Function(String errorCode, Map<String, dynamic> bundle) onFail;

  /// Invoked when progress is updated.
  /// In case of TSM solution, it takes time for card provisioning.
  /// While provisioning, issuer app can use the progress information to show on the progress bar.
  ///
  /// [currentCount] Current step count if needed.
  ///
  /// [totalCount] Total step count if needed.
  ///
  /// [bundle] Extra data (if any) related to progress if needed.
  Function(String currentCount, String totalCount, Map<String, dynamic> bundle) onProgress;
  AddCardListener({required this.onSuccess, required this.onFail, required this.onProgress});
}

///
/// The requested getAllCards operation status is returned via this listener. 
///
/// See [getAllCards((GetCardListener getCardListener)]
///

class GetCardListener{
  /// Invoked when request operation is success.
  ///
  /// See [WalletCard]
  ///
  /// [cards] List of cards and its status.
  Function(List<WalletCard> card) onSuccess;

  /// Invoked when request operation has failed.
  ///
  /// [errorCode] Failure reason.
  ///
  /// [bundle] Extra data (if any) related to request.
  Function(String errorCode, Map<String,dynamic> bundle) onFail;
  GetCardListener({required this.onSuccess, required this.onFail});
}
/// This listener is for listening requestCardInfo() callback events.
///
/// [requestCardInfo(PaymentCardInfo paymentCardInfo, CardInfoListener cardInfoListener)]
///

class CardInfoListener{
  /// This callback is received when the card information is received successfully.
  ///
  /// [paymentCardInfo] PaymentCardInfo List.
  /// Null, if Samsung Pay does not have any card for online payment.
  /// Otherwise, card list of supported card brands is returned.
  Function(List<PaymentCardInfo> paymentCardInfo) onResult;

  /// This callback is received when the card information cannot be retrieved.
  /// For example, when Plugin service in the Samsung Wallet app dies abnormally.
  ///
  /// [errorCode] Error code, the reason for failure.
  ///
  /// [bundle] Extra Error Data provided by Samsung Pay.
  Function(String errorCode, Map<String, dynamic> bundle) onFailure;
  CardInfoListener({required this.onResult, required this.onFailure});
}

/// This interface is for listening callback events of online (in-app) custom sheet payment. 
/// This is invoked when card is changed by the user on the custom payment sheet,
/// and also with the success or failure of online (in-app) payment. 
///
/// This listener is registered when
/// [startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener)]
/// API is called.  
///
/// [Caution]: AmountBoxControl must be returned in onCardInfoUpdated() on SheetUpdatedListener
/// to remove progress bar on custom payment sheet.
///
/// [startInAppPayWithCustomSheet(CustomSheetPaymentInfo customSheetPaymentInfo,CustomSheetTransactionInfoListener customSheetTransactionInfoListener)]
///

class CustomSheetTransactionInfoListener{
  /// This callback is received when the user changes card on the custom payment sheet in
  /// Samsung Pay.
  /// In this callback, updateSheet() method must be called to update current payment sheet.
  ///
  /// See [updateSheet]
  ///
  /// [paymentCardInfo] Currently selected card's information.
  ///
  /// [customSheet] The custom sheet that needs to be updated.
  Function(PaymentCardInfo paymentCardInfo, CustomSheet customSheet) onCardInfoUpdated;

  /// This callback is received when the online (in-app) payment transaction is approved by
  /// user and able to successfully generate in-app payload. The payload could be an
  /// encrypted cryptogram (direct in-app payment) or Payment Gateway's token reference ID
  /// (indirect in-app payment).
  ///
  /// [customSheetPaymentInfo] Online payment information from Samsung Pay.
  /// Since API level 1.5, [SpaySdk.EXTRA_LAST4_FPAN] and [SpaySdk.EXTRA_LAST4_DPAN] of the card
  /// which was used for the current transaction is included in CardInfo.
  ///
  /// [paymentCredential] Payment Credentials. Example: Cryptogram, AID (direct in-app payment), or
  /// tokenRefId (indirect in-app payment).
  ///
  /// [extraPaymentData] Additional payment credentials if any.
  Function(CustomSheetPaymentInfo customSheetPaymentInfo, String paymentCredential,  Map<String, dynamic>? extraPaymentData) onSuccess;

  /// This callback is received when the online payment transaction has failed.
  ///
  /// [errorCode] The result code of error cause.
  ///
  /// [bundle] Extra error message data, if any, provided by Samsung Pay.
  ///
  /// **Note:** Please refer [SpaySdk.COMMON_STATUS_TABLE] in detail.
  Function(String errorCode, Map<String, dynamic> bundle) onFail;
  CustomSheetTransactionInfoListener({required this.onCardInfoUpdated, required this.onSuccess, required this.onFail});
}

/// This listener is for listening SheetControl events.
///
/// See [AddressControl] 
/// See [AmountBoxControl] 
/// See [PlainTextControl] 
/// See [SpinnerControl] 
/// See [CustomSheet] 
///

class SheetUpdatedListener{
  /// This callback is received when Controls are updated.
  /// In this callback, updateSheet() method must be called to update current payment sheet.
  ///
  /// See [updateSheet]
  ///
  /// [updatedControlId] Updated SheetControlId.
  ///
  /// [customSheet] Updated CustomSheet.
  Function(String updatedControlId, CustomSheet customSheet) onResult;
  SheetUpdatedListener({required this.onResult});
}