import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_pages/shared/widgets/custom_dialog.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class MapViewScreen extends StatefulWidget {
  final String longitude;
  final String latitude;
  final String title;
  final String address;

  const MapViewScreen({
    super.key,
    required this.longitude,
    required this.latitude,
    required this.title,
    required this.address,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late MapController controller;

  @override
  void initState() {
    super.initState();

    controller = MapController(
      initPosition: GeoPoint(
        latitude: double.parse(widget.latitude),
        longitude: double.parse(widget.longitude),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _addMarker() async {
    final point = GeoPoint(
      latitude: double.parse(widget.latitude),
      longitude: double.parse(widget.longitude),
    );

    await controller.addMarker(
      point,
      markerIcon: MarkerIcon(
        iconWidget: SvgPicture.asset(
          AppAssets.pointerIcon,
          color: AppColors.red,
          height: 30,
        ),
      ),
    );

    await controller.changeLocation(point);
    await controller.setZoom(zoomLevel: 10);
  }

  void _showMarkerDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        icon: AppAssets.pointerIcon,
        title: widget.title,
        description: widget.address,
        yesText: 'Ok',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        showBackButton: true,
      ),
      body: OSMFlutter(
        controller: controller,
        onGeoPointClicked: (geoPoint) {
          final markerLat = double.parse(widget.latitude);
          final markerLng = double.parse(widget.longitude);

          final distance = (geoPoint.latitude - markerLat).abs() +
              (geoPoint.longitude - markerLng).abs();

          if (distance < 0.001) {
            _showMarkerDialog();
          }
        },
        osmOption: OSMOption(
          zoomOption: const ZoomOption(
            initZoom: 10,
            minZoomLevel: 3,
            maxZoomLevel: 12,
            stepZoom: 1.0,
          ),
        ),
        onMapIsReady: (isReady) async {
          if (isReady) {
            await _addMarker();
          }
        },
      ),
    );
  }
}