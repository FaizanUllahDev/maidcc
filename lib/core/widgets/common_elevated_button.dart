import 'package:maidcc/core/color/app_colors.dart';
import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  const CommonElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.tooltip = '',
  });

  final String title;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: onPressed == null
            ? ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey.withOpacity(.2),
                disabledBackgroundColor: AppColors.grey.withOpacity(.2),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: onPressed == null ? AppColors.grey : AppColors.white,
          ),
        ),
      ),
    );
  }
}
