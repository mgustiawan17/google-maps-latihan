import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //gambar khusus marker yang bisa ditempatkan di permukaan bumi
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng initialLocation = LatLng(-7.772786, 110.404935);

  List<LatLng> polygonPoints = const [
    LatLng(-7.758698140983066, 110.39552562766922),
    LatLng(-7.783096196467216, 110.38791269827033),
    LatLng(-7.7832463967880985, 110.40823244203276),
    LatLng(-7.761781987601688, 110.4120245359386),
    LatLng(-7.758698140983066, 110.39552562766922),
  ];

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  //ini cara menambahkan icon secara custom, jadi bisa pake icon apa aja
  //yang penting harus menggunakan BitMap Descriptor buat pake marker aja
  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), "assets/pin-location.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps Latihan"),
      ),
      body: GoogleMap(
        //posisi awal camera ditempatkan
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 20,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //menggunakan Sets class supaya tidak terjadi duplikasi pada array
        //setiap item memiliki value yang unik dan unordered/tidak beraturan
        //Marker untuk menaruh marker pada titik koordinat yang ditentukan
        markers: {
          Marker(
            markerId: MarkerId("Demo"),
            position: initialLocation,
            //menyatakan bahwa marker ini bisa berpindah
            draggable: true,
            onDragEnd: (value) {
              //  nilai ini akan terus terupdate tergantung dengan posisi marker sekarang
            },
            icon: markerIcon,
          ),
        },
        // circles: {
        //   Circle(
        //     circleId: CircleId("1"),
        //     center: initialLocation,
        //     radius: 430,
        //     strokeWidth: 2,
        //     fillColor: Color(0xFF00B8D4).withOpacity(0.2)
        //   )
        // },

        polygons: {
          Polygon(
              polygonId: PolygonId("1"),
              points: polygonPoints,
              strokeWidth: 2,
              fillColor: Color(0xFF00B8D4).withOpacity(0.2)),
        },
      ),
    );
  }
}
