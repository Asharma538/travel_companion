import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/requests.dart';
import 'pages/home.dart';
import 'pages/create_post_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/splash_screen.dart';

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

    FirebaseAuth.instance.currentUser?.getIdToken(true);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  static List<String> profilePictures = [
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_1.jpeg?alt=media&token=0c5d47c7-32f1-4136-bc00-8a1c8d51ca6c",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_2.jpeg?alt=media&token=9b553349-3ab7-4ae2-aea1-d7b42cd893a9",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_3.jpeg?alt=media&token=3a8bfe3d-c128-4c76-b123-4c025050e76e",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_4.jpeg?alt=media&token=cf3feabb-ffd0-4bb9-9d3c-ed17d44c20e3",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_5.jpeg?alt=media&token=97ab219c-57de-4fad-a5b9-6f2af176504d",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_6.jpeg?alt=media&token=f1a3f28a-2e94-4644-8c89-65898078f733",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_7.jpeg?alt=media&token=39164e9c-966d-494c-b988-2a61a388d888",
    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/photo_8.jpeg?alt=media&token=7fe56bd8-cc55-4a02-b87b-84f0a34852be"
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
      resizeToAvoidBottomInset: false,
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
