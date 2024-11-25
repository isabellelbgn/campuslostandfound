import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/items');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/messages');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        _navigate(context, index);
        onItemTapped(index);
      },
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF002EB0),
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          label: 'Message',
        ),
      ],
    );
  }
}
