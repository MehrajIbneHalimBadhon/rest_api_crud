import 'package:api_crud/views/rest_api/rest_api_crud.dart';
import 'package:flutter/material.dart';

import 'model./model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  ProductScreen(),
    );
  }
}


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService _apiService = ApiService();
  List<Api>? _products;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    _products = await _apiService.getProducts();
    setState(() {
      _isLoading = false;
    });
  }

  void _showProductDialog({Api? product}) {
    showDialog(
      context: context,
      builder: (context) {
        return ProductDialog(
          product: product,
          onSubmit: (Api newProduct) async {
            if (product == null) {
              await _apiService.createProduct(newProduct);
            } else {
              await _apiService.updateProduct(product.id, newProduct);
            }
            _fetchProducts();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product CRUD'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products?.length ?? 0,
        itemBuilder: (context, index) {
          final product = _products![index];
          return ListTile(
            title: Text(product.productName),
            subtitle: Text(product.productCode),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showProductDialog(product: product),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _apiService.deleteProduct(product.id);
                    _fetchProducts();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  final Api? product;
  final Function(Api) onSubmit;

  ProductDialog({this.product, required this.onSubmit});

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _productCodeController;
  late TextEditingController _imgController;
  late TextEditingController _unitPriceController;
  late TextEditingController _qtyController;
  late TextEditingController _totalPriceController;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.product?.productName ?? '');
    _productCodeController = TextEditingController(text: widget.product?.productCode ?? '');
    _imgController = TextEditingController(text: widget.product?.img ?? '');
    _unitPriceController = TextEditingController(text: widget.product?.unitPrice ?? '');
    _qtyController = TextEditingController(text: widget.product?.qty ?? '');
    _totalPriceController = TextEditingController(text: widget.product?.totalPrice ?? '');
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _imgController.dispose();
    _unitPriceController.dispose();
    _qtyController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productCodeController,
                decoration: InputDecoration(labelText: 'Product Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imgController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
              ),
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                controller: _totalPriceController,
                decoration: InputDecoration(labelText: 'Total Price'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final product = Api(
                id: widget.product?.id ?? '',
                productName: _productNameController.text,
                productCode: _productCodeController.text,
                img: _imgController.text,
                unitPrice: _unitPriceController.text,
                qty: _qtyController.text,
                totalPrice: _totalPriceController.text,
                createdDate: widget.product?.createdDate ?? DateTime.now(),
              );
              widget.onSubmit(product);
              Navigator.of(context).pop();
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}


