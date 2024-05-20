import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key, this.value = 10});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: value,
      width: value,
    );
  }
}
