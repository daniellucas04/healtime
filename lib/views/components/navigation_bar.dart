import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          if (index != _selectedIndex) {
            Navigator.pushReplacementNamed(context, '/homepage');
          }
          break;
        case 1:
          if (index != _selectedIndex) {
            Navigator.pushReplacementNamed(context, '/report');
          }
          break;
        case 2:
          if (index != _selectedIndex) {
            Navigator.pushReplacementNamed(context, '/people');
          }
          break;
        case 3:
          if (index != _selectedIndex) {
            Navigator.pushReplacementNamed(context, '/menu');
          }
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.paste),
            label: 'Relátorio',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Pessoas',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
