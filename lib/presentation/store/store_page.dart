import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/store/store_provider.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<StoreProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoreProvider>(
        builder: (context, store, _) {
          return GridView.builder(
            itemCount: store.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .75),
            itemBuilder: (BuildContext context, int index) {
              store.products.sort((a, b) => a.price.compareTo(b.price));
              final product = store.products[index];
              return InkWell(
                  onTap: () {
                    store.buyProduct(product).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You bought ${product.title}'),
                        ),
                      );
                    });
                  },
                  child: Card(
                    color: getTileColor(store.products[index].id, context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  product.title
                                      .substring(0, product.title.indexOf('(')),
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                          ),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                product.price,
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }

  Color getTileColor(String id, BuildContext context) {
    switch (id) {
      case '50_messages_pack':
        return Theme.of(context).colorScheme.onPrimary;
      case '100_messages_pack':
        return Theme.of(context).colorScheme.onSecondary;
      case '500_messages_pack':
        return Theme.of(context).colorScheme.onTertiary;
      default:
        return Colors.black;
    }
  }
}
