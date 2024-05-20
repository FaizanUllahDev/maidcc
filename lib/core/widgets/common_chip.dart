import 'package:flutter/material.dart';
import 'package:maidcc/core/color/app_colors.dart';

class CommonChip extends StatelessWidget {
  final bool active;
  final String text;
  final Color? bgClr;
  final Color? txtClr;
  final int? width;
  final EdgeInsets? padding;

  const CommonChip({
    super.key,
    required this.active,
    required this.text,
    this.bgClr,
    this.txtClr,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: bgClr ?? (active ? AppColors.green : AppColors.grey),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: txtClr ?? (active ? AppColors.green : AppColors.grey),
          ),
        ),
      ),
    );
  }
}
