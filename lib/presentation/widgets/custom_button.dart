import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color color;
  final void Function() onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        height: 52,
        child: Center(child: Text(title)),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontFamily: 'Bolt-SemiBold'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
