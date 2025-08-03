import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFeatured;
  final bool isNewArrival;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFeatured = false,
    this.isNewArrival = false,
  });
factory Product.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '���� ��� �����',
      description: data['description'] ?? '�� ���� ��� ����.',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ??
          'https://via.placeholder.com/150',
      isFeatured: data['isFeatured'] ?? false,
      isNewArrival: data['isNewArrival'] ?? false,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '', // ���� �� ��� ID ����� �� ��� Map �� �������� ���
      name: map['name'] ?? '���� ��� �����',
      description: map['description'] ?? '�� ���� ��� ����.',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
      isFeatured: map['isFeatured'] ?? false,
      isNewArrival: map['isNewArrival'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
    };
  }
}
