import 'package:company_empo/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false; // สถานะการโหลด

  Future<User?> signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true; // แสดงตัวโหลด
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled by the user.');
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      if (googleAuth == null) {
        throw Exception('Google authentication failed.');
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    } finally {
      setState(() {
        _isLoading = false; // ปิดตัวโหลด
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Google'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'แอพสำหรับบริษัทหรือร้านค้า',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 20),
              if (_isLoading) // เงื่อนไขการแสดงตัวโหลด
                CircularProgressIndicator(),
              if (!_isLoading) // ปุ่มจะแสดงเมื่อไม่ได้โหลด
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    try {
                      User? user = await signInWithGoogle();
                      if (user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeUI(user: user),
                        ));
                      } else {
                        throw Exception('Failed to sign in with Google.');
                      }
                    } catch (e) {
                      final snackBar =
                          SnackBar(content: Text('Login failed: $e'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
