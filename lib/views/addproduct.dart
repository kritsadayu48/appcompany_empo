import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  File? _imageFile;

  // Define API URLs as class variables
  final String uploadImageUrl =
      'https://s6319410013.sautechnology.com/myworkapi/upload_image.php';
  final String insertProductUrl =
      'https://s6319410013.sautechnology.com/myworkapi/insert.php';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<String> _saveImageToServer() async {
    List<int> imageBytes = await _imageFile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    Map<String, dynamic> jsonData = {'image': base64Image};

    final response = await http.post(
      Uri.parse(uploadImageUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      if (decodedResponse['imageUrl'] != null) {
        return decodedResponse['imageUrl'];
      } else {
        throw Exception('Image URL not found in the response');
      }
    } else {
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
                Navigator.of(context)
                    .pop(); // Navigates back to the previous page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Add a loading indicator state
  bool _isLoading = false;

  Future<void> _saveProductToDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final imageUrl = await _saveImageToServer();
      final response = await http.post(
        Uri.parse(insertProductUrl),
        body: {
          'productname': nameController.text,
          'description': descriptionController.text,
          'price': priceController.text,
          'amount': amountController.text,
          'image': imageUrl,
        },
      );

      if (response.statusCode == 200) {
        _showWarningDialog(
            'Product added successfully. Returning to stock management.');
      } else {
        _showSnackbar('Failed to add product');
      }
    } catch (error) {
      _showSnackbar('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Icon(Icons.add_photo_alternate, size: 60),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'รายละเอียด'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'ราคา'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'จำนวน'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_imageFile == null ||
                            nameController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            priceController.text.isEmpty) {
                          _showSnackbar(
                              'Please fill in all fields and select an image');
                          return;
                        }
                        _saveProductToDatabase();
                      },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
