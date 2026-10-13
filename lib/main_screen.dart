import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController pageController;
  int currentPage=0;

  @override
  void initState() {
    pageController= PageController(
      initialPage: 0,
     // viewportFraction: 0.8
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      //  scrollDirection: Axis.vertical,

        children: [
          GestureDetector(
            onTap: (){
              pageController.nextPage(duration: Duration(seconds: 1), curve:

              Curves.easeInOut
              );
            },
            child: Container(
              color: Colors.red,
              child: Center(child: Text("Page1")),
            ),
          ),
          Container(
            color: Colors.green,
            child: Center(child: Text("Page2")),
          ),
         ListView(
           children: [
             for(int i =0 ; i<1000; i++)
               Text("data")
           ],
         )
        ],
      ),
    );
  }
}
