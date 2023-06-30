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
                crossAxisCount: 2, childAspectRatio: 0.9),
            itemBuilder: (BuildContext context, int index) {
              store.products.sort((a, b) => a.price.compareTo(b.price));
              final product = store.products[index];
              return InkWell(
                  onTap: () async {
                    await store.buyProduct(product, context);
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
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  product.title
                                      .substring(0, product.title.indexOf('(')),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: getTextColor(
                                              store.products[index].id,
                                              context)),
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                product.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: getTextColor(
                                            store.products[index].id, context)),
                              )),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                product.price,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: getTextColor(
                                            store.products[index].id, context)),
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
        return Theme.of(context).colorScheme.primaryContainer;
      case '100_messages_pack':
        return Theme.of(context).colorScheme.secondaryContainer;
      case '500_messages_pack':
        return Theme.of(context).colorScheme.tertiaryContainer;
      default:
        return Colors.black;
    }
  }

  Color getTextColor(String id, BuildContext context) {
    switch (id) {
      case '50_messages_pack':
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case '100_messages_pack':
        return Theme.of(context).colorScheme.onSecondaryContainer;
      case '500_messages_pack':
        return Theme.of(context).colorScheme.onTertiaryContainer;
      default:
        return Colors.black;
    }
  }
}
