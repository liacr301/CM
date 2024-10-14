import 'package:flutter/material.dart';
import 'package:plantica/const.dart';

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
      body: Container(
        decoration: BoxDecoration(),
        child: Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: myPlants.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(100),
                                bottomLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(myPlants[index].img),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Informações da planta
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  myPlants[index].name,
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Color.fromARGB(255, 24, 48, 3),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  myPlants[index].scientificName,
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Color.fromARGB(255, 24, 48, 3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      // Adiciona espaçamento interno no conteúdo
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      decoration: BoxDecoration(
                                        color:
                                            myPlants[index].state == 'Healthy'
                                                ? Colors.green[100]
                                                : myPlants[index].state ==
                                                        'Needs water'
                                                    ? Colors.red[300]
                                                    : Colors.blue[200],
                                        borderRadius: BorderRadius.circular(
                                            20), 
                                      ),
                                      child: Text(
                                        myPlants[index].state,
                                        style: const TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors
                                              .black, // Definir a cor do texto conforme necessário
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Espaço entre os itens
                      const SizedBox(height: 16),
                    ],
                  );
                })),
      ),
    ));
  }
}
