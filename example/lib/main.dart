import 'package:flutter/material.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';
import 'package:samsung_pay_sdk_flutter_example/util/Strings.dart';

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(title: "In-App Payment"),
    debugShowCheckedModeBanner: false));
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static const String SERVICE_ID = '7c0e452b6b48450f9de0dc';

  // Set PartnerInfo to initialize SamsungPaySdkFlutter
  static final samsungPaySdkFlutterPlugin = SamsungPaySdkFlutter(
      PartnerInfo(
          serviceId: SERVICE_ID,
          data:{SpaySdk.PARTNER_SERVICE_TYPE:ServiceType.INAPP_PAYMENT.name}
      )
  );

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSPayStatusReady = false;
  String? postalCode = "Not received yet";

  @override
  void initState() {
    super.initState();
    //Check Samsung Pay Status
    checkSamsungPaystatus();
  }

  List<Brand> get brandList {
    List<Brand> brandList = [
      Brand.VISA,
      Brand.MASTERCARD,
      Brand.AMERICANEXPRESS,
      Brand.DISCOVER,
      Brand.MADA, 
    ];
    return brandList;
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(msg),
        action: SnackBarAction(label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }


  void checkSamsungPaystatus() {
    //Update UI according to Samsung Pay Status
    MyHomePage.samsungPaySdkFlutterPlugin.getSamsungPayStatus(StatusListener(onSuccess: (status, bundle) async {
      if(status == "2") {
        setState(() {
          isSPayStatusReady = true;
        });
      } else {
        setState(() {
          isSPayStatusReady = false;
        });
        _showToast(context,"SPay Status: Not Ready");
      }
    }, onFail:(errorCode, bundle){
      setState(() {
        isSPayStatusReady = false;
      });
      _showToast(context,"SPay Status: API Call Failed");
    }));
  }

  void requestPaymentWithSamsungWallet()
  {
    //Create a transaction request with CustomSheetPaymentInfo and CustomSheetTransactionInfoListener
    MyHomePage.samsungPaySdkFlutterPlugin.startInAppPayWithCustomSheet(makeTransactionDetailsWithSheet(), transactionListener());
  }

  CustomSheetPaymentInfo makeTransactionDetailsWithSheet(){
    //Populate data field for CustomSheetPaymentInfo
    Map<String, dynamic> extraPaymentInfo = {};
    extraPaymentInfo[SpaySdk.EXTRA_CRYPTOGRAM_TYPE] = 'NONE';
    extraPaymentInfo[SpaySdk.EXTRA_ACCEPT_COMBO_CARD] = false;
    extraPaymentInfo[SpaySdk.EXTRA_REQUIRE_CPF] = false;

    CustomSheetPaymentInfo customSheetPaymentInfo =  CustomSheetPaymentInfo(merchantName: "In App Payment flutter app", customSheet: makeUpCustomSheet());
    customSheetPaymentInfo.merchantId = "123456";
    customSheetPaymentInfo.setOrderNumber("AMZ007MAR");
    customSheetPaymentInfo.setMerchantCountryCode("US");
    customSheetPaymentInfo.addressInPaymentSheet = AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING;
    customSheetPaymentInfo.allowedCardBrand = brandList;
    customSheetPaymentInfo.setCardHolderNameEnabled(false);
    customSheetPaymentInfo.setExtraPaymentInfo(extraPaymentInfo);
    return customSheetPaymentInfo;
  }

  CustomSheetTransactionInfoListener transactionListener(){
    CustomSheetTransactionInfoListener customSheetTransactionInfoListener = CustomSheetTransactionInfoListener(onCardInfoUpdated: (PaymentCardInfo paymentCardInfo, CustomSheet customSheet) {
      MyHomePage.samsungPaySdkFlutterPlugin.updateSheet(customSheet);
    }, onSuccess: (CustomSheetPaymentInfo customSheetPaymentInfo, String paymentCredential, Map<String, dynamic>? extraPaymentData) {
        print("Payment Success");
    }, onFail: (String errorCode, Map<String, dynamic> bundle) {
        print("Payment Failed");
    });
    return customSheetTransactionInfoListener;
  }

  CustomSheet makeUpCustomSheet(){
    SheetUpdatedListener sheetUpdatedListener = SheetUpdatedListener(onResult: (String controlId, CustomSheet sheet){
      if(controlId == Strings.BILLING_ADDRESS_ID){
        var addressControl = sheet.getSheetControl(controlId) as AddressControl;
        setState(() {
          postalCode = addressControl.address!.postalCode;
        });
      }
      MyHomePage.samsungPaySdkFlutterPlugin.updateSheet(sheet);
    });

    CustomSheet customSheet = CustomSheet();
    customSheet.addControl(makeAmountControl());
    customSheet.addControl(makeBillingAddress(sheetUpdatedListener));
    customSheet.addControl(makeShippingAddress());
    return customSheet;
  }

  AmountBoxControl makeAmountControl() {
    AmountBoxControl amountBoxControl = AmountBoxControl(Strings.AMOUNT_CONTROL_ID, Strings.currency);
    amountBoxControl.addItem(Strings.PRODUCT_ITEM_ID, "Item", 1199.00, "");
    amountBoxControl.addItem(Strings.PRODUCT_TAX_ID, "Tax", 5.0, "");
    amountBoxControl.addItem(Strings.PRODUCT_SHIPPING_ID, "Shipping", 1.0, "");
    amountBoxControl.setAmountTotal(1205.00, SpaySdk.FORMAT_TOTAL_PRICE_ONLY);
    return amountBoxControl;
  }

  AddressControl makeBillingAddress(SheetUpdatedListener billingListener) {
    AddressControl billingAddressControl =
    AddressControl(Strings.BILLING_ADDRESS_ID, SheetItemType.ZIP_ONLY_ADDRESS.name);
    billingAddressControl.setAddressTitle(Strings.billing_address);
    billingAddressControl.sheetUpdatedListener = billingListener;
    return billingAddressControl;
  }

  AddressControl makeShippingAddress( ) {
    AddressControl shippingAddressControl =
    AddressControl(Strings.SHIPPING_ADDRESS_ID, SheetItemType.SHIPPING_ADDRESS.name);
    shippingAddressControl.setAddressTitle(Strings.shipping_address);
    shippingAddressControl.address = buildShippingAddressInfo();
    return shippingAddressControl;
  }

  Address buildShippingAddressInfo() {
    Address mAddress;
    mAddress = Address(addressee: "Jane Smith",
        addressLine1: "123 Main St",
        addressLine2: "Suite 456",
        city: "Anytown",
        state: "ST",
        countryCode: "USA",
        postalCode: "12345",
        phoneNumber: "555-123-4567",
        email: "example@email.com");

    return mAddress;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Card(
              child: ImageSection(image: 'assets/S24ultra.png'),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      'Billing Address:',
                      style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //const SizedBox(width: 70),
                        const Text(
                            'Zip Code',
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text(
                            ': ''$postalCode',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Card(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Shipping Address:',
                      style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 60),
                        Text('Addressee\n'
                            'Address Line1\n'
                            'Address Line2\n'
                            'City\n'
                            'State\n'
                            'Country Code\n'
                            'Postal Code\n'
                            'Phone Number\n'
                            'Email',
                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        Text(': Jane Smith\n'
                            ': 123 Main St\n'
                            ': Suite 456\n'
                            ': Anytown\n'
                            ': ST\n'
                            ': USA\n'
                            ': 12345\n'
                            ': 555-123-4567\n'
                            ': example@email.com',
                            textAlign: TextAlign.left
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //Add the Samsung Pay button in the bottom navigation bar
      bottomNavigationBar: Visibility(
        visible: isSPayStatusReady,
        child: InkWell(
          onTap: (){
            requestPaymentWithSamsungWallet();
          },
          child: Image.asset('assets/pay_rectangular_full_screen_black.png'),
        ),
    ),
    );
  }
}

class ImageSection extends StatelessWidget{
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context){
    return Image.asset(image, width: 600, height: 240,fit: BoxFit.contain,);
  }
}
