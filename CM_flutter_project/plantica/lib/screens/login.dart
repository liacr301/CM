import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantica/bloc/auth/auth_bloc.dart';
import 'package:plantica/bloc/auth/auth_event.dart';
import 'package:plantica/bloc/auth/auth_state.dart';
import 'package:plantica/main_page.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isNavigated = false; // Flag to prevent duplicate navigation

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess && !isNavigated) {
          isNavigated = true; // Set flag to prevent duplicate navigation
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                  'Its time to start taking care of your plants!',
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
                      const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40,
                        child: Icon(
                          Icons.emoji_nature_outlined,
                          size: 64,
                          color: Color.fromRGBO(95, 113, 97, 1),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _usernameController,
                        hintText: 'Username',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(95, 113, 97, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (_usernameController.text.trim().isEmpty ||
                                          _passwordController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Please fill all fields!')),
                                        );
                                        return;
                                      }
                                      FocusScope.of(context).unfocus(); // Dismiss keyboard
                                      context.read<AuthBloc>().add(
                                            LoginRequested(
                                              username: _usernameController.text.trim(),
                                              password: _passwordController.text.trim(),
                                            ),
                                          );
                                    },
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: const Text(
                              'Sign up here',
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFEFE7D6),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
