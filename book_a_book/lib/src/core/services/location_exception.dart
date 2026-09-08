/// Why a location attempt failed. Each case maps to a specific recovery path
/// in the UI — the screen switches on this type to show the right message and
/// the right fallback.
sealed class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  const factory LocationException.servicesDisabled() =
      _ServicesDisabled;
  const factory LocationException.permissionDenied() = _PermissionDenied;
  const factory LocationException.permissionDeniedForever() =
      _PermissionDeniedForever;
  const factory LocationException.timeout() = _Timeout;
  const factory LocationException.unknown(Object error) = _Unknown;
}

class _ServicesDisabled extends LocationException {
  const _ServicesDisabled() : super('Turn on location services to continue.');
}

class _PermissionDenied extends LocationException {
  const _PermissionDenied() : super('Location permission was denied.');
}

class _PermissionDeniedForever extends LocationException {
  const _PermissionDeniedForever()
      : super('Location permission is permanently denied. '
            'Enable it in your device settings.');
}

class _Timeout extends LocationException {
  const _Timeout() : super('Could not get a location fix in time.');
}

class _Unknown extends LocationException {
  const _Unknown(Object error) : super('Something went wrong: $error');
}
