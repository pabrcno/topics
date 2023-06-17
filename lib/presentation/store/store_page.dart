import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:topics/presentation/widgets/disabled.dart';

const String defaultGooglePayConfigString = '''
{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}
''';
// Mock data for the store items.
final List<StoreItem> storeItems = [
  StoreItem('50 Message Pack', 50, '0.99'),
  StoreItem('100 Message Pack', 100, '1.89'),
  StoreItem('200 Message Pack', 200, '3.69'),
  StoreItem('500 Message Pack', 500, '8.99'),
];

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: storeItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          final item = storeItems[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Text(
                  '\$${item.price}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Disabled(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GooglePayButton(
                    onError: (error) => log(error.toString()),
                    paymentConfiguration: PaymentConfiguration.fromJsonString(
                      defaultGooglePayConfigString,
                    ),
                    paymentItems: [
                      PaymentItem(
                        label: item.name,
                        amount: item.price,
                        status: PaymentItemStatus.final_price,
                      )
                    ],
                    type: GooglePayButtonType.buy,
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    print(paymentResult);
  }
}

class StoreItem {
  final String name;
  final int messageCount;
  final String price;

  StoreItem(this.name, this.messageCount, this.price);
}