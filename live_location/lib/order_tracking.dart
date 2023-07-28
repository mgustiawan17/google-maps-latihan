import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'utils.dart';

class OrderTracking extends StatefulWidget {
  const OrderTracking({Key? key}) : super(key: key);

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation =
      LatLng(-7.772918839038758, 110.40490744064863);
  static const LatLng destination =
      LatLng(-7.765434838955759, 110.40580622196272);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    // untuk menginisialisasi kondisi utama yaitu menepatkan posisi utama
    location.getLocation().then((value) {
      currentLocation = value;
    });
    GoogleMapController googleMapController = await _controller.future;
    // marker berpindah ketika user berjalan/ubah posisi
    location.onLocationChanged.listen((event) {
      currentLocation = event;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              event.latitude!,
              event.longitude!,
            ),
          ),
        ),
      );

      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    // menggambarkan garis polygon diantara titik source dengan titik destination
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Utils.API_KEY,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        //menambahkan titik di setiap garisnya
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        // print("Lat: ${point.latitude}, Lng: ${point.longitude}");
      });
      setState(() {});
      // print("points ada");
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Track Order",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: currentLocation == null
          ? Text("Loading...")
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocation!.latitude ?? 0.0,
                      currentLocation!.longitude ?? 0.0),
                  zoom: 16),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: MarkerId("Source"),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("Source"),
                  position: LatLng(currentLocation!.latitude ?? 0.0,
                      currentLocation!.longitude ?? 0.0),
                ),
                Marker(
                  markerId: MarkerId("Destination"),
                  position: destination,
                ),
              },
              polylines: {
                Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.black,
                    width: 6),
              },
            ),
    );
  }
}
