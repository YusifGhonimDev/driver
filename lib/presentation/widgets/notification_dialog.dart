import 'package:driver/constants/colors.dart';
import 'package:driver/constants/strings.dart';
import 'package:driver/presentation/widgets/custom_button.dart';
import 'package:driver/presentation/widgets/taxi_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/maps_cubit/maps_cubit.dart';
import '../../data/models/trip_details.dart';
import 'custom_divider.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails? tripDetails;

  const NotificationDialog({Key? key, this.tripDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 28),
            Image.asset('images/taxi.png', width: 100),
            const SizedBox(height: 16),
            const Text(
              'NEW TRIP REQUEST',
              style: TextStyle(fontFamily: 'Bolt-Semibold', fontSize: 18),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          tripDetails!.pickUp!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Image.asset('images/desticon.png', width: 16, height: 16),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          tripDetails!.destination!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CustomDivider(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TaxiOutlineButton(
                      title: 'DECLINE',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: colorPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                        title: 'ACCEPT',
                        color: colorGreen,
                        onPressed: () {
                          cubit.tripAccepted(tripDetails!.rideID);
                          Navigator.pushNamedAndRemoveUntil(
                              context, tripScreen, (route) => false,
                              arguments: tripDetails);
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
