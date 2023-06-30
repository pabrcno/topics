import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:topics/services/auth/auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';
import '../../domain/repo/i_user_repository.dart';

class StoreProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final IUserRepository userRepository;
  final AuthService authService = AuthService();
  List<ProductDetails> _products = [];
  final _errorCommander = ErrorCommander();
  int userMessageCount = 0;
  PurchaseDetails? completedPurchase;
  List<ProductDetails> get products => _products;

  set products(List<ProductDetails> products) {
    _products = products;
    notifyListeners();
  }

  StoreProvider({required this.userRepository});

  Future<void> _deliverMessage(ProductDetails product) async {
    final messageCount = getMessageCountFromProductId(product.id);
    userRepository.increaseMessages(
        authService.getCurrentUser()?.uid ?? '', messageCount);
    userMessageCount += messageCount;
  }

  Future<void> buyProduct(ProductDetails product, BuildContext context) async {
    return await _errorCommander.run(() async {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);

      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
      );

      _inAppPurchase.purchaseStream.listen((purchaseDetails) {
        if (purchaseDetails
            .any((element) => element.status == PurchaseStatus.purchased)) {
          _deliverMessage(product);
          completedPurchase = purchaseDetails.firstWhere(
              (element) => element.status == PurchaseStatus.purchased);
        }
      }, onDone: () {
        if (completedPurchase != null) {
          _inAppPurchase.completePurchase(completedPurchase!);
        }
      }, onError: (error) {
        throw error;
      });
    });
  }

  Future<void> loadProducts() async {
    final List<String> storeItems = [
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
