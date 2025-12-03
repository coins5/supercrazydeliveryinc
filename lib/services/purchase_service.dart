import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final Function(bool) onPremiumStatusChanged;
  final Function(String) onError;

  PurchaseService({
    required this.onPremiumStatusChanged,
    required this.onError,
  });

  Future<void> initialize() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        onError("Purchase Stream Error: $error");
      },
    );
  }

  Future<void> buyPremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      onError("Store not available");
      return;
    }

    const Set<String> kIds = {'premium'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      kIds,
    );
    if (response.notFoundIDs.isNotEmpty) {
      onError("Product not found: ${response.notFoundIDs}");
      return;
    }

    if (response.productDetails.isEmpty) {
      onError("No product details found for 'premium'");
      return;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      onError("Failed to initiate purchase: $e");
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onError("Failed to restore purchases: $e");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          onError("Purchase Error: ${purchaseDetails.error?.message}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.productID == 'premium') {
            onPremiumStatusChanged(true);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}
