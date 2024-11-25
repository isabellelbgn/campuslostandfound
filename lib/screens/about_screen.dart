import 'package:campuslostandfound/components/bottom_navbar.dart';
import 'package:campuslostandfound/components/appbar/dashboard_app_bar.dart';
import 'package:campuslostandfound/components/appbar/dashboard_drawer.dart';
import 'package:blobs/blobs.dart' as blobs;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? "No Email";
    String userName = user?.displayName ?? "Guest";

    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(
        blobSize: screenHeight * 0.3,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      endDrawer: DashboardDrawer(
        onSignOut: _signOut,
        userEmail: userEmail,
        userName: userName,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: -200,
              child: blobs.Blob.fromID(
                id: const ['11-3-9367'],
                size: 400,
                styles: blobs.BlobStyles(color: const Color(0xFF002EB0)),
              ),
            ),
            Positioned(
              top: 220,
              right: -150,
              child: blobs.Blob.fromID(
                id: const ['7-4-9367'],
                size: 400,
                styles: blobs.BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      " About Us ",
                      style: const TextStyle(
                          color: Color(0xFF002EB0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'lib/assets/icons/Labuguen.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Isabelle Labuguen",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002EB0)),
                            ),
                            Text(
                              "Computer Science 4A",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              child: Text(
                                "Description..... Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                style: TextStyle(
                                  color: Color(0xFF002EB0),
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                FaIcon(
                                  FontAwesomeIcons.facebookMessenger,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                FaIcon(
                                  FontAwesomeIcons.github,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Isabelle Labuguen",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002EB0)),
                          ),
                          Text(
                            "Computer Science 4A",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Description..... Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                              style: TextStyle(
                                color: Color(0xFF002EB0),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.linkedin,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              FaIcon(
                                FontAwesomeIcons.facebookMessenger,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              FaIcon(
                                FontAwesomeIcons.github,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Image.asset(
                        'lib/assets/icons/Angeles.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        const Text(
                          "The best way to find yourself is to lose yourself in the service of others.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Color(0xFF002EB0), fontSize: 12),
                        ),
                        const Text(
                          "- Mahatma Gandhi",
                          style: TextStyle(
                              color: Color(0xFF002EB0),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: -1,
        onItemTapped: (index) {},
      ),
    );
  }
}
