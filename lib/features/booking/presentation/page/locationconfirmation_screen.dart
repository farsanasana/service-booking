// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../bloc/booking_bloc.dart';
// import '../bloc/booking_event.dart';
// import '../bloc/booking_state.dart';

// class LocationConfirmationScreen extends StatelessWidget {
//   final String bookingId;
  
//   const LocationConfirmationScreen({
//     super.key,
//     required this.bookingId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final LatLng initialLocation = LatLng(25.0772, 55.1348); // Dubai Marina coordinates
//     final Set<Marker> markers = {
//       Marker(
//         markerId: MarkerId('selected_location'),
//         position: initialLocation,
//         draggable: true,
//         onDragEnd: (LatLng position) {
//           context.read<BookingBloc>().add(
//             UpdateBookingLocation(
//               bookingId: bookingId,
//               latitude: position.latitude,
//               longitude: position.longitude,
//             ),
//           );
//         },
//       ),
//     };

//     return BlocListener<BookingBloc, BookingState>(
//       listener: (context, state) {
//         if (state is LocationUpdateSuccess) {
//           Navigator.pushNamed(context, '/booking/step3');
//         } else if (state is BookingError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text('Step 2 of 4'),
//         ),
//         body: Stack(
//           children: [
//             Positioned(
//               top: 16,
//               left: 16,
//               right: 16,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search for your building or area',
//                     prefixIcon: Icon(Icons.arrow_back),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 15,
//                     ),
//                   ),
//                   onChanged: (value) {
//                   },
//                 ),
//               ),
//             ),
            
//             Positioned.fill(
//               top: 80,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: initialLocation,
//                   zoom: 15,
//                 ),
//                 markers: markers,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//                 mapType: MapType.normal,
//                 onTap: (LatLng position) {
//                   markers.clear();
//                   markers.add(
//                     Marker(
//                       markerId: MarkerId('selected_location'),
//                       position: position,
//                       draggable: true,
//                     ),
//                   );
                  
//                   context.read<BookingBloc>().add(
//                     UpdateBookingLocation(
//                       bookingId: bookingId,
//                       latitude: position.latitude,
//                       longitude: position.longitude,
//                     ),
//                   );
//                 },
//               ),
//             ),
            

//             Positioned(
//               bottom: 16,
//               right: 16,
//               child: FloatingActionButton(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.my_location, color: Colors.black),
//                 onPressed: () {

//                 },
//               ),
//             ),
            

//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     context.read<BookingBloc>().add(
//                       ConfirmBookingLocation(bookingId: bookingId),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Text('Confirm Pin Location'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

class LocationConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const LocationConfirmationScreen({super.key, required this.bookingId});

  Future<void> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission is denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    context.read<BookingBloc>().add(
      UpdateBookingLocation(
        bookingId: bookingId,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is LocationUpdateSuccess) {
          Navigator.pushNamed(context, '/booking/step3');
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        LatLng initialLocation = LatLng(25.0772, 55.1348); // Default to Dubai Marina
        if (state is BookingLocationUpdated) {
          initialLocation = LatLng(state.latitude, state.longitude);
        }

        final Marker selectedMarker = Marker(
          markerId: MarkerId('selected_location'),
          position: initialLocation,
          draggable: true,
          onDragEnd: (LatLng position) {
            context.read<BookingBloc>().add(
              UpdateBookingLocation(
                bookingId: bookingId,
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );
          },
        );

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Step 2 of 4'),
          ),
          body: Stack(
            children: [
              // Search Bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for your building or area',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onChanged: (value) {
                      // Handle search
                    },
                  ),
                ),
              ),

              // Google Map
              Positioned.fill(
                top: 80,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialLocation,
                    zoom: 15,
                  ),
                  markers: {selectedMarker},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false, // Using custom button
                  mapType: MapType.normal,
                  onTap: (LatLng position) {
                    context.read<BookingBloc>().add(
                      UpdateBookingLocation(
                        bookingId: bookingId,
                        latitude: position.latitude,
                        longitude: position.longitude,
                      ),
                    );
                  },
                ),
              ),

              // Current Location Button
              Positioned(
                bottom: 80,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.my_location, color: Colors.black),
                  onPressed: () => _getCurrentLocation(context),
                ),
              ),

              // Confirm Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<BookingBloc>().add(
                        ConfirmBookingLocation(bookingId: bookingId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text('Confirm Pin Location'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
