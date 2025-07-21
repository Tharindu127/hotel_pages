import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_pages/features/home/data/models/hotel_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class DetailedViewScreen extends StatefulWidget {
  final HotelModel hotel;

  const DetailedViewScreen({super.key, required this.hotel});

  @override
  State<DetailedViewScreen> createState() => _DetailedViewScreenState();
}

class _DetailedViewScreenState extends State<DetailedViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.hotel.image.small,
          height: 400,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: MediaQuery.sizeOf(context).width,
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.hotel,
                color: AppColors.black,
                size: 100,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
            );
          },
        ),
        Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.black, Colors.transparent]),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [TextSpan(text: widget.hotel.description, style: AppTextStyles.primaryTextStyle)],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Address: ', style: AppTextStyles.primaryBoldTextStyle),
                        TextSpan(text: widget.hotel.address, style: AppTextStyles.primaryTextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Post code: ', style: AppTextStyles.primaryBoldTextStyle),
                        TextSpan(text: widget.hotel.postcode, style: AppTextStyles.primaryTextStyle),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Phone number: ', style: AppTextStyles.primaryBoldTextStyle),
                        TextSpan(text: widget.hotel.phoneNumber, style: AppTextStyles.primaryTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: '',
            showBackButton: true,
            actionIcon: AppAssets.pointerIcon,
            backgroundColor: Colors.transparent,
            onActionPressed: () {
              AppNavigation.goToMapView(
                context,
                title: widget.hotel.title,
                address: widget.hotel.address,
                latitude: widget.hotel.latitude,
                longitude: widget.hotel.longitude,
              );
              },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(children: [Text(widget.hotel.title, style: AppTextStyles.appBarTextStyle)]),
            ),
          ),
        ),
      ],
    );
  }
}
