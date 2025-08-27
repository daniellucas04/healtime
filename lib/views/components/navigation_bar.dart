import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          if (index != _selectedIndex) Navigator.pushReplacementNamed(context, '/');
          break;
        case 1:
          // Navigator.pushNamed(context, '/calendar');
          break;
        case 2:
          // Navigator.pushNamed(context, '/people');
          break;
        case 3:
          // Navigator.pushNamed(context, '/menu');
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pessoas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
