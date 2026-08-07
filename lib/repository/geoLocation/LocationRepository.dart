import 'package:fasalguru/model/LocationModel/LocationHandler.dart';
import 'package:fasalguru/services/locationaccess/geoLocation.dart';

class Locationrepository {
      final geoLocation = GeoLocation();


  Future<LocationHandler> getCurrentLocation() async {

    final position = await geoLocation.getCurrentPosition();
    return LocationHandler(latitude: position.latitude, longitude: position.longitude);
  }
}