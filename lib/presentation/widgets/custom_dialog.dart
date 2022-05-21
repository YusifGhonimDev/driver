import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomDialog extends StatelessWidget {
  final String status;

  const CustomDialog({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            const CircularProgressIndicator(
              color: colorAccentPurple,
            ),
            const SizedBox(width: 24),
            Text(
              status,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
