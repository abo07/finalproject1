import 'package:finalproject1/models/User.dart';
import 'package:finalproject1/utils/DB.dart';
import 'package:flutter/material.dart';
import 'package:finalproject1/main.dart';
import '../utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/APIconfigue.dart';

class signUp extends StatefulWidget {
  const signUp({super.key, required this.title});

  final String title;

  @override
  State<signUp> createState() => _signUp();
}

class _signUp extends State<signUp> {
  final _firstName = TextEditingController();
  final _LastName = TextEditingController();
  final _txtEmail = TextEditingController();
  final _username = TextEditingController();
  final _NewPassword = TextEditingController();
  final _ConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.person_add, size: 64, color: Theme.of(context).primaryColor),
                        SizedBox(height: 16),
                        Text(
                          "Join Now",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Please fill in the information below",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Form fields with improved styling
                  _buildInputField(_firstName, "First Name", Icons.person,
                      validator: (value) => value.isEmpty ? "First name is required" : null),
                  SizedBox(height: 16),

                  _buildInputField(_LastName, "Last Name", Icons.person_outline),
                  SizedBox(height: 16),

                  _buildInputField(_txtEmail, "Email", Icons.email,
                      validator: (value) => value.isEmpty ? "Email is required" : null,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 16),

                  _buildInputField(_username, "Username", Icons.account_circle,
                      validator: (value) => value.isEmpty ? "Username is required" : null),
                  SizedBox(height: 16),

                  _buildInputField(_NewPassword, "Password", Icons.lock,
                      validator: (value) => value.isEmpty ? "Password is required" : null,
                      isPassword: true),
                  SizedBox(height: 16),

                  _buildInputField(_ConfirmPassword, "Confirm Password", Icons.lock_outline,
                      validator: (value) => value != _NewPassword.text ? "Passwords don't match" : null,
                      isPassword: true),
                  SizedBox(height: 32),

                  // Buttons
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed with account creation
                              User user2 = new User();
                              user2.firstName = _firstName.text;
                              user2.lastName = _LastName.text;
                              user2.Email = _txtEmail.text;
                              user2.userName = _username.text;
                              user2.password = _NewPassword.text;

                              insertUser(user2);
                              print("fffffff");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(

                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text('CREATE ACCOUNT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent input fields
  Widget _buildInputField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isPassword = false,
        String? Function(String)? validator,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          obscureText: isPassword  ,
          validator: validator != null ? (value) => validator(value ?? "") : null,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Future insertUser(User user) async {
    var url = "users/insertUser.php?firstName=" + user.firstName +
        "&lastName=" + user.lastName +
        "&Email=" + user.Email +
        "&userName=" + user.userName +
        "&password=" + user.password;
    final response = await http.get(Uri.parse(serverPath + url));
    print("myLink:" + serverPath + url);

     Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));

  }
}

