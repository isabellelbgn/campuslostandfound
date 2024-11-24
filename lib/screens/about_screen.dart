import 'package:campuslostandfound/components/bottom_navbar.dart';
import 'package:campuslostandfound/components/dashboard_app_bar.dart';
import 'package:campuslostandfound/components/dashboard_drawer.dart';
import 'package:blobs/blobs.dart' as blobs;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  " About Us ",
                  style: const TextStyle(
                      color: Color(0xFF002EB0), fontWeight: FontWeight.bold),
                ),
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
