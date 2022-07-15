import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_launcher/map_launcher.dart';

class LocationService extends GetxService {
  var availableMaps = <AvailableMap>[].obs;
  GeolocatorPlatform location = GeolocatorPlatform.instance;
  var serviceEnabled = false;
  late LocationPermission permission;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 1,
  );
  var locationData = Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0)
      .obs;

  getAdrres() async {
    List<geo.Placemark>? addres;
    try {
      await location
          .getCurrentPosition(locationSettings: locationSettings)
          .then((value) async {
        addres = await geo.placemarkFromCoordinates(
            value.latitude, value.longitude,
            localeIdentifier: 'id_ID');
      });
      return '${addres![0].street} ${addres![0].subLocality} ${addres![0].locality} ${addres![0].subAdministrativeArea} ${addres![0].administrativeArea} ${addres![0].postalCode}';
    } catch (e) {
      print(e);
    }
  }

  Future<LocationService> init() async {
    permission = await location.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await location.checkPermission();
      if (permission == LocationPermission.denied) {
        await location.requestPermission();
      }
    }

    await location.getCurrentPosition(
      locationSettings: locationSettings,
    );

    availableMaps.value = await MapLauncher.installedMaps;

    return this;
  }
}
