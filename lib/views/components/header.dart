import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  const Header({Key? key, required this.title, this.subtitle});

  @override
  PreferredSizeWidget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentTheme.brightness == Brightness.dark
                ? [secondaryDarkTheme500, primaryDarkTheme.withAlpha(140)]
                : [secondaryLightTheme400, secondaryLightTheme.withAlpha(180)],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Text(
                textAlign: TextAlign.start,
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                subtitle ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: textDarkTheme,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
