// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:secondproject/features/booking/presentation/bloc/booking_bloc.dart';
// import 'package:secondproject/features/booking/presentation/bloc/booking_event.dart';
// import 'package:secondproject/features/booking/presentation/bloc/booking_state.dart';


// class LocationConfirmationScreen extends StatefulWidget {
//   const LocationConfirmationScreen({super.key});

//   @override
//   State<LocationConfirmationScreen> createState() => _LocationConfirmationScreenState();
// }

// class _LocationConfirmationScreenState extends State<LocationConfirmationScreen> {
//   late GoogleMapController _mapController;
//   Set<Marker> _markers = {};
//   LatLng _selectedLocation = LatLng(37.4223,-122.0848); // Default Dubai Marina

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     _updateLocation(LatLng(position.latitude, position.longitude));
//   }

//   void _updateLocation(LatLng position) {
//     setState(() {
//       _selectedLocation = position;
//       _markers = {
//         Marker(
//           markerId: MarkerId("selected_location"),
//           position: position,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       };
//     });

//     _mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));

//     context.read<BookingBloc>().add(
//       UpdateBookingLocation(latitude: position.latitude, longitude: position.longitude),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<BookingBloc, BookingState>(
//       listener: (context, state) {
//         if (state is LocationUpdateSuccess) {
//           Navigator.pushNamed(context, '/booking/step3');
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Stack(
//             children: [
//               // Google Map
//               GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: _selectedLocation,
//                   zoom: 14,
//                 ),
//                 markers: _markers,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 mapType: MapType.normal,
//                 zoomControlsEnabled: false,
//                 onMapCreated: (controller) {
//                   _mapController = controller;
//                 },
//                 onTap: _updateLocation,
//               ),

//               // Search Bar
//               Positioned(
//                 top: 40,
//                 left: 16,
//                 right: 16,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         // ignore: deprecated_member_use
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.arrow_back, color: Colors.black),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search for your location',
//                             border: InputBorder.none,
//                           ),
//                           onChanged: (value) {
//                             // Connect to Google Places API
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Current Location Button
//               Positioned(
//                 bottom: 100,
//                 right: 16,
//                 child: FloatingActionButton(
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.my_location, color: Colors.blue),
//                   onPressed: _getCurrentLocation,
//                 ),
//               ),

//               // Bottom Sheet with Address & Confirm Button
//               Positioned(
//                 bottom: 30,
//                 left: 30,
//                 right: 30,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     context.read<BookingBloc>().add(ConfirmBookingLocation());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFFFBF43), // Amber color
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text(
//                       'Confirm Pin Location',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

class LocationConfirmationScreen extends StatefulWidget {
  final String bookingId;

  const LocationConfirmationScreen({
    Key? key, 
    required this.bookingId,
  }) : super(key: key);

  @override
  State<LocationConfirmationScreen> createState() => _LocationConfirmationScreenState();
}

class _LocationConfirmationScreenState extends State<LocationConfirmationScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(11.2588, 75.7804); // Default to Kozhikode
  String _fullAddress = '';
  String _shortAddress = '';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      _updateLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _updateLocation(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String shortAddr = '${place.street}';
        String fullAddr = '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
        
        setState(() {
          _selectedLocation = position;
          _shortAddress = shortAddr;
          _fullAddress = fullAddr;
          _markers = {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: position,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          };
        });

        _mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
        
        // Update the location in BLoC
        context.read<BookingBloc>().add(
          UpdateBookingLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting address: $e')),
      );
    }
  }

  void _searchLocation(String query) {
    // Implement search functionality
    // This would typically use the Google Places API
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is LocationUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location confirmed successfully!')),
          );
          Navigator.pushNamed(context, '/booking/step3');
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              // Google Map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 15,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: _updateLocation,
              ),

              // Top Bar with Back Button and Title
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Select delivery location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Search Bar
              Positioned(
                top: 90,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search for a building, street name or area',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: _searchLocation,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Use Current Location Button
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.deepOrange[400],
                    ),
                    label: Text(
                      'Use Current Location',
                      style: TextStyle(
                        color: Colors.deepOrange[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange[400],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Address Panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _shortAddress.isNotEmpty ? _shortAddress : '4/452',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  _fullAddress.isNotEmpty 
                                    ? _fullAddress 
                                    : 'Kozhikode, Kerala 673032, India. (4/452)',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              // Handle address change
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepOrange,
                              side: BorderSide(color: Colors.deepOrange),
                            ),
                            child: const Text('CHANGE'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Save location to booking
                            FirebaseFirestore.instance
                                .collection('bookings')
                                .doc(widget.bookingId)
                                .update({
                                  'latitude': _selectedLocation.latitude,
                                  'longitude': _selectedLocation.longitude,
                                  'address': _fullAddress,
                                  'locationConfirmed': true,
                                });
                                
                            context.read<BookingBloc>().add(ConfirmBookingLocation());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'CONFIRM LOCATION',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading indicator
              if (_isLoadingLocation)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}