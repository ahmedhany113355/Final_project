import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WatchlistProvider with ChangeNotifier {
  final List<Product> _watchlist = [];

  List<Product> get watchlist {
    return [..._watchlist]; 
    }

  bool isInWatchlist(String productId) {
    return _watchlist.any((product) => product.id == productId);
  }

  void toggleWatchlist(Product product) {
    if (isInWatchlist(product.id)) {
      // �� ����� removeProductFromWatchlist (�� ����� �����)
      removeProductFromWatchlist(product.id);
    } else {
      addProductToWatchlist(product);
    }
    notifyListeners();
  }

  void addProductToWatchlist(Product product) {
    if (!isInWatchlist(product.id)) {
      _watchlist.add(product);
      notifyListeners();
    }
  }
  
  void removeProductFromWatchlist(String productId) {
    _watchlist.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
}
