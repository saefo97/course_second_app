import 'package:course_second_app/xylophone.dart';
import 'package:flutter/material.dart';

class Mainnavbar extends StatefulWidget {
  const Mainnavbar({super.key});

  @override
  State<Mainnavbar> createState() => _MainnavbarState();
}

class _MainnavbarState extends State<Mainnavbar> {
  int selectedIndex = 0;
  List<Widget> screens = [
    Center(child: Text("Main Screen",style: TextStyle(fontSize: 22),),),
    Center(child: Text("Notifications",style: TextStyle(fontSize: 22),),),
    Xylophone(),
    Center(child: Text("Profile",style: TextStyle(fontSize: 22),),),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 75,
        elevation: 3,
        backgroundColor: Colors.white,
        shadowColor: Colors.black45,
        animationDuration: Duration(seconds: 2),
        labelBehavior: .onlyShowSelected,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        indicatorColor: Colors.deepPurple.shade100,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home",
          tooltip: "Home Page",
          selectedIcon: Icon(Icons.home),
          ),    NavigationDestination(icon: Icon(Icons.notifications_none_outlined), label: "Notifications",
          selectedIcon: Icon(Icons.notifications),
          ),    NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home",
          selectedIcon: Icon(Icons.home),
          ),    NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home",
          selectedIcon: Icon(Icons.home),
          ),
        ],

      ),
      
    );
  }
}