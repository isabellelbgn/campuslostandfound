import 'package:campuslostandfound/components/bottom_navbar.dart';
import 'package:campuslostandfound/components/appbar/dashboard_app_bar.dart';
import 'package:campuslostandfound/components/appbar/dashboard_drawer.dart';
import 'package:blobs/blobs.dart' as blobs;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
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
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        " About Us ",
                        style: TextStyle(
                            color: Color(0xFF002EB0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Row 1
                          MediaQuery.of(context).size.width >= 700
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'lib/assets/icons/Labuguen.png',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Isabelle Labuguen",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF002EB0)),
                                            ),
                                            const Text(
                                              "Computer Science 4A",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "A backend developer who loves building efficient systems, solving problems, and enjoying good coffee.",
                                              style: TextStyle(
                                                color: Color(0xFF002EB0),
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://www.linkedin.com/in/isabellelabuguen/');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.linkedin,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://www.facebook.com/BelleLabuguen');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons
                                                        .facebookMessenger,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://github.com/isabellelbgn');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.github,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'lib/assets/icons/Labuguen.png',
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Isabelle Labuguen",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF002EB0)),
                                          ),
                                          const Text(
                                            "Computer Science 4A",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "A backend developer who loves building efficient systems, solving problems, and enjoying good coffee.",
                                            style: TextStyle(
                                              color: Color(0xFF002EB0),
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://www.linkedin.com/in/isabellelabuguen/');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons.linkedin,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://www.facebook.com/BelleLabuguen');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons
                                                      .facebookMessenger,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://github.com/isabellelbgn');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons.github,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 40),

                          // Row 2
                          MediaQuery.of(context).size.width >= 700
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Martina Angeles",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF002EB0)),
                                            ),
                                            const Text(
                                              "Computer Science 4A",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "A passionate frontend and UI/UX designer who loves blending creativity with technology and relaxing with great movies.",
                                              style: TextStyle(
                                                color: Color(0xFF002EB0),
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.start,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://www.linkedin.com/in/martina-aaron-angeles/');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.linkedin,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://www.facebook.com/martinaangeless/');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons
                                                        .facebookMessenger,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    _launchURL(
                                                        'https://github.com/martinaangeles');
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.github,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Image.asset(
                                        'lib/assets/icons/Angeles.png',
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Martina Angeles",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF002EB0)),
                                          ),
                                          const Text(
                                            "Computer Science 4A",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "A passionate frontend and UI/UX designer who loves blending creativity with technology and relaxing with great movies.",
                                            style: TextStyle(
                                              color: Color(0xFF002EB0),
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://www.linkedin.com/in/martina-aaron-angeles/');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons.linkedin,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://www.facebook.com/martinaangeless/');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons
                                                      .facebookMessenger,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  _launchURL(
                                                      'https://github.com/martinaangeles');
                                                },
                                                child: const FaIcon(
                                                  FontAwesomeIcons.github,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Image.asset(
                                      'lib/assets/icons/Angeles.png',
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 150),

                          // Quote Section
                          const Column(
                            children: [
                              Text(
                                "The best way to find yourself is to lose yourself in the service of others.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF002EB0), fontSize: 12),
                              ),
                              Text(
                                "- Mahatma Gandhi",
                                style: TextStyle(
                                    color: Color(0xFF002EB0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
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
