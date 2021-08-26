import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconsConfig {
  static BitmapDescriptor? homeIcon;
  static BitmapDescriptor? pharmacyIcon;

  static Future<void> initIcons() async {
    final Uint8List homeIconBytes =
        await getBytesFromAsset('assets/images/house_icon.png', 100);
    homeIcon = BitmapDescriptor.fromBytes(homeIconBytes);

    final Uint8List pharmacyIconBytes =
        await getBytesFromAsset('assets/images/pharmacy_icon.png', 100);
    pharmacyIcon = BitmapDescriptor.fromBytes(pharmacyIconBytes);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
