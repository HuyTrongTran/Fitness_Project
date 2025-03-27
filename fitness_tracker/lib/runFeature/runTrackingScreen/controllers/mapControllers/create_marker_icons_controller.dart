import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateMarkerIconsController {
  Future<void> createMarkerIcons({
    required Function(BitmapDescriptor small, BitmapDescriptor large) onIconsCreated,
    required Function(Position) updateMarkerCallback,
    Position? currentPosition,
  }) async {
    try {
      final ui.PictureRecorder smallRecorder = ui.PictureRecorder();
      final Canvas smallCanvas = Canvas(smallRecorder);
      final Paint whitePaint = Paint()..color = Colors.white;
      final Paint bluePaint = Paint()..color = Colors.blue;
      const double smallBlueRadius = 15;
      const double smallWhiteRadius = 18;

      smallCanvas.drawCircle(const Offset(smallWhiteRadius, smallWhiteRadius), smallWhiteRadius, whitePaint);
      smallCanvas.drawCircle(const Offset(smallWhiteRadius, smallWhiteRadius), smallBlueRadius, bluePaint);

      final smallImg = await smallRecorder.endRecording().toImage((smallWhiteRadius * 2).toInt(), (smallWhiteRadius * 2).toInt());
      final smallData = await smallImg.toByteData(format: ui.ImageByteFormat.png);
      final BitmapDescriptor smallMarkerIcon = BitmapDescriptor.fromBytes(smallData!.buffer.asUint8List());

      final ui.PictureRecorder largeRecorder = ui.PictureRecorder();
      final Canvas largeCanvas = Canvas(largeRecorder);
      const double largeBlueRadius = 25;
      const double largeWhiteRadius = 28;

      largeCanvas.drawCircle(const Offset(largeWhiteRadius, largeWhiteRadius), largeWhiteRadius, whitePaint);
      largeCanvas.drawCircle(const Offset(largeWhiteRadius, largeWhiteRadius), largeBlueRadius, bluePaint);

      final largeImg = await largeRecorder.endRecording().toImage((largeWhiteRadius * 2).toInt(), (largeWhiteRadius * 2).toInt());
      final largeData = await largeImg.toByteData(format: ui.ImageByteFormat.png);
      final BitmapDescriptor largeMarkerIcon = BitmapDescriptor.fromBytes(largeData!.buffer.asUint8List());

      onIconsCreated(smallMarkerIcon, largeMarkerIcon);

      if (currentPosition != null) {
        updateMarkerCallback(currentPosition);
      }
    } catch (e) {
      print("Error creating marker icons: $e");
      onIconsCreated(BitmapDescriptor.defaultMarker, BitmapDescriptor.defaultMarker);
    }
  }
}