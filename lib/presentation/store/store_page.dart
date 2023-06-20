import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:uuid/uuid.dart';

// Mock data for the store items.
final List<StoreItem> storeItems = [
  StoreItem(const Uuid().v4(), '50 Message Pack', 50, '0.99'),
  StoreItem(const Uuid().v4(), '100 Message Pack', 100, '1.89'),
  StoreItem(const Uuid().v4(), '200 Message Pack', 200, '3.69'),
  StoreItem(const Uuid().v4(), '500 Message Pack', 500, '8.99'),
];

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late Stream<List<PurchaseDetails>> _purchaseStream;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    _purchaseStream = _inAppPurchase.purchaseStream;
    _purchaseStream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    _loadProducts();
    super.initState();
  }

  Future<void> _loadProducts() async {
    Set<String> ids = storeItems.map((e) => e.id).toSet();
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(ids);
    if (productDetailsResponse.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    setState(() {
      _products = productDetailsResponse.productDetails;
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Handle the purchase here.
        // Don't forget to deliver the product here and then call
        // completePurchase(purchase)
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle the error here.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          final product = _products[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                const SizedBox(height: 10),
                Text(
                  product.price,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final PurchaseParam purchaseParam =
                        PurchaseParam(productDetails: product);
                    _inAppPurchase.buyNonConsumable(
                        purchaseParam: purchaseParam);
                  },
                  child: Text('Buy'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StoreItem {
  final String id;
  final String name;
  final int messageCount;
  final String price;

  StoreItem(this.id, this.name, this.messageCount, this.price);
}
