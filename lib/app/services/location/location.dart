import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_launcher/map_launcher.dart';

class LocationService extends GetxService {
  var availableMaps = <AvailableMap>[].obs;
  Location location = Location();
  var serviceEnabled = false;
  late PermissionStatus permissionGranted;
  late LocationData locationData;
  var isLoading = true.obs;

  getAdrres(double? lat, double? long) async {
    try {
      var addres = await geo.placemarkFromCoordinates(
          lat ?? locationData.latitude!, long ?? locationData.longitude!,
          localeIdentifier: 'id_ID');
      return '${addres[0].street} ${addres[0].subLocality} ${addres[0].locality} ${addres[0].subAdministrativeArea} ${addres[0].administrativeArea} ${addres[0].postalCode}';
    } catch (e) {
      print(e);
    }
  }

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
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 1000);
    locationData = await location.getLocation();
    availableMaps.value = await MapLauncher.installedMaps;
    isLoading.value = false;

    return this;
  }
}
