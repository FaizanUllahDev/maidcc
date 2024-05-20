import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/router/routes.dart';
import 'package:maidcc/core/utils/date_service.dart';
import 'package:maidcc/core/utils/top_up_service.dart';
import 'package:maidcc/core/widgets/common_loader_widget.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static UserEntity currentUser = UserEntity();

  static const int topUpCharges = 1;

  static bool isUserLogin = true;

// debug print data
  static void debug(dynamic message, [StackTrace? stackTrace]) {
    debugPrint(message);
// log(message.toString());
  }

  static void toast(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  static bool isDialogShowing = false;

  static void showLoaderDialog() {
    if (isDialogShowing) return;
    showDialog<void>(
      context: AppRouter.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const CommonLoaderWidget();
      },
    );
  }

  static void hideDialog() {
    if (!isDialogShowing) return;
    Navigator.of(AppRouter.context, rootNavigator: true).pop();
  }

  static void resetUserDateTimeLoggedData() {
// Initial configuration for the application for user
    final preferences = sl<SharedPreferences>();
    if (!DateTimeService.isUserDateWithInTheMonth()) {
// reset the user's date' && limit

      sl<SharedPreferences>().setString(
        AppKeyConstants.userDateTime,
        DateTime.now().toIso8601String(),
      );
      TopUpService.maxBasedLimitAmount = 3000;
    }

    if (preferences.getBool(AppKeyConstants.dateTimeLogged) == false) {
      sl<SharedPreferences>().setString(
        AppKeyConstants.userDateTime,
        DateTime.now().toIso8601String(),
      );
      sl<SharedPreferences>().setBool(AppKeyConstants.dateTimeLogged, true);
    }
  }

  static DateTime getUserLoggedInDate() {
    final preferences = sl<SharedPreferences>();
    return DateTime.parse(
      preferences.getString(AppKeyConstants.userDateTime) ??
          DateTime.now().toIso8601String(),
    );
  }

  static void logout() {
    sl<PreferencesUtil>().clearPreferencesData();
  }

  static bool needRefreshToken() {
    String loggedTime = sl<PreferencesUtil>().getPreferencesData(
      AppKeyConstants.dateTimeLogged,
    );
    if (loggedTime.isEmpty) {
      loggedTime = DateTime.now().toIso8601String();
    }
    final now = DateTime.now().toIso8601String();
    final diff = DateTime.parse(now).difference(DateTime.parse(loggedTime));
    // check 1 hour difference
    if (diff.inHours > 1) {
      return true;
    }
    return false;
  }
}
