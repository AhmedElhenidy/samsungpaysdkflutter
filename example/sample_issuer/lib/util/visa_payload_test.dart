
import '../ui/push_provision.dart';

class VisaPayloadTest {
  static Future<String?> createPayload(String clientDeviceId, String clientWalletAccountId) {
    Future<String> createPayload =Future.value(AddCard.createPayload);
    return createPayload;
  }
}