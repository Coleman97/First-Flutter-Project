import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'requests/google_maps_requests.dart';

class AppWorks with ChangeNotifier {
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  GoogleMapController _mapController;
  static LatLng _initialPosition;
  LatLng lastposition = _initialPosition;
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => lastposition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polyLines;
  bool locationServiceActive = true;

  AppWorks() {
    _getUserLocation();
    _loadingInitialPosition();
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    notifyListeners();
  }

  void _onaddMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(lastposition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Heading This way!"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(lastposition.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
    notifyListeners();
  }

  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _onaddMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    lastposition = position.target;
    notifyListeners();
  }

  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
