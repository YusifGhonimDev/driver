import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Color color;

  const TaxiOutlineButton(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontFamily: 'Bolt-SemiBold', color: colorText),
          ),
        ),
      ),
    );
  }
}
