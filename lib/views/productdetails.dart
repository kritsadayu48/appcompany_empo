import 'package:company_empo/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300, // กำหนดความสูงคงที่
              width: double.infinity, // กำหนดความกว้างครอบคลุมทั้งหน้าจอ
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover, // ให้รูปภาพครอบคลุมพื้นที่แสดงโดยไม่เสียสัดส่วน
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Divider(),
                    SizedBox(height: 10),
                    Text('รายละเอียด:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(product.description),
                    SizedBox(height: 10),
                    Text('ราคา:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${product.price} บาท', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    if (product.amount != null) Text('จำนวนคงเหลือ:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (product.amount != null) Text('${product.amount}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
