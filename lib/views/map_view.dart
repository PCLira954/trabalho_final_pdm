import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../controllers/contact_controller.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController _mapController;
  LatLng _initial = LatLng(-5.091944, -42.803889); // default (Teresina)
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadContacts());
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) return;
    final pos = await Geolocator.getCurrentPosition();
    setState(() => _initial = LatLng(pos.latitude, pos.longitude));
  }

  void _loadContacts() {
    final ctrl = Provider.of<ContactController>(context, listen: false);
    ctrl.loadAll().then((_) {
      setState(() {
        _markers = ctrl.contacts.where((c) => c.latitude != null && c.longitude != null).map((c) => Marker(
          markerId: MarkerId(c.id),
          position: LatLng(c.latitude!, c.longitude!),
          infoWindow: InfoWindow(title: c.name, snippet: c.phone, onTap: () {
            
          }),
        )).toSet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapas')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initial, zoom: 14),
        myLocationEnabled: true,
        markers: _markers,
        onMapCreated: (c) => _mapController = c,
      ),
    );
  }
}