import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:topics/repo/user/firestore_user_repo.dart';

class StoreProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirestoreUserRepository _userRepo;
  final PurchaseRepository _purchaseRepo;
  late Stream<List<PurchaseDetails>> _purchaseStream;
  List<ProductDetails> _products = [];

  StoreProvider(
      {required UserRepository userRepo,
      required PurchaseRepository purchaseRepo})
      : _userRepo = userRepo,
        _purchaseRepo = purchaseRepo {
    _purchaseStream = _inAppPurchase.purchaseStream;
    _purchaseStream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    Set<String> ids = storeItems.map((e) => e.id).toSet();
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(ids);
    if (productDetailsResponse.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    _products = productDetailsResponse.productDetails;
    notifyListeners();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Get corresponding StoreItem
        StoreItem item = storeItems
            .firstWhere((element) => element.id == purchase.productID);

        // Update user message count
        _userRepo.addMessages(item.messageCount);

        // Store the purchase
        _purchaseRepo.storePurchase(purchase);

        // Don't forget to deliver the product here and then call
        _inAppPurchase.completePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle the error here.
      }
    }
  }

  List<ProductDetails> get products => _products;

  void buyProduct(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
