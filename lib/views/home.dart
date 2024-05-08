import 'package:company_empo/login.dart';
import 'package:company_empo/views/attendance.dart';
import 'package:company_empo/views/stock_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  final User user;
  HomeUI({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('ควบคุมการทำงาน'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            FeatureCard(
              icon: Icons.check_circle_outline,
              text: 'เช็คการทำงาน',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceUI())),
            ),
            FeatureCard(
              icon: Icons.storage,
              text: 'จัดการสต็อกสินค้า',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StockManagementUI())),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
