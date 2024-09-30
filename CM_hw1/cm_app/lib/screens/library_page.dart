import 'package:flutter/material.dart';
import '../components/icon_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../const.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 68, 126, 212), Colors.transparent],
            stops: [0.0, 0.30],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 36, bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and toolbar buttons
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://www.nicepng.com/png/full/182-1829287_cammy-lin-ux-designer-circle-picture-profile-girl.png',
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Your Library",
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Raleway",
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(child: SizedBox()),
                    IconButtonWidget(
                      icon: Icons.notifications,
                    ),
                    IconButtonWidget(
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
              // Playlists in a scrollable list with Slidable functionality
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
                  itemCount: yourPlaylists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Slidable(
                        // Key to handle the list items
                        key: ValueKey(yourPlaylists[index].title),
                        
                        // The actions that will appear when sliding
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(), // Drawer slide motion
                          children: [
                            // Edit action
                            SlidableAction(
                              onPressed: (context) {
                                // Handle edit action here
                                print("Edit ${yourPlaylists[index].title}");
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            // Delete action
                            SlidableAction(
                              onPressed: (context) {
                                // Handle delete action here
                                print("Delete ${yourPlaylists[index].title}");
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff2E2F33),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // Playlist Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(yourPlaylists[index].img),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Playlist Title and Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      yourPlaylists[index].title,
                                      style: const TextStyle(
                                        fontFamily: 'Raleway',
                                        color: Color(0xffffffff),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
