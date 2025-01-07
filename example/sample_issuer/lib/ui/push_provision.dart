import 'package:flutter/material.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';
import 'package:samsung_pay_sdk_flutter_example/main.dart';
import 'package:samsung_pay_sdk_flutter_example/util/util.dart';
import 'package:samsung_pay_sdk_flutter_example/util/visa_payload_test.dart';

class AddCard extends StatefulWidget {
  static const List<String> tokenProviderList = ['Visa', 'Master Card', 'MI', 'Pago Bancomat', 'Vaccine Pass'];
  static const String createPayload  = "Create your own payload based on the specification provided by the Card network (Visa, MasterCard, Amex etc.)";
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {

  String? tokenProvider = AddCard.tokenProviderList.first;
  String? tokenProviderHint='Select Token Provider';
  String payload="";
  String? payloadHint="No encrypted payload data, please click 'Get Wallet Info' to generate encrypted payload.";


  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: const Color(0xEEFFFFFF),
      appBar: AppBar(title: const Text("Add Card")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.indigoAccent.withAlpha(20))),
                padding: const EdgeInsets.all(5.0),
                child: DropdownButton<String>(
                  underline: Container(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  value: tokenProvider,
                  isExpanded: true,
                  items: AddCard.tokenProviderList.map((value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          width:double.infinity,
                          alignment:Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          child:Text(value)
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tokenProvider=value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      getWalletInfo(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen
                    ),
                    child: const Text('Get Wallet Info',style: TextStyle(color: Colors.white),)
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*.5,
                decoration: BoxDecoration(color: Colors.white,border: Border.all(width: 1.0, color: Colors.indigoAccent.withAlpha(20))),
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(child: (payload.isEmpty) ? Text(payloadHint.toString()):Text(payload.toString(), maxLines: 50)),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if(payload.isNotEmpty && payload != AddCard.createPayload){
                        addCard(context);
                      }else{
                        Util.showToast(context, "Payload is not correct!!!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                    ),
                    child: const Text('Add Card',style: TextStyle(color: Colors.white),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getWalletInfo(BuildContext context) {

    Util.showProgressDialog(context);
    MyApp.samsungPaySdkFlutterPlugin.getWalletInfo(StatusListener(onSuccess: (status, bundle) async {

      Util.dismissProgressDialog(context);
      VisaPayloadTest.createPayload(bundle["deviceId"], bundle["walletUserId"]).then((value) => {

        setState(() {
          payload = value!;
        })

      });

    }, onFail: (errorCode, bundle) {

      Util.dismissProgressDialog(context);
      Util.showError(context, errorCode, bundle);
      print("Error : $errorCode / Data : $bundle");

    }));
  }

  void addCard(BuildContext wContext) async {

    var addCardInfo = AddCardInfo( WalletCard.CARD_TYPE_CREDIT_DEBIT,  getTokenProvider(tokenProvider.toString()), {AddCardInfo.EXTRA_PROVISION_PAYLOAD:payload});
    Util.showProgressDialog(wContext);
    MyApp.samsungPaySdkFlutterPlugin.addCard(addCardInfo, AddCardListener(onSuccess: (status, card){

      print("Success : $status / Data : $card");
      Util.dismissProgressDialog(wContext);

    },onFail: (errorCode, bundle){

      Util.dismissProgressDialog(wContext);
      Util.showError(context, errorCode, bundle);
      print("Error : $errorCode / Data : $bundle");

    },onProgress: (currentCount, totalCount, bundle){

      print("currentCount : $currentCount / totalCount : $totalCount / Data : $bundle");
      //Util.dismissProgressDialog(wContext);

    }));
  }

  String getTokenProvider(String toString) {
    switch(toString){
      case "Visa" : return AddCardInfo.PROVIDER_VISA;
      case "MI" : return AddCardInfo.PROVIDER_MIR;
      case "Master Card" : return AddCardInfo.PROVIDER_MASTERCARD;
      case "Pago Bancomat" : return AddCardInfo.PROVIDER_PAGOBANCOMAT;
      case "Vaccine Pass" : return AddCardInfo.PROVIDER_VACCINE_PASS;
      default : return "unknown";
    }
  }
}

