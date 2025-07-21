class HotelModel {
  final int id;
  final String title;
  final String description;
  final String address;
  final String postcode;
  final String phoneNumber;
  final String latitude;
  final String longitude;
  final HotelImage image;

  const HotelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.postcode,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      postcode: json['postcode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      image: HotelImage.fromJson(json['image'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'postcode': postcode,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'image': image.toJson(),
    };
  }
}

class HotelImage {
  final String small;
  final String medium;
  final String large;

  const HotelImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      small: json['small'] ?? '',
      medium: json['medium'] ?? '',
      large: json['large'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small,
      'medium': medium,
      'large': large,
    };
  }
}

class HotelResponse {
  final int status;
  final List<HotelModel> data;

  const HotelResponse({
    required this.status,
    required this.data,
  });

  factory HotelResponse.fromJson(Map<String, dynamic> json) {
    return HotelResponse(
      status: json['status'] ?? 200,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => HotelModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}