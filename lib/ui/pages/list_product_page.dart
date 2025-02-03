import 'package:epsi_shop/bo/cart.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:epsi_shop/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatelessWidget {
  ListProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('EPSI Shop'),
          actions: [
            IconButton(
              onPressed: () => context.go("/cart"),
              icon: Badge(
                label:
                    Text(context.watch<Cart>().listProducts.length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          ],
        ),
        body: FutureBuilder<List<Product>>(
            future: ApiService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final listProducts = snapshot.data!;
                return ListViewProducts(listProducts: listProducts);
              } else {
                return const Center(child: Text("Erreur de chargement"));
              }
            }));
  }
}

class ListViewProducts extends StatelessWidget {
  const ListViewProducts({
    super.key,
    required this.listProducts,
  });

  final List<Product> listProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listProducts.length,
        itemBuilder: (ctx, index) => InkWell(
              onTap: () => ctx.go("/detail/${listProducts[index].id}"),
              // /detail/4
              child: ListTile(
                leading: Image.network(
                  listProducts[index].image,
                  width: 90,
                  height: 90,
                ),
                title: Text(listProducts[index].title),
                subtitle: Text(listProducts[index].getPrice()),
              ),
            ));
  }
}
