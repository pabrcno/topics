import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to read and write from their storage.
  Future<bool> requestStoragePermission({Function? onPermissionDenied}) async {
    var granted = await _requestPermission(Permission.storage);
    if (!granted) {
      onPermissionDenied?.call();
    }
    return granted;
  }

  /// Requests the users permission to read their camera.
  Future<bool> requestCameraPermission({Function? onPermissionDenied}) async {
    var granted = await _requestPermission(Permission.camera);
    if (!granted) {
      onPermissionDenied?.call();
    }
    return granted;
  }

  Future<bool> hasCameraPermission() async {
    return hasPermission(Permission.camera);
  }

  Future<bool> hasStoragePermission() async {
    return hasPermission(Permission.storage);
  }

  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }
}
