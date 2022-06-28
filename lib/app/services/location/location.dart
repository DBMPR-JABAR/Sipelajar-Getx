import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationService extends GetxService {
  Location location = Location();
  var serviceEnabled = false;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  Future<LocationService> init() async {
    serviceEnabled = await location.serviceEnabled();
    permissionGranted = await location.hasPermission();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        serviceEnabled = await location.serviceEnabled();
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.grantedLimited) {
        permissionGranted = await location.requestPermission();
      }
    }
    locationData = await location.getLocation();

    location.changeSettings(accuracy: LocationAccuracy.high);

    return this;
  }
}
