import 'dart:convert';

import 'package:company_empo/models/product.dart';
import 'package:company_empo/views/addproduct.dart';
import 'package:company_empo/views/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockManagementUI extends StatefulWidget {
  @override
  _StockManagementUIState createState() => _StockManagementUIState();
}

class _StockManagementUIState extends State<StockManagementUI> {
  List<Product> products = [];
  String? selectedCategory; // Initialized as null and will be set after fetching

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://s6319410013.sautechnology.com/myworkapi/selectstock.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
        if (products.isNotEmpty) {
          selectedCategory = 'All'; // Default to 'All' after fetching products
        }
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Widget build(BuildContext context) {
    List<String> categories = ['All'] + products.map((p) => p.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
        actions: [
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
              }
            },
            items: categories.map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: selectedCategory == 'All' ? products.length : products.where((p) => p.category == selectedCategory).length,
          itemBuilder: (context, index) {
            var filteredProducts = selectedCategory == 'All' ? products : products.where((p) => p.category == selectedCategory).toList();
            return ProductItem(product: filteredProducts[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          ).then((_) => fetchProducts());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Text('ราคา: ${product.price} บาท', style: TextStyle(fontSize: 14)),
                  if (product.amount != null) Text('จำนวนคงเหลือ: ${product.amount}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
