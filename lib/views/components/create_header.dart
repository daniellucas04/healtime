import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Header({
    Key? key,
    required this.title,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
