import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

enum ProductSortOption { none, priceAsc, priceDesc, nameAsc, nameDesc }

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = []; 
  List<Product> _displayedProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products =>
      [..._products];
  List<Product> get displayedProducts => [..._displayedProducts];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    fetchProducts(); 
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection('products').get();
      _products =
          querySnapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
      _displayedProducts =
          List.from(_products); 
    } catch (e) {
      _errorMessage = '��� �� ��� ��������: $e';
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortProducts(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.none:
        _displayedProducts = List.from(_products); 
        break;
      case ProductSortOption.priceAsc:
        _displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceDesc:
        _displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.nameAsc:
        _displayedProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.nameDesc:
        _displayedProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    notifyListeners();
  }

  ����� ����� ���� ���� ��ǡ ���:
  Future<void> addProduct(Product product) async { ... }
  Future<void> updateProduct(Product product) async { ... }
  Future<void> deleteProduct(String productId) async { ... }
}
