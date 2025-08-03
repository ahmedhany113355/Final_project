// lib/widgets/common/product_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../../screens/home/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: const Color.fromRGBO(
              0, 0, 0, 0.7),
          leading: Consumer<WatchlistProvider>(
            builder: (ctx, watchlist, child) => IconButton(
              icon: Icon(
                watchlist.isInWatchlist(product.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                watchlist.toggleWatchlist(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      watchlist.isInWatchlist(product.id)
                          ? '${product.name} ��� ������ ������ ���������!'
                          : '${product.name} ��� ������ �� ����� ���������!',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} ��� ������ ������!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        header: product.isFeatured
            ? GridTileBar(
                backgroundColor: Colors.deepOrange.withAlpha((255 * 0.8)
                    .round()), // �� ����� Colors.deepOrange.withOpacity(0.8)
                title: const Text(
                  '����',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
                ),
              )
            : null,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProductDetailsScreen(productId: product.id),
              ),
            );
          },
          child: Hero(
            tag: product.id,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
