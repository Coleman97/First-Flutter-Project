import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tobby_uber_clone/appwork.dart';
import 'appwork.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: AppWorks(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyAppState createState() => _MyAppState();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Map()),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appwork = Provider.of<AppWorks>(context);
    return appwork.initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: appwork.onCreated,
                initialCameraPosition: CameraPosition(
                  target: appwork.initialPosition,
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: appwork.markers,
                onCameraMove: appwork.onCameraMove,
                polylines: appwork.polylines,
              ),

              Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appwork.locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20.0, top: 5.0),
                        width: 10.0,
                        height: 10,
                        child: Icon(Icons.location_on, color: Colors.black),
                      ),
                      hintText: "Enter Current Location!.....",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 105.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appwork.destinationController,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      appwork.sendRequest(value);
                    },
                    decoration: InputDecoration(
                      icon: Container(
                          margin: EdgeInsets.only(left: 20.0, top: 5.0),
                          width: 10.0,
                          height: 10,
                          child: Icon(Icons.local_taxi, color: Colors.yellow)),
                      hintText: "Destination......",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

              // Positioned(
              //   top: 40,
              //   right: 10,
              //   child: FloatingActionButton(
              //     onPressed: _onAddMarkerPressed,
              //     tooltip: "Addmarker",
              //     backgroundColor: black,
              //     child: Icon(
              //       Icons.add_location,
              //       color: white,
              //     ),
              //   ),
              // ),
            ],
          );
  }
}
