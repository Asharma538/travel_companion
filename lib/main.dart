import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:travel_companion/pages/authentication/email_verification.dart';
import 'package:travel_companion/pages/authentication/login.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/requests.dart';
import 'pages/home.dart';
import 'pages/create_post_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(userEmail);
    Profile.fetchUser(userRef);
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Base(),
      );
    } else {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: VerifyPage(),
      );
    }
  }
}

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  static List<String> profilePictures = [
    "https://t4.ftcdn.net/jpg/00/99/53/31/360_F_99533164_fpE2O6vEjnXgYhonMyYBGtGUFCLqfTWA.jpg",
    "https://png.pngtree.com/png-clipart/20200401/original/pngtree-gold-number-2-png-image_5330866.jpg",
    "https://media.istockphoto.com/id/520661859/photo/golden-number-three-on-white.jpg?s=612x612&w=0&k=20&c=KN_2x0FhwlExacClUwZ5A5JDEW0j71Jt4xEB4L7yy-M=",
    "https://media.istockphoto.com/id/520661263/photo/golden-number-four-on-white.jpg?s=612x612&w=0&k=20&c=RkYTTNQpnVy7d2UK9niOKpAG95kT8AkI27TwF9q4LnI=",
    "https://media.istockphoto.com/id/475237371/vector/3d-shiny-golden-number-5.jpg?s=612x612&w=0&k=20&c=T9ziU71hG6YWwYHbhOafi82EWKg5vYzpKvHCJerHeAU=",
    "https://media.istockphoto.com/id/618634702/photo/gold-number-6.jpg?s=612x612&w=0&k=20&c=OX7rnOS6fY9J27bHKmZ62Djdg5JpIPiMaGbxO8gszXQ=",
    "https://png.pngtree.com/png-clipart/20200401/original/pngtree-gold-number-7-png-image_5330848.jpg",
    "https://media.istockphoto.com/id/520661499/photo/golden-number-eight-on-white.jpg?s=612x612&w=0&k=20&c=sCyAJIx5m2gmVAmJiPwudvh8zOGhhDDjPcxbzyL9lAE="
  ];

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int pageIndex = 0;

  final pages = [
    const Homepage(),
    const Requests(),
    const SearchPage(),
    const Profile(),
  ];

  bool get showFabOnBase => pageIndex == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              margin: const EdgeInsets.fromLTRB(10, 0, 20, 0),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'lib/assets/images/logo.png',
                height: 45.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
              child: const Text(
                'Travel Companion',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
      floatingActionButton: showFabOnBase
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePostPage()),
                );
              },
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 4.5, color: Color(0xFF939898)),
                  borderRadius: BorderRadius.circular(23)),
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
                weight: 50,
              ),
            )
          : null,
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: GNav(
          gap: 8.0,
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey,
          tabs: const [
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
