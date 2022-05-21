import 'dart:async';

import 'package:driver/business_logic/cubit/maps_cubit/maps_cubit.dart';
import 'package:driver/constants/colors.dart';
import 'package:driver/presentation/widgets/confirm_sheet.dart';
import 'package:driver/presentation/widgets/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/availability_button.dart';
import '../widgets/custom_dialog.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController? mapController;
  Completer<GoogleMapController> controller = Completer();
  static const CameraPosition googlePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return SafeArea(
      child: Stack(
        children: [
          BlocConsumer<MapsCubit, MapsState>(
            listener: (context, state) {
              if (state is ShowDialog) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      status: state.status,
                    );
                  },
                );
              }
              if (state is TripReceived) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return NotificationDialog(
                      tripDetails: state.details,
                    );
                  },
                );
              }
            },
            buildWhen: (previous, current) => current is MapsLoaded,
            builder: (context, state) {
              if (state is MapsInitial) {
                cubit.loadMap();
              }
              if (state is MapsLoaded) {
                return GoogleMap(
                  padding: const EdgeInsets.only(top: 140),
                  zoomControlsEnabled: false,
                  initialCameraPosition: googlePlex,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    this.controller.complete(controller);
                    mapController = controller;
                    mapController!.animateCamera(
                        CameraUpdate.newLatLng(state.currentPosition));
                  },
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: colorOrange,
                ));
              }
            },
          ),
          Container(
            height: 140,
            color: colorPrimary,
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<MapsCubit, MapsState>(
                  builder: (context, state) {
                    if (state is GoOnline ||
                        state is GoOffline ||
                        state is MapsLoaded) {
                      return AvailabilityButton(
                          title: cubit.availibilityTitle,
                          color: cubit.availibilityColor,
                          onPressed: () => showModalBottomSheet(
                              isDismissible: false,
                              context: context,
                              builder: (BuildContext context) =>
                                  BlocProvider<MapsCubit>(
                                    create: (context) => MapsCubit(),
                                    child: ConfirmSheet(
                                      cubit: cubit,
                                      title: cubit.isAvailable
                                          ? 'GO OFFLINE'
                                          : 'GO ONLINE',
                                      subtitle: cubit.isAvailable
                                          ? 'You will stop receiving new trip requests'
                                          : 'You are about to become available to receive trip requests',
                                    ),
                                  )));
                    }
                    return AvailabilityButton(
                      title: 'GO ONLINE',
                      color: colorOrange,
                      onPressed: () {},
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      spreadRadius: 0.8,
                      offset: Offset(0.7, 0.7))
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: InkWell(
                  onTap: () async => mapController!.animateCamera(
                      CameraUpdate.newLatLng(await cubit.getCurrentPosition())),
                  child: const Icon(
                    Icons.gps_fixed_outlined,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
