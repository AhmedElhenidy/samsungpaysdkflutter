# Samsung Pay Flutter Plugin

This plugin allows you to integrate Samsung Pay functionality into your Flutter applications, enabling secure and convenient in-app payments for your users on Samsung devices.

Note: This plugin serves as a wrapper around the official Samsung Pay Flutter SDK. For detailed information and comprehensive documentation on the available features and functionalities, please refer to the official Samsung Pay Flutter SDK documentation:
[Samsung Pay](https://developer.samsung.com/codelab/pay/flutter-plugin.html#Objective)

### Android Setup
Go to android > app > src > main > AndroidManifest.xml and add the API level in the meta-data of application tag.
```
<meta-data 
    android:name="spay_sdk_api_level" 
    android:value="2.19" /> // most recent SDK version is recommended to leverage the latest APIs 
        
```

### Setup SamsungPay Object
define instance of `SamsungPaySdkFlutter`
please consider to use your `serviceId`, the used one below is for test purpose only

```dart
final samsungPaySdkFlutterPlugin = SamsungPaySdkFlutter(
  PartnerInfo(
    serviceId: '0b89048b46b64cd3a3e60c',
    data: {SpaySdk.PARTNER_SERVICE_TYPE:ServiceType.INAPP_PAYMENT.name},
  ),
);
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)