
import 'package:flutter/material.dart';
import 'package:samsung_pay_sdk_flutter/samsung_pay_sdk_flutter.dart';
import 'package:samsung_pay_sdk_flutter_example/ui/push_provision.dart';
import 'package:samsung_pay_sdk_flutter_example/util/util.dart';




void main() {

  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class StatusHolder{
  final bool status;
  final String statusCode;
  final Map<String,dynamic> bundle;

  StatusHolder(this.status,this.statusCode,this.bundle);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final samsungPaySdkFlutterPlugin = SamsungPaySdkFlutter(PartnerInfo(serviceId: '004a806b07174128b076dd', data: {SpaySdk.PARTNER_SERVICE_TYPE:ServiceType.APP2APP.name.toString()}));


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  void _getSamsungPayStatus() {
   StatusHolder statusHolder;
   Util.showProgressDialog(context);
   MyApp.samsungPaySdkFlutterPlugin.getSamsungPayStatus(StatusListener(onSuccess: (status, bundle) async {
     Util.dismissProgressDialog(context);
      statusHolder = StatusHolder(true, status, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));

    }, onFail:(errorCode, bundle){
     Util.dismissProgressDialog(context);
      statusHolder = StatusHolder(false, errorCode, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));
    }));
  }




  void getAll(BuildContext context){
    //Util.showProgressDialog(context);
    MyApp.samsungPaySdkFlutterPlugin.getAllCards(GetCardListener(onSuccess:(list){

      //Util.dismissProgressDialog(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const GetAllCardsResult(),
          settings: RouteSettings(arguments: list)));
    }, onFail:(errorCode, bundle){
      //Util.dismissProgressDialog(context);
      StatusHolder statusHolder= StatusHolder(false, errorCode, bundle);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>const StatusResponse(),
              settings: RouteSettings(arguments: statusHolder)));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Samsung Pay SDK Flutter'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
                  ElevatedButton(onPressed: (){
                    _getSamsungPayStatus();
                    }, child: const Text('Get Samsung Pay Status')),
                  ElevatedButton(onPressed: () async {
                    await MyApp.samsungPaySdkFlutterPlugin.goToUpdatePage();
                    }, child: const Text('Go to Update Page')),
                  ElevatedButton(onPressed: () async {
                    await MyApp.samsungPaySdkFlutterPlugin.activateSamsungPay();
                    }, child: const Text('Activate Samsung Pay')),
                  ElevatedButton(onPressed: (){
                      getAll(context);
                    }, child: const Text('Get All Cards')),
                  ElevatedButton(onPressed: () async {
                    Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>const AddCard()));
                    }, child: const Text('Add Card to Samsung pay'))
            ])
          ),
        ),
      ),
    );
  }
}

class GetAllCardsResult extends StatefulWidget {
  const GetAllCardsResult({Key? key}) : super(key: key);

  @override
  State<GetAllCardsResult> createState() => _GetAllCardsResultState();
}

class _GetAllCardsResultState extends State<GetAllCardsResult> {

  @override
  Widget build(BuildContext context) {
    final cardList = ModalRoute.of(context)!.settings.arguments as List<WalletCard>;
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
                Text('Card ID: ${cardList[index].cardId}'),
                Text('Card brand: ${cardList[index].cardBrand}'),
                Text('Card Status: ${cardList[index].cardStatus}'),
                Text('Card last4Dpan: ${cardList[index].cardInfo.last4Dpan}'),
                Text('Card last4Fpan: ${cardList[index].cardInfo.last4Fpan}'),
              ],
            )
          );
        }, separatorBuilder: (BuildContext context, int index) =>const Divider(),
      )
          : const Center(child: Text('No cards')),
    );
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

