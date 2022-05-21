import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: Color(0xFFe2e2e2),
      thickness: 1,
    );
  }
}
