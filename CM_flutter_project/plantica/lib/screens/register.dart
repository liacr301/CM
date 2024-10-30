import 'package:flutter/material.dart';
import 'package:plantica/database.dart';
import 'login.dart'; 

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String birthdate = _birthdateController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty || name.isEmpty || birthdate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please, fill all the fields!')),
      );
      return;
    }

    await AppDatabase().registerUser(name ,username, birthdate, password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sucess! Login now.')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Welcome to Plantica',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(95, 113, 97, 1),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Let’s start taking care of your plants!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8CFC4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      child: Icon(
                        Icons.emoji_nature_outlined,
                        size: 64,
                        color: Color.fromRGBO(95, 113, 97, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController, 
                      decoration: InputDecoration(
                        hintText: 'Name',
                        filled: true,
                        fillColor: const Color(0xFFEFE7D6),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController, 
                      decoration: InputDecoration(
                        hintText: 'Username',
                        filled: true,
                        fillColor: const Color(0xFFEFE7D6),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _birthdateController, 
                      decoration: InputDecoration(
                        hintText: 'Birthdate',
                        filled: true,
                        fillColor: const Color(0xFFEFE7D6),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController, 
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: const Color(0xFFEFE7D6),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(95, 113, 97, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _register(context), 
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            'Sign in here',
                            style: TextStyle(
                              color: Color.fromRGBO(95, 113, 97, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}