import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
          title: Text(
            'Your Plants...',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(95, 113, 97, 1)),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings_suggest_outlined,
                color: Color.fromRGBO(95, 113, 97, 1),
              ),
              tooltip: 'Settings',
              //this is gonna change to a navigation push pop
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color.fromRGBO(95, 113, 97, 1),
              ),
              tooltip: 'Notifications',
              //this is gonna change to a navigation push pop
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
          ]),
          body: 
          Container(
            decoration: BoxDecoration(
              
            ),
            child: Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    
                  );
                } 
              )
            ),
          ),
    ));
  }
}
