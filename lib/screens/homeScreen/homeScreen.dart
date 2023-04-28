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
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [
      const HomePage(),
      const SettingsPage(),
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black),
        currentIndex: _selectedPageIndex,
        onTap: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;
            _pageController.jumpToPage(selectedPageIndex);
          });
        },
        items: const [
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
    );
  }
}
