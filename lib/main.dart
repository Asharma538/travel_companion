import 'package:flutter/material.dart'; 
import 'package:google_nav_bar/google_nav_bar.dart';

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
            onTabChange: (index){
              setState(() {
                pageIndex = index;
              });
            },
           ),
         )
      ); 
} 
} 

class Homepage extends StatelessWidget { 
const Homepage({Key? key}) : super(key: key); 

@override 
Widget build(BuildContext context) { 
	return Container( 
	color: Color.fromARGB(255, 236, 14, 14), 
	child: Center( 
		child: Text( 
		"Homepage",
    style: TextStyle(
      fontSize: 35.0,
    ),
		), 
		), 
	); 
} 
} 

class Requests extends StatelessWidget { 
const Requests({Key? key}) : super(key: key); 

@override 
Widget build(BuildContext context) { 
	return Container( 
	color: Color.fromARGB(255, 216, 78, 181), 
	child: Center( 
		child: Text(
      "Requests",
      style: TextStyle(
        fontSize: 35.0,
      ),
      ) 
	), 
	); 
} 
} 

class Search extends StatelessWidget { 
const Search({Key? key}) : super(key: key); 

@override 
Widget build(BuildContext context) { 
	return Container( 
	color: Color.fromARGB(255, 238, 126, 21), 
	child: Center( 
		child: Text(
      "Search",
      style: TextStyle(
        fontSize: 35.0,
      ),
    ), 
	), 
	); 
} 
} 

class Profile extends StatelessWidget { 
const Profile({Key? key}) : super(key: key); 

@override 
Widget build(BuildContext context) { 
	return Container( 
	color: Color.fromARGB(255, 10, 117, 160), 
	child: Center( 
		child: Text(
      "Profile",
      style: TextStyle(
        fontSize: 35.0,
      ),
    ), 
	), 
	); 
} 
} 
