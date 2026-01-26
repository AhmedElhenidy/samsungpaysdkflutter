# Samsung Pay SDK Flutter Example

This example demonstrates how to use the Samsung Pay SDK Flutter plugin for in-app payments.

## Features

- Initialize Samsung Pay SDK
- Check Samsung Pay status
- Process payments with custom payment sheet
- Support for multiple card brands including:
  - VISA
  - Mastercard
  - American Express
  - Discover
  - **MADA** (Saudi Arabia payment network)

## Getting Started

1. Make sure you have a valid Samsung Pay service ID configured
2. Update the `SERVICE_ID` in `main.dart` with your service ID
3. Run the app on a Samsung device with Samsung Pay enabled

## Supported Card Brands

The example app demonstrates support for the following card brands:

```dart
List<Brand> brandList = [
  Brand.VISA,
  Brand.MASTERCARD,
  Brand.AMERICANEXPRESS,
  Brand.DISCOVER,
  Brand.MADA, 
];
```

## MADA Transaction Type

For MADA  payment transactions, you can specify the transaction type:

```dart
// Set transaction type for MADA payments (optional)
// Default is TransactionType.PURCHASE
customSheetPaymentInfo.setTransactionType(TransactionType.PURCHASE);

// Or for pre-authorization:
customSheetPaymentInfo.setTransactionType(TransactionType.PREAUTHORIZATION);
```

**Note:** The transaction type is specifically supported for MADA tokens and will not apply to other token types.

## Resources

- [Samsung Pay Developer Documentation](https://developer.samsung.com/pay)
- [Flutter Documentation](https://docs.flutter.dev/)
