import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:topics/services/auth/auth_service.dart';
import '../../domain/repo/i_user_repository.dart';

class StoreProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final IUserRepository userRepository;
  final AuthService authService = AuthService();
  List<ProductDetails> _products = [];

  List<ProductDetails> get products => _products;

  set products(List<ProductDetails> products) {
    _products = products;
    notifyListeners();
  }

  StoreProvider({required this.userRepository});

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> loadProducts() async {
    final List<String> storeItems = [
      'test',
      '50_messages_pack',
      '100_messages_pack',
      '500_messages_pack',
    ];

    final productIds = storeItems.map((item) => item).toSet();
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }

    products = response.productDetails;
  }

  void handlePurchase(PurchaseDetails purchase) {
    if (purchase.status == PurchaseStatus.purchased) {
      if (!purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
        // Extract the number of messages based on product id
        final messageCount = getMessageCountFromProductId(purchase.productID);
        // Increase user messages4

        if (purchase.status == PurchaseStatus.purchased) {
          userRepository.increaseMessages(
              authService.getCurrentUser()?.uid ?? '', messageCount);
        }
      }
    } else if (purchase.status == PurchaseStatus.error) {
      print('error');
    }
  }

  // Add more cases depending on your products
  int getMessageCountFromProductId(String productId) {
    switch (productId) {
      case '50_messages_pack':
        return 50;
      case '100_messages_pack':
        return 100;
      case '500_messages_pack':
        return 500;
      default:
        return 0;
    }
  }
}
