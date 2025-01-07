
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samsung_pay_sdk_flutter/model/address_control.dart';
import 'package:samsung_pay_sdk_flutter/model/custom_sheet.dart';
import 'package:samsung_pay_sdk_flutter/model/custom_sheet_payment_info.dart';
import 'package:samsung_pay_sdk_flutter/model/payment_card_info.dart';
import 'package:samsung_pay_sdk_flutter/model/plain_text_control.dart';
import 'package:samsung_pay_sdk_flutter/model/spinner_control.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';
import 'package:samsung_pay_sdk_flutter_example/util/Strings.dart';
import 'customSheet/AmountDetailControls.dart';
import 'customSheet/BillingAddressControls.dart';
import 'customSheet/ShippingAddressControls.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage(title: "Sample Merchant")));
}

class StatusHolder{
  final bool status;
  final String statusCode;
  final Map<String,dynamic> bundle;

  StatusHolder(this.status,this.statusCode,this.bundle);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static final samsungPaySdkFlutterPlugin = SamsungPaySdkFlutter(PartnerInfo(serviceId: '0b89048b46b64cd3a3e60c', data: {SpaySdk.PARTNER_SERVICE_TYPE:ServiceType.INAPP_PAYMENT.name}));


  final String title;
  static List<String> cryptogramArray = ['NONE', 'UCAF', 'ICC'];
  static List<String> requestAddressOption = [
    'No Billing/Shipping Address',
    'Only Billing Address (SPay)',
    'Only Shipping Address (SPay)',
    'Only Shipping Address (Merchant)',
    'Billing (SPay), Shipping (Merchant)',
    'Billing and Shipping Addresses (SPay)'
  ];
  static List<String> billingAddressError = [
    'ERROR_NONE',
    'ERROR_BILLING_ADDRESS_INVALID',
    'ERROR_BILLING_ADDRESS_NOT_EXIST',
    'CUSTOM_ERROR_MESSAGE'
  ];
  static List<String> shippingAddressError = [
    'ERROR_NONE',
    'ERROR_SHIPPING_ADDRESS_INVALID',
    'ERROR_SHIPPING_ADDRESS_NOT_EXIST',
    'ERROR_SHIPPING_ADDRESS_UNABLE_TO_SHIP',
    'CUSTOM_ERROR_MESSAGE'
  ];
  static List<String> amountFormatList = [
    'FORMAT_TOTAL_PRICE_ONLY',
    'FORMAT_TOTAL_FREE_TEXT_ONLY',
    'FORMAT_TOTAL_AMOUNT_PENDING_TEXT_ONLY',
    'FORMAT_TOTAL_PENDING_TEXT_ONLY'
  ];
  static List<String> currencyList = [
    'USD',
    'INR',
    'KRW',
    'EUR',
    'AUD',
    'JPY',
    'CNY',
    'GBP',
    'SGD',
    'RUB',
    'BRL',
    'HKD',
    'THB',
    'CAD',
    'MYR',
    'CHF',
    'SEK',
    'TWD',
    'AED'
  ];
  static bool? shippingAddressCB = true;
  static bool? shippingPhoneCB = true;
  static bool? shippingEmailCB = true;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = MethodChannel('spaysdkflutter.merchant.sample');

  double? selectedRadioTile = 0.0;
  int counter = 0;
  bool? cardBrandControlSW = false;
  bool? extraOptionControlSW = false;
  bool? billingCB = false;
  bool? billingZipCodeCB = false;
  bool? shippingCB = false;
  bool? visaCB = false;
  bool? comboCardCB = false;
  bool? cpfCB = false;
  bool? predefinedCB = false;
  bool? editableCB = false;
  bool? customMsgCB = false;
  bool? cardHolderNameCB = false;
  bool? mastercardCB = false;
  bool? americanExpressCB = false;
  bool? discoverCB = false;
  bool? shippingAddresseeCB = true;
  bool? isShowBilling = false;
  bool? isShowShipping = false;
  bool? isShowBillingCustomError = false;
  bool? isShowShippingCustomError  = false;
  bool? isShowCustomMessage = false;
  bool? isShowEditablePlainText = false;
  String? cryptogram = MyHomePage.cryptogramArray.first;
  String? requestAddress = MyHomePage.requestAddressOption.first;
  String? billingAddError = MyHomePage.billingAddressError.first;
  String? shippingAddError = MyHomePage.shippingAddressError.first;
  String? amountFormat = MyHomePage.amountFormatList.first;
  String? currency = MyHomePage.currencyList.first;
  String? country;
  String? plainTextWithTitle;
  String? plainTextWithText;
  String? customErrorMessage;
  List<String?>? isoCountryList = [];
  TextEditingController? nameEC = TextEditingController();
  TextEditingController? addressOneEC = TextEditingController();
  TextEditingController? addressTwoEC = TextEditingController();
  TextEditingController? cityEC = TextEditingController();
  TextEditingController? stateEC = TextEditingController();
  TextEditingController? zipEC = TextEditingController();
  TextEditingController? countryEC = TextEditingController();
  TextEditingController? phoneEC = TextEditingController();
  TextEditingController? emailEC = TextEditingController();
  TextEditingController? customErrorMessageEC = TextEditingController();
  TextEditingController? billingCustomErrorMessageEC = TextEditingController();
  TextEditingController? shippingCustomErrorMessageEC = TextEditingController();
  AddressInPaymentSheet requestAddressType = AddressInPaymentSheet.DO_NOT_SHOW;
  AmountDetailControls mAmountDetailControls = AmountDetailControls();
  ShippingAddressControls mShippingAddressControls = ShippingAddressControls();
  BillingAddressControls mBillingAddressControls = BillingAddressControls();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  initialization() async {
    _setValueOnTextFields();

    List<String> countryList = [];
    final countryListRow = await platform.invokeMethod<List<dynamic>>('getISOCountries');
    countryListRow?.forEach((element) {
      countryList.add(element.toString());
    });

    setState(() {
      country = countryList.first;
      isoCountryList = countryList;
    });
  }


  void getSamsungPayStatus() {
    StatusHolder statusHolder;
    MyHomePage.samsungPaySdkFlutterPlugin.getSamsungPayStatus(StatusListener(onSuccess: (status, bundle) async {
      statusHolder = StatusHolder(true, status, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));

    }, onFail:(errorCode, bundle){
      statusHolder = StatusHolder(false, errorCode, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));
    }));
  }

  ///
  /// requestCardInfo() - API to request card information of the available cards for payment using Samsung Pay.
  /// The partner app can use this API to query available cards (user already has registered) in
  ///Samsung Pay and decide whether to display Samsung Pay button or not on their application.
  /// For example, if merchant app supports only one specific card brand, but the user has not registered
  /// any card with the brand, then merchant app decides not to display the Samsung Pay button
  /// with this query.
  ///

  void requestCardInfo(){
    PaymentCardInfo paymentCardInfo = PaymentCardInfo();
    for(int i =0; i<getAllowedBrandList().length;i++)
    {
      paymentCardInfo.addBrand(getAllowedBrandList()[i]);
    }

    MyHomePage.samsungPaySdkFlutterPlugin.requestCardInfo(paymentCardInfo, CardInfoListener(onResult:(list){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const RequestCardData(),
              settings: RouteSettings(arguments: list)));
    }, onFailure:(errorCode, bundle){
      StatusHolder statusHolder= StatusHolder(false, errorCode, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));
    }));
  }

  List<Brand> getAllowedBrandList(){
    List<Brand> brandList= [];
    if(visaCB!) {
      brandList.add(Brand.VISA);
    } else if(mastercardCB!) {
      brandList.add(Brand.MASTERCARD);
    }
    else if (americanExpressCB!){
      brandList.add(Brand.AMERICANEXPRESS);
    }
    else if(discoverCB!) {
      brandList.add(Brand.DISCOVER);
    }
    return brandList;
  }

  void startInAppPayWithCustomSheet()
  {
    MyHomePage.samsungPaySdkFlutterPlugin.startInAppPayWithCustomSheet(makeTransactionDetailsWithSheet(), transactionListener());
  }

  CustomSheetPaymentInfo makeTransactionDetailsWithSheet()
  {
    Map<String, dynamic> extraPaymentInfo = {};
    if(cryptogram != MyHomePage.cryptogramArray.first){
      extraPaymentInfo[SpaySdk.EXTRA_CRYPTOGRAM_TYPE] = cryptogram;
    }if(comboCardCB!){
      extraPaymentInfo[SpaySdk.EXTRA_ACCEPT_COMBO_CARD] = comboCardCB;
    }if (cpfCB!) {
      extraPaymentInfo[SpaySdk.EXTRA_REQUIRE_CPF] = cpfCB;
    }

    CustomSheetPaymentInfo customSheetPaymentInfo =  CustomSheetPaymentInfo(merchantName: "Sample flutter app", customSheet: makeUpCustomSheet());
    customSheetPaymentInfo.merchantId = "";
    customSheetPaymentInfo.setOrderNumber("AMZ007MAR");
    customSheetPaymentInfo.setMerchantCountryCode("US");
    customSheetPaymentInfo.addressInPaymentSheet = requestAddressType;
    customSheetPaymentInfo.allowedCardBrand = brandList;
    customSheetPaymentInfo.setCardHolderNameEnabled(cardHolderNameCB!);
    customSheetPaymentInfo.setExtraPaymentInfo(extraPaymentInfo);

    if (kDebugMode) {
      print("requestAddressType: $requestAddressType");
    }
    return customSheetPaymentInfo;

  }

  CustomSheetTransactionInfoListener transactionListener()
  {
    /// This callback is received when the user changes card on the custom payment sheet in Samsung Wallet.
    CustomSheetTransactionInfoListener x = CustomSheetTransactionInfoListener(onCardInfoUpdated: (PaymentCardInfo paymentCardInfo, CustomSheet customSheet) {

      /// Called when the user changes card in Samsung Wallet.
      /// Newly selected cardInfo is passed and partner app can update transaction amount based on new card (if needed).
      /// Call updateSheet() method. This is mandatory.
      ///

      mAmountDetailControls.updateAmountControl(customSheet);
      if (customMsgCB!) {
        updateSheetWithCustomErrorMessageToSdk(customSheet, customErrorMessageEC!.text, "onCardInfoUpdated");
      } else {
        updateSheetToSdk(customSheet);
      }

    }, onSuccess: (CustomSheetPaymentInfo customSheetPaymentInfo, String paymentCredential, Map<String, dynamic>? extraPaymentData) {

      /// Called when Samsung Wallet able to create in-app cryptogram successfully.
      /// Partner app will send this cryptogram to Partner server/Payment Gateway and complete in-app payment.
      ///
      if (kDebugMode) {
        print("Payment Success");
      }

    }, onFail: (String errorCode, Map<String, dynamic> bundle) {
      if (kDebugMode) {
        print("Payment Failed");
      }
    });

    return  x ;
  }
  CustomSheet makeUpCustomSheet()
  {
    ///
    /// This callback is received when Controls are updated from Samsung Wallet.
    ///
    SheetUpdatedListener sheetUpdatedListener = SheetUpdatedListener(onResult: (String controlId,CustomSheet sheet){
      if (kDebugMode) {
        print("onResult control id: $controlId");
      }
      var spinnerIndex = selectedRadioTile;

      if(controlId == Strings.SHIPPING_METHOD_SPINNER_ID){
        var shippingMethodSpinnerControl = sheet.getSheetControl(controlId) as SpinnerControl;
        print("onResult receivedShippingMethodSpinner : ${shippingMethodSpinnerControl.selectedItemId}");

        if(shippingMethodSpinnerControl.selectedItemId == Strings.SHIPPING_METHOD_1){
          mAmountDetailControls.setAddedShippingAmount(0.0);
          spinnerIndex = 0.0;
        }
        else if(shippingMethodSpinnerControl.selectedItemId == Strings.SHIPPING_METHOD_2){
          mAmountDetailControls.setAddedShippingAmount(0.1);
          spinnerIndex = 0.1;
        }
        else if(shippingMethodSpinnerControl.selectedItemId == Strings.SHIPPING_METHOD_3){
          mAmountDetailControls.setAddedShippingAmount(0.2);
          spinnerIndex = 0.2;
        }
        setState(() {
          selectedRadioTile = spinnerIndex;
        });
        updateSheetToSdk(sheet);
      }
      if(controlId == Strings.BILLING_ADDRESS_ID){
        receivedBillingAddress(controlId, sheet);
      }
      if(controlId == Strings.SHIPPING_ADDRESS_ID){
        receivedShippingAddress(controlId, sheet);
      }

    });

    ///
    /// Make SheetControls you want and add to custom sheet.
    /// Each SheetControl is located in sequence.
    /// There must be a AmountBoxControl and it must be located on last.
    ///

    CustomSheet customSheet = CustomSheet();
    customSheet.addControl(mAmountDetailControls.makeAmountControl(currency!));

    if (billingCB!) {
      if(billingZipCodeCB!)
        customSheet.addControl(mBillingAddressControls.makeBillingAddressWithZipCodeOnly(sheetUpdatedListener));
      else
        customSheet.addControl(mBillingAddressControls.makeBillingAddress(sheetUpdatedListener));
    }

    if (shippingCB!) {
      customSheet.addControl(mShippingAddressControls.makeShippingAddress(sheetUpdatedListener));
    }

    if (extraOptionControlSW!) {
      if(predefinedCB!){
        PlainTextControl plainTextControl = PlainTextControl(Strings.PLAIN_TEXT_PRE_DEFINED_EXAMPLE_ID);
        plainTextControl.setText(Strings.plain_text_pre_defined_title, Strings.plain_text_pre_defined_message);
        customSheet.addControl(plainTextControl);
      }
      if(editableCB!){
        PlainTextControl plainTextControl = PlainTextControl(Strings.PLAIN_TEXT_EDITABLE_EXAMPLE_ID);
        plainTextWithTitle ??= "";
        plainTextWithText ??= "";

        plainTextControl.setText(plainTextWithTitle!, plainTextWithText!);

        customSheet.addControl(plainTextControl);
      }
    }


    if (shippingCB!) {
      if (kDebugMode) {
        print("makeUpCustomSheet shippingCB2: ${shippingCB!}" );
      }
      customSheet.addControl(mShippingAddressControls.makeShippingMethodSpinnerControl(sheetUpdatedListener, selectedRadioTile!));
    }

    return customSheet;
  }

  void receivedBillingAddress(String updatedControlId, CustomSheet sheet) {
    var addressControl = sheet.getSheetControl(updatedControlId) as AddressControl;
    var billAddress = addressControl.address;
    var errorCode = mBillingAddressControls.validateBillingAddress(billAddress, billingAddError);
    addressControl.errorCode = errorCode;
    sheet.updateControl(addressControl);
    var needCustomErrorMessage = isShowBillingCustomError;
    if (kDebugMode) {
      print("onResult receivedBillingAddress  errorCode: $errorCode, customError: $needCustomErrorMessage");
    }
    if (needCustomErrorMessage!) {
      updateSheetWithCustomErrorMessageToSdk(
          sheet,billingCustomErrorMessageEC!.text, "receivedShippingAddress"
      );
      if (kDebugMode) {
        print("customErrorMessage: $customErrorMessage");
      }
    } else {
      updateSheetToSdk(mAmountDetailControls.updateAmountControl(sheet));
    }
  }

  void receivedShippingAddress(String updatedControlId, CustomSheet sheet){
    if (kDebugMode) {
      print("receivedShippingAddress: ${updatedControlId}");
    }
    var addressControl = sheet.getSheetControl(updatedControlId) as AddressControl;
    var shippingAddress = addressControl.address;
    var errorCode = mShippingAddressControls.validateShippingAddress(shippingAddress, shippingAddError);
    addressControl.errorCode = errorCode;
    sheet.updateControl(addressControl);
    var needCustomErrorMessage = isShowShippingCustomError;
    if (kDebugMode) {
      print("onResult receivedShippingAddress  errorCode: $errorCode, customError: $needCustomErrorMessage");
    }
    if (needCustomErrorMessage!) {
      updateSheetWithCustomErrorMessageToSdk(sheet, shippingCustomErrorMessageEC!.text, "receivedShippingAddress");
    } else {
      updateSheetToSdk(mAmountDetailControls.updateAmountControl(sheet));
    }
  }


  // Supported card brands
  List<Brand> get brandList {
    List<Brand> brandList = [];
    if(visaCB!) {
      brandList.add(Brand.VISA);
    }
    if (mastercardCB!) {
      brandList.add(Brand.MASTERCARD);
    }
    if (americanExpressCB!) {
      brandList.add(Brand.AMERICANEXPRESS);
    }
    if (discoverCB!) {
      brandList.add(Brand.DISCOVER);
    }
    return brandList;
  }


        ///
        /// This callback is received when the card information is received successfully.
        ///[Parameters;]<br>
        /// [cardResponse]
        ///            CardInfo List.
        ///            Null, if Samsung Pay does not have any card for online payment.
        ///            Otherwise, card list of supported card brands is returned.
        ///

  void updateSheetToSdk(CustomSheet sheet){
    var updatedCustomSheet = mAmountDetailControls.updateAmountControl(sheet);
    MyHomePage.samsungPaySdkFlutterPlugin.updateSheet(updatedCustomSheet);
  }

  void updateSheetWithCustomErrorMessageToSdk(CustomSheet sheet, String customErrorMessage, String reason){

    MyHomePage.samsungPaySdkFlutterPlugin.updateSheet(
        mAmountDetailControls.updateAmountControl(sheet),
        customErrorCode: SpaySdk.CUSTOM_MESSAGE,
        customErrorMessage: customErrorMessage
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x9999B1F0), Color(0x991D48C0)]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merchant SDK',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                  ],
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'SERVER : ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'STG',
                          style: TextStyle(color: Colors.white70),
                        ),
                        VerticalDivider(
                          color: Colors.redAccent,
                        ),
                        Text(
                          'DEBUG MODE :',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Y',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                            onPressed: () {
                              getSamsungPayStatus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent.withAlpha(80),
                            ),
                            child: const Text('SPay Status', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              requestCardInfo();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent.withAlpha(80),
                            ),
                            child: const Text('Card Info', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              await MyHomePage.samsungPaySdkFlutterPlugin.activateSamsungPay();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent.withAlpha(80),
                            ),
                            child: const Text('Activate SPay', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              await MyHomePage.samsungPaySdkFlutterPlugin.goToUpdatePage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent.withAlpha(80),
                            ),
                            child: const Text('Update SPay', style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CARD/BRAND CONTROLS",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                  Text(
                                      "Controls for allowed brands, combo card, etc"),
                                ],
                              ),
                            ),
                            Switch(
                                value: cardBrandControlSW!,
                                onChanged: (val) {
                                  setState(() {
                                    cardBrandControlSW = val;
                                  });
                                })
                          ]),
                      cardBrandControlSW!
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text('Visa'),
                                        value: visaCB,
                                        onChanged: (val) {
                                          setState(() {
                                            visaCB = val;
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text('Mastercard'),
                                        value: mastercardCB,
                                        onChanged: (val) {
                                          setState(() {
                                            mastercardCB = val;
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text('American Express'),
                                        value: americanExpressCB,
                                        onChanged: (val) {
                                          setState(() {
                                            americanExpressCB = val;
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text('Discover'),
                                        value: discoverCB,
                                        onChanged: (val) {
                                          setState(() {
                                            discoverCB = val;
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.redAccent),
                                CheckboxListTile(
                                  title: const Text('Display card holder name'),
                                  value: cardHolderNameCB,
                                  onChanged: (val) {
                                    setState(() {
                                      cardHolderNameCB = val;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                CheckboxListTile(
                                  title: const Text('Request combo card'),
                                  value: comboCardCB,
                                  onChanged: (val) {
                                    setState(() {
                                      comboCardCB = val;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                CheckboxListTile(
                                  title: const Text('Request CPF'),
                                  value: cpfCB,
                                  onChanged: (val) {
                                    setState(() {
                                      cpfCB = val;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                Divider(color: Colors.redAccent),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('DSRP Cryptogram type'),
                                    Expanded(child: SizedBox()),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigoAccent
                                                .withAlpha(80),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50))),
                                        child: DropdownButton<String>(
                                          underline: Container(
                                            height: 1,
                                            color: Colors.transparent,
                                          ),
                                          value: cryptogram,
                                          isExpanded: true,
                                          items: MyHomePage.cryptogramArray
                                              .map((value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: Text(value)),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              cryptogram = value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Extra Option Controls",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreen),
                                  ),
                                  Text(
                                      "Controls for plain text, custom error message"),
                                ],
                              ),
                            ),
                            Switch(
                                value: extraOptionControlSW!,
                                onChanged: (val) {
                                  setState(() {
                                    extraOptionControlSW = val;
                                  });
                                })
                          ]),
                      extraOptionControlSW!
                          ? Column(
                              children: [
                                CheckboxListTile(
                                  title: const Text(
                                      'Plain Text Example (Pre-defined from code)'),
                                  value: predefinedCB,
                                  onChanged: (val) {
                                    setState(() {
                                      predefinedCB = val;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                      'Plain Text Example (Editable)'),
                                  value: editableCB,
                                  onChanged: (val) {
                                    setState(() {
                                      editableCB = val;
                                      isShowEditablePlainText = editableCB;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                Visibility(
                                  visible: isShowEditablePlainText!,
                                  child: const SizedBox(
                                    height: 10,
                                  ),
                                ),
                                Visibility(
                                  visible: isShowEditablePlainText!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigoAccent.withAlpha(80),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(5))),
                                    padding: const EdgeInsets.all(1.0),
                                    margin: const EdgeInsets.only(bottom: 4.0),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          'Title'),
                                      onChanged: (val) {
                                        plainTextWithTitle = val;
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isShowEditablePlainText!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigoAccent.withAlpha(80),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(5))),
                                    padding: const EdgeInsets.all(1.0),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          'Text'),
                                      onChanged: (val) {
                                        plainTextWithText = val;
                                      },
                                    ),
                                  ),
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                      'update sheet with custom message?'),
                                  value: customMsgCB,
                                  onChanged: (val) {
                                    setState(() {
                                      customMsgCB = val;
                                      if(customMsgCB!) {
                                        isShowCustomMessage = true;
                                      }else{
                                        isShowCustomMessage = false;
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                Visibility(
                                  visible: isShowCustomMessage!,
                                  child: const SizedBox(
                                    height: 10,
                                  ),
                                ),
                                Visibility(
                                  visible: isShowCustomMessage!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigoAccent.withAlpha(80),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(5))),
                                    padding: const EdgeInsets.all(1.0),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: customErrorMessageEC,
                                      onChanged: (val) {
                                        customErrorMessage = val;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REQUEST ADDRESS OPTIONS",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent.withAlpha(80),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(1.0),
                        child: DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            color: Colors.transparent,
                          ),
                          value: requestAddress,
                          isExpanded: true,
                          items: MyHomePage.requestAddressOption.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              requestAddress = value.toString();
                              switch (requestAddress!) {
                                case "Only Billing Address (SPay)":
                                  requestAddressType = AddressInPaymentSheet.NEED_BILLING_SPAY;
                                  updateOnAddressChange(requestAddressType);
                                  isShowBilling = true;
                                  billingCB = true;
                                  isShowShipping = false;
                                  shippingCB = false;
                                  break;
                                case "Only Shipping Address (SPay)":
                                  requestAddressType = AddressInPaymentSheet.NEED_SHIPPING_SPAY;
                                  updateOnAddressChange(requestAddressType);
                                  isShowShipping = true;
                                  shippingCB = true;
                                  isShowBilling = false;
                                  billingCB = false;
                                  break;
                                case "Only Shipping Address (Merchant)":
                                  requestAddressType = AddressInPaymentSheet.SEND_SHIPPING;
                                  updateOnAddressChange(requestAddressType);
                                  isShowShipping = true;
                                  shippingCB = true;
                                  isShowBilling = false;
                                  billingCB = false;
                                  break;
                                case "Billing (SPay), Shipping (Merchant)":
                                  requestAddressType = AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING;
                                  updateOnAddressChange(requestAddressType);
                                  isShowBilling = true;
                                  billingCB = true;
                                  isShowShipping = true;
                                  shippingCB = true;
                                  break;
                                case "Billing and Shipping Addresses (SPay)":
                                  requestAddressType = AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING;
                                  updateOnAddressChange(requestAddressType);
                                  isShowBilling = true;
                                  billingCB = true;
                                  isShowShipping = true;
                                  shippingCB = true;
                                  break;
                                case "No Billing/Shipping Address":
                                  requestAddressType = AddressInPaymentSheet.DO_NOT_SHOW;
                                  updateOnAddressChange(requestAddressType);
                                  isShowBilling = false;
                                  billingCB = false;
                                  shippingCB = false;
                                  isShowShipping = false;
                                  break;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isShowBilling!,
                child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "BILLING ADDRESS CONTROL",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen),
                      ),
                      RadioListTile(
                          title: const Text("Billing Address"),
                          value: 0.0,
                          groupValue: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile = val as double;
                              billingCB = true;
                            });
                          }),
                      RadioListTile(
                          title: const Text("Zipcode only"),
                          value: 1.0,
                          groupValue: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile = val as double;
                              billingCB = true;
                              billingZipCodeCB= true;
                            });
                          }),
                      const Text('Valid Billing Address?'),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent.withAlpha(80),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(1.0),
                        child: DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            color: Colors.transparent,
                          ),
                          value: billingAddError,
                          isExpanded: true,
                          items: MyHomePage.billingAddressError.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              billingAddError = value.toString();
                              if(billingAddError == "CUSTOM_ERROR_MESSAGE") {
                                isShowBillingCustomError = true;
                              }else{
                                isShowBillingCustomError = false;
                              }
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: isShowBillingCustomError!,
                        child: const SizedBox(
                          height: 10,
                        ),
                      ),
                      Visibility(
                        visible: isShowBillingCustomError!,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigoAccent.withAlpha(80),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(1.0),
                          child: TextField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,),
                            controller: billingCustomErrorMessageEC,
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
              const Divider(color: Colors.redAccent),
              Visibility(
              visible: isShowShipping!,
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SHIPPING ADDRESS CONTROLS",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen),
                      ),
                      CheckboxListTile(
                        title: const Text('Shipping Address'),
                        enabled: false,
                        value: shippingCB,
                        onChanged: (val) {
                          setState(() {
                            shippingCB = val;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const Text('Valid Shipping Address?'),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent.withAlpha(80),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(1.0),
                        child: DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            color: Colors.transparent,
                          ),
                          value: shippingAddError,
                          isExpanded: true,
                          items: MyHomePage.shippingAddressError.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              shippingAddError = value.toString();
                              if(shippingAddError == "CUSTOM_ERROR_MESSAGE") {
                                isShowShippingCustomError = true;
                              }else{
                                isShowShippingCustomError = false;
                              }
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: isShowShippingCustomError!,
                        child: const SizedBox(
                         height: 10,
                       ),
                      ),
                      Visibility(
                        visible: isShowShippingCustomError!,
                        child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigoAccent.withAlpha(80),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.all(1.0),
                          child: TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none),
                          controller: shippingCustomErrorMessageEC,
                          onChanged: (val) {},
                        ),
                      ),
                      ),
                      const Divider(color: Colors.redAccent),
                      const Text(
                        'Shipping Method',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      RadioListTile(
                          title: const Text("Standard shipping (Free)"),
                          value: 0.0,
                          groupValue: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile = val as double;
                              mAmountDetailControls.setAddedShippingAmount(selectedRadioTile);
                            });
                          }),
                      RadioListTile(
                          title: const Text("2 days shipping (0.1\$)"),
                          value: 0.1,
                          groupValue: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile = val as double;
                              mAmountDetailControls.setAddedShippingAmount(selectedRadioTile);
                            });
                          }),
                      RadioListTile(
                          title: const Text("1 day shipping (0.2\$)"),
                          value: 0.2,
                          groupValue: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile =  val as double;
                              mAmountDetailControls.setAddedShippingAmount(selectedRadioTile);
                            });
                          }),
                      const Divider(color: Colors.redAccent),
                      const Text("Shipping Address Display Options"),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              enabled: false,
                              title: const Text('ADDRESSEE'),
                              value: true,
                              onChanged: (val) {
                                setState(() {
                                  shippingAddresseeCB = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('ADDRESS'),
                              value: MyHomePage.shippingAddressCB,
                              onChanged: (val) {
                                setState(() {
                                  MyHomePage.shippingAddressCB = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('PHONE NUMBER'),
                              value:  MyHomePage.shippingPhoneCB,
                              onChanged: (val) {
                                setState(() {
                                  MyHomePage.shippingPhoneCB = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('EMAIL'),
                              value:  MyHomePage.shippingEmailCB,
                              onChanged: (val) {
                                setState(() {
                                  MyHomePage.shippingEmailCB = val;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ),
              // Card(
              //   child: Container(
              //       width: double.infinity,
              //       padding: const EdgeInsets.all(10.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             "SHIPPING ADDRESS FROM PARTNER",
              //             style: TextStyle(
              //                 fontSize: 17,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.lightGreen),
              //           ),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: nameEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Name", border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: addressOneEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Address line 1",
              //                   border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: addressTwoEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Address line 2",
              //                   border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: cityEC,
              //               decoration: const InputDecoration(
              //                   labelText: "City", border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: stateEC,
              //               decoration: const InputDecoration(
              //                   labelText: "State/Province",
              //                   border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: zipEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Zip Code",
              //                   border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding: const EdgeInsets.all(1.0),
              //             child: DropdownButton<String>(
              //               underline: Container(
              //                 height: 1,
              //                 color: Colors.transparent,
              //               ),
              //               value: country,
              //               isExpanded: true,
              //               items: isoCountryList?.map((value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: Container(
              //                       width: double.infinity,
              //                       alignment: Alignment.centerLeft,
              //                       padding: const EdgeInsets.all(8),
              //                       child: Text(value.toString())),
              //                 );
              //               }).toList(),
              //               onChanged: (value) {
              //                 setState(() {
              //                   country = value.toString();
              //                 });
              //               },
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: phoneEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Phone Number",
              //                   border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.indigoAccent.withAlpha(80),
              //                 borderRadius:
              //                     const BorderRadius.all(Radius.circular(5))),
              //             padding:
              //                 const EdgeInsets.only(left: 10.0, right: 10.0),
              //             child: TextField(
              //               controller: emailEC,
              //               decoration: const InputDecoration(
              //                   labelText: "Email", border: InputBorder.none),
              //               onChanged: (val) {},
              //             ),
              //           )
              //         ],
              //       )),
              // ),
              Visibility(
                visible: isShowShipping!,
                child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SHIPPING ADDRESS FROM MERCHANT",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "Addressee",
                                  )),
                              Expanded(
                                  child: Text(
                                    "Adam",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "AddressLine1",
                                  )),
                              Expanded(
                                  child: Text(
                                    "708",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "AddressLine2",
                                  )),
                              Expanded(
                                  child: Text(
                                    "1st Avenue SE",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "City",
                                  )),
                              Expanded(
                                  child: Text(
                                    "Bellevue",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "State",
                                  )),
                              Expanded(
                                  child: Text(
                                    "WA",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "CountryCode",
                                  )),
                              Expanded(
                                  child: Text(
                                    "US",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "PostalCode",
                                  )),
                              Expanded(
                                  child: Text(
                                    "98005",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "PhoneNumber",
                                  )),
                              Expanded(
                                  child: Text(
                                    "+18002563789",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    "Email",
                                  )),
                              Expanded(
                                  child: Text(
                                    "sample@h.com",
                                    textAlign: TextAlign.right,
                                  )),
                            ],
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: Colors.indigoAccent.withAlpha(80),
                        //       borderRadius:
                        //       const BorderRadius.all(Radius.circular(5))),
                        //   padding: const EdgeInsets.all(1.0),
                        //   margin: const EdgeInsets.only(top: 10.0),
                        //   child: DropdownButton<String>(
                        //     underline: Container(
                        //       height: 1,
                        //       color: Colors.transparent,
                        //     ),
                        //     value: amountFormat,
                        //     isExpanded: true,
                        //     items: MyHomePage.amountFormatList.map((value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Container(
                        //             width: double.infinity,
                        //             alignment: Alignment.centerLeft,
                        //             padding: const EdgeInsets.all(8),
                        //             child: Text(value)),
                        //       );
                        //     }).toList(),
                        //     onChanged: (value) {
                        //       setState(() {
                        //         amountFormat = value.toString();
                        //       });
                        //     },
                        //   ),
                        // ), //problem
                      ]),
                ),
              ),
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AMOUNT CONTROLS",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Text(
                              "Total Amount",
                            )),
                            Expanded(
                                child: Text(mAmountDetailControls.totalAmount().toString(),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.indigoAccent.withAlpha(80),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50))),
                                child: DropdownButton<String>(
                                  underline: Container(
                                    height: 1,
                                    color: Colors.transparent,
                                  ),
                                  value: currency,
                                  isExpanded: true,
                                  items: MyHomePage.currencyList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(2),
                                          child: Text(value)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      currency = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                "Order No.",
                              )),
                              Expanded(
                                  child: Text(
                                "AMZ007MAR",
                                textAlign: TextAlign.right,
                              )),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                "Product Price",
                              )),
                              Expanded(
                                  child: Text(
                                "1000.00",
                                textAlign: TextAlign.right,
                              )),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                "Tax Amount",
                              )),
                              Expanded(
                                  child: Text(
                                "50.0",
                                textAlign: TextAlign.right,
                              )),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                "Shipping Amount",
                              )),
                              Expanded(
                                  child: Text(
                                "10.0",
                                textAlign: TextAlign.right,
                              )),
                            ],
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: Colors.indigoAccent.withAlpha(80),
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(5))),
                        //   padding: const EdgeInsets.all(1.0),
                        //   margin: const EdgeInsets.only(top: 10.0),
                        //   child: DropdownButton<String>(
                        //     underline: Container(
                        //       height: 1,
                        //       color: Colors.transparent,
                        //     ),
                        //     value: amountFormat,
                        //     isExpanded: true,
                        //     items: MyHomePage.amountFormatList.map((value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Container(
                        //             width: double.infinity,
                        //             alignment: Alignment.centerLeft,
                        //             padding: const EdgeInsets.all(8),
                        //             child: Text(value)),
                        //       );
                        //     }).toList(),
                        //     onChanged: (value) {
                        //       setState(() {
                        //         amountFormat = value.toString();
                        //       });
                        //     },
                        //   ),
                        // ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
          onTap: () {
            startInAppPayWithCustomSheet();
          },

          child: Image.asset('assets/pay_rectangular_full_screen_black.png',height: 70)),
    );
  }

  void _setValueOnTextFields() {
    nameEC?.text = "Adam";
    addressOneEC?.text = "708";
    addressTwoEC?.text = "1st Avenue SE";
    cityEC?.text = "Bellevue";
    stateEC?.text = "WA";
    zipEC?.text = "98005";
    countryEC?.text = "";
    phoneEC?.text = "18002563789";
    emailEC?.text = "sample@h.com";
    customErrorMessageEC?.text = "This is custom error message from flutter app";
    billingCustomErrorMessageEC?.text = "This is billing custom error message from flutter app";
    shippingCustomErrorMessageEC?.text = "This is shipping custom error message from flutter app";
  }

  void updateOnAddressChange(AddressInPaymentSheet requestAddress) {
    if (requestAddress == AddressInPaymentSheet.DO_NOT_SHOW
        || requestAddress == AddressInPaymentSheet.NEED_BILLING_SPAY
    ) {
      mAmountDetailControls.mAddedShippingAmount = 0.0;
      mAmountDetailControls.mDiscountedProductAmount = mAmountDetailControls.mProductAmount;
    }
    mShippingAddressControls.mNeedAllShippingMethodItems =
        requestAddress == AddressInPaymentSheet.NEED_SHIPPING_SPAY
            || requestAddress == AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING;

    if(requestAddress == AddressInPaymentSheet.NEED_BILLING_SPAY ||
        requestAddress == AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING ||
        requestAddress == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING) {
      setState(() {
        billingCB = true;
      });
    }else if(requestAddress == AddressInPaymentSheet.DO_NOT_SHOW ||
        requestAddress == AddressInPaymentSheet.SEND_SHIPPING ||
        requestAddress == AddressInPaymentSheet.NEED_SHIPPING_SPAY
    ){
      setState(() {
        billingCB = false;
      });
    }

    if(requestAddress == AddressInPaymentSheet.NEED_BILLING_SPAY || requestAddress == AddressInPaymentSheet.DO_NOT_SHOW ) {
      setState(() {
        shippingCB = false;
      });
    }else if(requestAddress == AddressInPaymentSheet.SEND_SHIPPING || requestAddress == AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING) {
      setState(() {
        shippingCB = true;
      });
    }else if(requestAddress == AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING || requestAddress == AddressInPaymentSheet.NEED_SHIPPING_SPAY){
      setState(() {
        billingCB = false;
      });
    }
  }
}

class StatusResponse extends StatefulWidget {
  const StatusResponse({Key? key}) : super(key: key);

  @override
  State<StatusResponse> createState() => _StatusResponseState();
}

class _StatusResponseState extends State<StatusResponse> {
  @override
  Widget build(BuildContext context) {
    final statusHolder = ModalRoute.of(context)!.settings.arguments as StatusHolder;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Samsung Pay SDK Flutter'),
        ),
        body: Column(
          children: [
            Text(statusHolder.status==true?"Onsuccess":"OnFail\n"),
            Text(statusHolder.statusCode),
            Text(statusHolder.bundle.toString()),
          ],
        ));
  }
}

class RequestCardData extends StatefulWidget {
  const RequestCardData({Key? key}) : super(key: key);

  @override
  State<RequestCardData> createState() => _RequestCardDataState();
}

class _RequestCardDataState extends State<RequestCardData> {

  @override
  Widget build(BuildContext context) {
    final cardList = ModalRoute.of(context)!.settings.arguments as List<PaymentCardInfo>;
    return Scaffold(
      appBar: AppBar(title: const Text('Samsung Pay SDK Flutter')),
      body: cardList.length > 0
          ? ListView.separated(
        itemCount: cardList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text('Card: ${cardList[index].brand}'),
                ],
              )
          );
        }, separatorBuilder: (BuildContext context, int index) =>const Divider(),
      )
          : const Center(child: Text('No cards')),
    );
  }
}