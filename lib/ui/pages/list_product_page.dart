import 'package:epsi_shop/bo/product.dart';
import 'package:epsi_shop/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListProductPage extends StatelessWidget {
  ListProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('EPSI Shop'),
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
