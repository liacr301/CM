import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(

        ),

        child:  
          BigCard()

      ),
    );
  }
}


//do the card where the login will be
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text('LOGIN');
  }
}