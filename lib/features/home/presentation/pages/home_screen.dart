import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_pages/core/constants/app_assets.dart';
import 'package:hotel_pages/core/router/app_router.dart';
import 'package:hotel_pages/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../providers/hotel_provider.dart';
import '../widgets/hotel_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().fetchHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: CustomAppBar(
          title: 'Hotel Pages',
          showBackButton: false,
          actionIcon: AppAssets.powerIcon,
          onActionPressed: () async {
            final result = await DialogHelper.showLogoutDialog(context);

            if (result == true) {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            }
          },
        ),
        body: Consumer<HotelProvider>(
          builder: (context, hotelProvider, child) {
            if (hotelProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              );
            }

            if (hotelProvider.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.white.withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load hotels',
                        style: AppTextStyles.primaryBoldTextStyle.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hotelProvider.error!,
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          color: AppColors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          hotelProvider.clearError();
                          hotelProvider.fetchHotels();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.black,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (hotelProvider.hotels.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: 64,
                        color: AppColors.white.withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hotels found',
                        style: AppTextStyles.primaryBoldTextStyle.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for available hotels.',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          color: AppColors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await hotelProvider.fetchHotels();
              },
              color: AppColors.white,
              backgroundColor: AppColors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Hotels',
                      style: AppTextStyles.primaryBoldTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${hotelProvider.hotels.length} hotels found',
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView.builder(
                        itemCount: hotelProvider.hotels.length,
                        itemBuilder: (context, index) {
                          final hotel = hotelProvider.hotels[index];
                          return HotelListView(
                            hotel: hotel,
                            onTap: () {
                              _showHotelDetails(context, hotel);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showHotelDetails(BuildContext context, hotel) {
    AppNavigation.goToDetailedView(context, hotel);
  }
}