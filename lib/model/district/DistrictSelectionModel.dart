/// Represents the farmer's chosen operating district.
/// This object is what gets stored in DistrictViewModel and passed
/// forward to weather, irrigation, and crop recommendation screens.
enum District { lucknow, sitapur }

class DistrictSelectionModel {
  final District district;
  final String displayName;
  final String cropTag;
  final double latitude;
  final double longitude;
  final DateTime selectedAt;

  const DistrictSelectionModel({
    required this.district,
    required this.displayName,
    required this.cropTag,
    required this.latitude,
    required this.longitude,
    required this.selectedAt,
  });

  factory DistrictSelectionModel.lucknow() => DistrictSelectionModel(
        district: District.lucknow,
        displayName: 'Lucknow',
        cropTag: 'Wheat, paddy and mango belt',
        latitude: 26.8467,
        longitude: 80.9462,
        selectedAt: DateTime.now(),
      );

  factory DistrictSelectionModel.sitapur() => DistrictSelectionModel(
        district: District.sitapur,
        displayName: 'Sitapur',
        cropTag: 'Sugarcane and wheat belt',
        latitude: 27.5619,
        longitude: 80.6822,
        selectedAt: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'district': district.name,
        'displayName': displayName,
        'cropTag': cropTag,
        'latitude': latitude,
        'longitude': longitude,
        'selectedAt': selectedAt.toIso8601String(),
      };

  factory DistrictSelectionModel.fromJson(Map<String, dynamic> json) {
    final d = District.values.firstWhere((e) => e.name == json['district']);
    return DistrictSelectionModel(
      district: d,
      displayName: json['displayName'] as String,
      cropTag: json['cropTag'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      selectedAt: DateTime.parse(json['selectedAt'] as String),
    );
  }
}