import 'dart:async';

import 'package:driver/constants/strings.dart';
import 'package:driver/data/models/trip_details.dart';
import 'package:driver/presentation/widgets/custom_button.dart';
import 'package:driver/presentation/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../business_logic/cubit/maps_cubit/maps_cubit.dart';
import '../../constants/colors.dart';

class TripScreen extends StatefulWidget {
  final TripDetails? tripDetails;

  const TripScreen({Key? key, this.tripDetails}) : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> controller = Completer();
  static const CameraPosition googlePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  final polylinePoints = PolylinePoints();
  String polylinePoint = '';
  final List<LatLng> polylineCoordinates = [];
  LatLng currentLatLng = googlePlex.target;
  String durationText = '';
  String tripTitle = 'ARRIVED';
  Color tripTitleColor = colorGreen;

  void buildPolylines() {
    List<PointLatLng> results = polylinePoints.decodePolyline(polylinePoint);
    List<PointLatLng> decodedPolyline = results;
    if (decodedPolyline.isNotEmpty) {
      for (PointLatLng point in decodedPolyline) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    Polyline polyline = Polyline(
      polylineId: const PolylineId('1'),
      color: const Color.fromARGB(255, 95, 109, 237),
      points: polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    polylines.add(polyline);
  }

  @override
  void initState() {
    context.read<MapsCubit>().getDirectionDetails(
        widget.tripDetails!.pickUpLatLng!,
        widget.tripDetails!.destinationLatLng!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<MapsCubit, MapsState>(
              listener: (context, state) {
                if (state is TripEnded) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return _buildEndTripDialog(state, context);
                    },
                  );
                }
                if (state is CashCollected) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, mainScreen, (route) => false);
                }
              },
              builder: (context, state) {
                if (state is TripLoaded) {
                  polylineCoordinates.clear();
                  polylines.clear();
                  polylinePoint = state.polylinePoint;
                  buildPolylines();
                  markers = state.markers;
                  currentLatLng = state.currentLatLng;
                  mapController!
                      .animateCamera(CameraUpdate.newLatLng(currentLatLng));
                }
                return GoogleMap(
                  padding: const EdgeInsets.only(bottom: 300),
                  polylines: polylines,
                  markers: markers,
                  zoomControlsEnabled: false,
                  initialCameraPosition: googlePlex,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    this.controller.complete(controller);
                    mapController = controller;
                  },
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      spreadRadius: 0.8,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      BlocBuilder<MapsCubit, MapsState>(
                        builder: (context, state) {
                          if (state is DriverArrived) {
                            durationText = state.durationText;
                          }
                          return Text(
                            durationText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Bolt-SemiBold',
                              color: colorAccentPurple,
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.tripDetails!.riderName!,
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'Bolt-SemiBold'),
                          ),
                          const Icon(Icons.phone)
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Image.asset('images/pickicon.png',
                              height: 16, width: 16),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              widget.tripDetails!.pickUp!,
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset('images/desticon.png',
                              height: 16, width: 16),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              widget.tripDetails!.destination!,
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<MapsCubit, MapsState>(
                        builder: (context, state) {
                          if (state is DriverArrived) {
                            tripTitle = state.title;
                            tripTitleColor = state.titleColor;
                          }
                          return CustomButton(
                              title: tripTitle,
                              color: tripTitleColor,
                              onPressed: () {
                                tripTitle == 'END TRIP'
                                    ? cubit.endTrip(widget.tripDetails!)
                                    : cubit.arrived(widget.tripDetails!);
                              });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndTripDialog(TripEnded state, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text('CASH PAYMENT'),
            const SizedBox(height: 20),
            const CustomDivider(),
            const SizedBox(height: 16),
            Image.asset('images/taxi.png', width: 100),
            const SizedBox(height: 16),
            Text(
              'EGP ${state.totalFare}',
              style: const TextStyle(
                fontFamily: 'Bolt-Semibold',
                fontSize: 52,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Amount above is the total fares to be charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 240,
              child: CustomButton(
                title: 'COLLECT CASH',
                color: colorGreen,
                onPressed: () => context
                    .read<MapsCubit>()
                    .cashCollected(widget.tripDetails!),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
