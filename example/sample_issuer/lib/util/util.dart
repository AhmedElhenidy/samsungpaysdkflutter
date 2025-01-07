import 'package:flutter/material.dart';

class Util {
  static void showToast(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.black.withAlpha(150),
        content: Container(color: Colors.transparent, child: Text(message)),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true));
  }

  static void showError(context, errorCode, bundle) {
    StringBuffer stringBuffer = StringBuffer("");
    (bundle as Map<String, dynamic>).forEach((key, value) {
      stringBuffer.writeln("$key : $value");
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Exception Occurred!!!'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [Text("Error"), Text(" : "), Text(errorCode.toString(),style: TextStyle(color: Colors.redAccent),)]),
                _getView(bundle)
              ]
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  static void showProgressDialog(context)
  {
    showDialog(
        context: context,
        builder: (context) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
              body: Center(
                child:  CircularProgressIndicator(),
              ),
          );
        });
  }

  static void dismissProgressDialog(context)
  {
    Navigator.pop(context);
  }

  static Widget _getView(Map<String, dynamic> bundle) {
    List<Widget> viewList = [];
    for (var element in bundle.keys) {
      viewList.add(Text("$element : ${bundle[element].toString()}"));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: viewList);
  }
}