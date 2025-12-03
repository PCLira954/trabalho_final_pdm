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
  GoogleMapController? _mapController;
  LatLng _initial = LatLng(-5.091944, -42.803889); // Teresina
  Set<Marker> _markers = {};
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadContacts());
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loadingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() => _loadingLocation = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition();

    if (!mounted) return;

    setState(() {
      _initial = LatLng(pos.latitude, pos.longitude);
      _loadingLocation = false;
    });

    _animateToPosition(_initial);
  }

  void _animateToPosition(LatLng pos) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 16),
      ),
    );
  }

  void _loadContacts() {
    final ctrl = Provider.of<ContactController>(context, listen: false);

    ctrl.loadAll().then((_) {
      if (!mounted) return;

      setState(() {
        _markers = ctrl.contacts
            .where((c) => c.latitude != null && c.longitude != null)
            .map((c) => Marker(
                  markerId: MarkerId(c.id),
                  position: LatLng(c.latitude!, c.longitude!),
                  infoWindow:
                      InfoWindow(title: c.name, snippet: c.phone),
                ))
            .toSet();
      });
    });
  }

  Future<void> _goToMyLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    _animateToPosition(LatLng(pos.latitude, pos.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initial, zoom: 14),
        myLocationEnabled: true,
        myLocationButtonEnabled: false, // botão padrão desativado
        markers: _markers,
        onMapCreated: (c) => _mapController = c,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}