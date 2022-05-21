import 'package:driver/constants/colors.dart';
import 'package:driver/presentation/widgets/custom_button.dart';
import 'package:driver/presentation/widgets/taxi_outline_button.dart';
import 'package:flutter/material.dart';

import '../../business_logic/cubit/maps_cubit/maps_cubit.dart';

class ConfirmSheet extends StatelessWidget {
  final MapsCubit cubit;
  final String title;
  final String subtitle;

  const ConfirmSheet(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontFamily: 'Bolt-SemiBold', color: colorText),
          ),
          const SizedBox(height: 24),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: colorTextLight),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TaxiOutlineButton(
                  title: 'BACK',
                  onPressed: () => Navigator.of(context).pop(),
                  color: colorLightGrayFair,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                    title: 'CONFIRM',
                    color: cubit.isAvailable ? Colors.red : colorGreen,
                    onPressed: () {
                      cubit.isAvailable ? cubit.goOffline() : cubit.goOnline();
                      Navigator.pop(context);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
