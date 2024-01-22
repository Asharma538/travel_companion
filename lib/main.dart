import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/requests.dart';
import 'pages/home.dart';
import 'pages/create_post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Companion!',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    const Homepage(),
    const Requests(),
    const Search(),
    const Profile(),
  ];

  bool get showFabOnHomePage => pageIndex == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.contain,
              height: 50.0,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text('  Travel Companion'),
            )
          ],
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
      floatingActionButton: showFabOnHomePage
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      )
          : null,
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: GNav(
          gap: 8.0,
          padding: EdgeInsets.all(16),
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.message,
              text: 'Requests',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
          selectedIndex: pageIndex,
          onTabChange: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
