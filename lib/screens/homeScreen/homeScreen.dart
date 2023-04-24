import 'package:bookkarooowner/screens/homeScreen/SettingsPage.dart';
import 'package:bookkarooowner/screens/homeScreen/homePage.dart';
import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController searchController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> Screens = [
    const HomePage(),
    const SettingsPage(),
  ];
  int _currentIndex = 0;
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(
          color: Colors.black,
          // fontSize: ,
        ),
        selectedIconTheme: const IconThemeData(color: Colors.black),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.home,
          //   ),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark_added_sharp,
            ),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),

      body: Screens[_currentIndex],
    );
  }
}