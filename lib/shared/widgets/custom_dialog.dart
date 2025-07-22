import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_pages/core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? yesText;
  final String? noText;
  final VoidCallback? onYesPressed;
  final VoidCallback? onNoPressed;
  final String? icon;
  final Color? iconColor;
  final bool isDismissible;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    this.yesText,
    this.noText,
    this.onYesPressed,
    this.onNoPressed,
    this.icon,
    this.iconColor,
    this.isDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white.withOpacity(0.2), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: (iconColor ?? AppColors.white).withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
                  child: SvgPicture.asset(icon!, color: iconColor ?? AppColors.white, height: 40),
                ),
                const SizedBox(height: 20),
              ],

              Text(
                title,
                style: AppTextStyles.primaryBoldTextStyle.copyWith(fontSize: 20, color: AppColors.white),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                description,
                style: AppTextStyles.primaryTextStyle.copyWith(color: AppColors.white.withOpacity(0.8), fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: onYesPressed ?? () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  fixedSize: Size(MediaQuery.sizeOf(context).width, 50)
                ),
                child: Text(
                  yesText ?? 'Yes',
                  style: AppTextStyles.primaryBoldTextStyle.copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),

              noText != null ? OutlinedButton(
                onPressed: onNoPressed ?? () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.white.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50)
                ),
                child: Text(
                  noText ?? 'No',
                  style: AppTextStyles.primaryTextStyle.copyWith(color: AppColors.white.withOpacity(0.8), fontWeight: FontWeight.w500),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogHelper {
  static Future<bool?> showYesNoDialog({
    required BuildContext context,
    required String title,
    required String description,
    String? yesText,
    String? noText,
    String? icon,
    Color? iconColor,
    bool isDismissible = true,
    VoidCallback? onYesPressed,
    VoidCallback? onNoPressed,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => CustomDialog(
        title: title,
        description: description,
        yesText: yesText,
        noText: noText,
        icon: icon,
        iconColor: iconColor,
        isDismissible: isDismissible,
        onYesPressed: onYesPressed,
        onNoPressed: onNoPressed,
      ),
    );
  }

  static Future<bool?> showLogoutDialog(BuildContext context) {
    return showYesNoDialog(
      context: context,
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      yesText: 'Logout',
      noText: 'Cancel',
      icon: AppAssets.powerIcon,
      iconColor: AppColors.red,
    );
  }

  static Future<bool?> showDeleteDialog(BuildContext context, {String? itemName}) {
    return showYesNoDialog(
      context: context,
      title: 'Delete ${itemName ?? 'Item'}',
      description: 'This action cannot be undone. Are you sure you want to delete this ${itemName?.toLowerCase() ?? 'item'}?',
      yesText: 'Delete',
      noText: 'Cancel',
      icon: AppAssets.powerIcon,
      iconColor: Colors.red,
    );
  }

  static Future<bool?> showExitDialog(BuildContext context) {
    return showYesNoDialog(
      context: context,
      title: 'Exit App',
      description: 'Are you sure you want to exit the application?',
      yesText: 'Exit',
      noText: 'Stay',
      icon: AppAssets.powerIcon,
      iconColor: Colors.orange,
    );
  }
}
