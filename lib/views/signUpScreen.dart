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
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Header section
                  Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.blue,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Enter your information to get started",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32),

                  // Form fields
                  // First & Last Name (side by side)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                            _firstName,
                            "First Name",
                            Icons.person,
                            validator: (value) => value.isEmpty ? "Required" : null
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                            _LastName,
                            "Last Name",
                            Icons.person_outline
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Email
                  _buildInputField(
                      _txtEmail,
                      "Email",
                      Icons.email,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email is required";
                        } else if (!value.contains('@') || !value.contains('.')) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress
                  ),

                  SizedBox(height: 16),

                  // Username
                  _buildInputField(
                      _username,
                      "Username",
                      Icons.account_circle,
                      validator: (value) => value.isEmpty ? "Username is required" : null
                  ),

                  SizedBox(height: 16),

                  // Password
                  _buildPasswordField(
                      _NewPassword,
                      "Password",
                      Icons.lock,
                      isVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password is required";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      }
                  ),

                  SizedBox(height: 16),

                  // Confirm Password
                  _buildPasswordField(
                      _ConfirmPassword,
                      "Confirm Password",
                      Icons.lock_outline,
                      isVisible: _isConfirmPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                      validator: (value) => value != _NewPassword.text ? "Passwords don't match" : null
                  ),

                  SizedBox(height: 32),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Create user object
                          User user = new User();
                          user.firstName = _firstName.text;
                          user.lastName = _LastName.text;
                          user.Email = _txtEmail.text;
                          user.userName = _username.text;
                          user.password = _NewPassword.text;

                          // Send to server
                          insertUser(user);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
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
        String? Function(String)? validator,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
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
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      validator: validator != null ? (value) => validator(value ?? "") : null,
      keyboardType: keyboardType,
    );
  }

  // Helper method for password fields with visibility toggle
  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      IconData icon, {
        required bool isVisible,
        required Function onToggleVisibility,
        String? Function(String)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => onToggleVisibility(),
        ),
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
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      validator: validator != null ? (value) => validator(value ?? "") : null,
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

    // Set loading to false when complete
    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Account created successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login page
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}