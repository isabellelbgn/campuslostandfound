import 'package:flutter/material.dart';

void main() => runApp(const BottomNavigationextends());

class BottomNavigationextends extends StatefulWidget {
  const BottomNavigationextends({super.key});

  @override
  State<BottomNavigationextends> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationextends> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Items',
      style: optionStyle,
    ),
    Text(
      'Index 2: Message',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF002EB0),
        onTap: _onItemTapped,
      ),
    );
  }
}
