import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateHeader extends StatelessWidget {
  final Icon icon;
  final String title;

  const CreateHeader({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 28, right: 28),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        color: Theme.of(context).brightness == Brightness.dark ? secondaryDarkTheme : secondaryLightTheme
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 54)),
              icon,
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: 300,
                child: Text(
                  title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark ? textDarkTheme : textLightTheme
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
