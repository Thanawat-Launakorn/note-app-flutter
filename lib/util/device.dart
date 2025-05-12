import 'dart:io';
import 'package:platform_device_id_plus/platform_device_id.dart';

Future<String> getDeviceId() async {
  final deviceId = await PlatformDeviceId.getDeviceId;
  if (deviceId != null && deviceId.isNotEmpty) {
    return deviceId;
  } else {
    return 'no device id';
  }
}

Future<String> getDeviceType() async {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else {
    return 'Unknown';
  }
}
