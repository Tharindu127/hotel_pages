import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/hotel_model.dart';

class HotelListView extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback? onTap;

  const HotelListView({
    super.key,
    required this.hotel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel Image
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  hotel.image.small,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.hotel,
                        color: AppColors.white,
                        size: 32,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
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
              ),

              const SizedBox(width: 16),

              // Hotel Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Title
                    Text(
                      hotel.title,
                      style: AppTextStyles.primaryBoldTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      hotel.description,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // const SizedBox(height: 8),
                    //
                    // // Address
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.location_on,
                    //       size: 16,
                    //       color: AppColors.white.withOpacity(0.6),
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Expanded(
                    //       child: Text(
                    //         hotel.address.replaceAll('\n', ', '),
                    //         style: AppTextStyles.secondaryTextStyle(
                    //           AppColors.white.withOpacity(0.6),
                    //         ).copyWith(fontSize: 12),
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 4),
                    //
                    // // Phone Number
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.phone,
                    //       size: 16,
                    //       color: AppColors.white.withOpacity(0.6),
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       hotel.phoneNumber,
                    //       style: AppTextStyles.secondaryTextStyle(
                    //         AppColors.white.withOpacity(0.6),
                    //       ).copyWith(fontSize: 12),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.white.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}