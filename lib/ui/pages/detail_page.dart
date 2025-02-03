import 'package:epsi_shop/bo/cart.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:epsi_shop/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage(this.idProduct, {super.key});

  final int idProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product Detail'),
        actions: [
          IconButton(
            onPressed: () => context.go("/cart"),
            icon: Badge(
              label: Text(context.watch<Cart>().listProducts.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: ApiService.getSingleProduct(idProduct),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.image,
                  height: 150,
                ),
                TitleLinePrice(product: product),
                Description(product: product),
                const Spacer(),
                AddToCartButton(product: product)
              ],
            );
          } else {
            return const Center(child: Text('Produit introuvable'));
          }
        },
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        product.description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class TitleLinePrice extends StatelessWidget {
  const TitleLinePrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              product.title,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            product.getPrice(),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            cart.addProduct(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title} ajouté au panier")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          child: const Text("Ajouter au panier"),
        ),
      ),
    );
  }
}
