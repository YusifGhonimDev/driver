import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String title;
  final Color color;
  final void Function() onPressed;

  const AvailabilityButton({
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
        width: 200,
        child: Center(child: Text(title)),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: 'Bolt-SemiBold'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
