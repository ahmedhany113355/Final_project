
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/common/product_card.dart';
import '../cart/shopping_cart_screen.dart';

class ProductsHomeScreen extends StatefulWidget {
  const ProductsHomeScreen({super.key});

  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen> {
  ProductSortOption _selectedSortOption = ProductSortOption.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('��������'),
        actions: [
          PopupMenuButton<ProductSortOption>(
            onSelected: (ProductSortOption result) {
              setState(() {
                _selectedSortOption = result;
              });
              productProvider.sortProducts(result);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ProductSortOption>>[
              const PopupMenuItem<ProductSortOption>(
                value: ProductSortOption.none,
                child: Text('������� ���������'),
              ),
              const PopupMenuItem<ProductSortOption>(
                value: ProductSortOption.priceAsc,
                child: Text('�����: �� ����� ������'),
              ),
              const PopupMenuItem<ProductSortOption>(
                value: ProductSortOption.priceDesc,
                child: Text('�����: �� ������ �����'),
              ),
              const PopupMenuItem<ProductSortOption>(
                value: ProductSortOption.nameAsc,
                child: Text('�����: �-�'),
              ),
              const PopupMenuItem<ProductSortOption>(
                value: ProductSortOption.nameDesc,
                child: Text('�����: �-�'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ShoppingCartScreen()),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartProvider.itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
              ? Center(child: Text(productProvider.errorMessage!))
              : RefreshIndicator(
                  onRefresh: () => productProvider.fetchProducts(),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildBanner('���� ����',
                                  'https://images.unsplash.com/photo-1546868871-7041f2a55e12?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NzgyMjl8MHwxfHxzbWFydHdhdGNofGVufDB8fHx8MTcyMDA3OTE3OXww&ixlib=rb-4.0.3&q=80&w=1080'),
                              _buildBanner('������ �������',
                                  'https://images.app.goo.gl/mvX6qg5ANET21vT4A'),
                              _buildBanner('������� �����',
                                  'https://images.unsplash.com/photo-1555529719-59bc655513d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NzgyMjl8MHwxfHxzYWxlJTIwYmFubmVyfGVufDB8fHx8MTcyMDA3OTE4NXww&ixlib=rb-4.0.3&q=80&w=1080'),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '������ �����',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product =
                                productProvider.displayedProducts[index];
                            return ProductCard(product: product);
                          },
                          childCount: productProvider.displayedProducts.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBanner(String title, String imageUrl) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
          // **�� ����� ������� ���: ����� 'const'**
          colorFilter: const ColorFilter.mode(
            Color.fromRGBO(0, 0, 0, 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
