import 'package:geolocator/geolocator.dart';

import 'location_exception.dart';

/// Result of a location attempt: either coordinates + a human-readable label,
/// or a [LocationException] explaining why not.
typedef LocationResult = ({double lat, double lng, String label});

/// Gets the device's current position and reverse-geocodes it to a label.
///
/// Two sources, in order:
///   1. GPS via [Geolocator] — accurate, needs permission.
///   2. Manual entry — the caller passes a string we trust as-is.
///
/// The label is what gets stored in `profile.location_text`. The coordinates
/// are what gets stored in `profile.location` (a PostGIS geography point).
class LocationService {
  const LocationService();

  /// Checks whether location services are enabled and permission is granted.
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  /// Requests location permission from the user. Returns the resulting status.
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  /// Gets the current position.
  ///
  /// Throws [LocationException] if permission is denied, services are off, or
  /// the fix times out — the caller decides whether to fall back to manual.
  Future<LocationResult> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException.servicesDisabled();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException.permissionDenied();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException.permissionDeniedForever();
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );

    return (
      lat: position.latitude,
      lng: position.longitude,
      label:
          'Lat ${position.latitude.toStringAsFixed(4)}, '
          'Lng ${position.longitude.toStringAsFixed(4)}',
    );
  }

  /// Wraps a manual entry so it flows through the same return type as GPS.
  LocationResult manual(String label) =>
      (lat: 0.0, lng: 0.0, label: label.trim());
}
