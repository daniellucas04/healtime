import 'package:app/views/components/navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Listagem'),
      ),
      body: const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[],
      )),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35),
        onPressed: () =>
            {Navigator.pushNamed(context, '/medicine_registration')},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
