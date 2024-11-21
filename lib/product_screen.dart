import 'package:flutter/material.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'models/ModelProvider.dart';
import 'models/Product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];
  APIAuthorizationType authMode = APIAuthorizationType.iam;

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
      final session = await Amplify.Auth.fetchAuthSession();
      setState(() {
        authMode = session.isSignedIn? APIAuthorizationType.userPools : APIAuthorizationType.iam;
      });
      
      _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final request =
          ModelQueries.list(Product.classType, authorizationMode: authMode);
      final response = await Amplify.API.query(request: request).response;

      final Products = response.data?.items;
      if (response.hasErrors) {
        safePrint('errors: ${response.errors}');
        return;
      }
      setState(() {
        _products = Products!.whereType<Product>().toList();
      });
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }
  }

  void addRandomProduct() async {
          final newProduct = Product(id: uuid(), name: "Random Product ${DateTime.now().toIso8601String()}");
          final request = ModelMutations.create(newProduct, authorizationMode: authMode);
          final response = await Amplify.API.mutate(request: request).response;

          if (response.hasErrors) {
            safePrint('Creating Product failed.');
          } else {
            safePrint('Creating Product successful.');
            _fetchProducts();
          }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products (guest + authenticated)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Random Product'),
        onPressed: () async {
          addRandomProduct();
        },
      ),
      body: _products.isEmpty == true
          ? const Center(
              child: Text(
                "The list is empty.\nAdd some items by clicking the floating action button.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final Product = _products[index];
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  child: CheckboxListTile.adaptive(
                    title: Text(Product.name!),
                    onChanged: (isChecked) async {},
                    value: false,
                  ),
                );
              },
            ),
    );
  }
}
