import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../core/constants/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? actionIcon;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actionIcon,
    this.onActionPressed,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.black,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
        icon: SvgPicture.asset(AppAssets.backIcon, color: AppColors.white, height: 25,),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      )
          : null,
      title: title != null
          ? Text(
        title!,
        style: AppTextStyles.appBarTextStyle,
      )
          : null,
      actions: actionIcon != null
          ? [
        IconButton(
          icon: SvgPicture.asset(actionIcon!, color: AppColors.white, height: 30,),
          onPressed: onActionPressed,
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}