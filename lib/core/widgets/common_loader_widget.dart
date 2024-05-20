import 'package:maidcc/core/color/app_colors.dart';
import 'package:flutter/material.dart';

class CommonLoaderWidget extends StatelessWidget {
  const CommonLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }
}
