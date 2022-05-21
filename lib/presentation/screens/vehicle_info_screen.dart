import 'package:driver/constants/colors.dart';
import 'package:driver/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/vehicle_info_cubit/vehicle_info_cubit.dart';
import '../../constants/strings.dart';
import '../widgets/custom_dialog.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final vehicleModelController = TextEditingController();
  final vehicleColorController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SnackBar buildSnackBar(ErrorOccured state) {
    return SnackBar(
      content: Text(
        state.errorMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VehicleInfoCubit>();
    return Scaffold(
      body: Form(
        key: formKey,
        child: SafeArea(
          child: BlocListener<VehicleInfoCubit, VehicleInfoState>(
            listener: (context, state) {
              if (state is DialogShown) {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    status: state.statusMessage,
                  ),
                );
              }
              if (state is ErrorOccured) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(state));
              }
              if (state is VehicleInfoSuccessful) {
                Navigator.pushNamedAndRemoveUntil(
                    context, mainScreen, (route) => false);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(height: 112),
                    const Text(
                      'Enter Vehicle Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Bolt-SemiBold',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) => value!.length < 3
                                ? 'Enter a valid vehicle model'
                                : null,
                            controller: vehicleModelController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Model',
                              labelStyle: TextStyle(
                                fontFamily: 'Bolt-Regular',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) => value!.length < 3
                                ? 'Enter a valid vehicle color'
                                : null,
                            controller: vehicleColorController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Color',
                              labelStyle: TextStyle(
                                fontFamily: 'Bolt-Regular',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) => value!.length < 3
                                ? 'Enter a valid vehicle number'
                                : null,
                            controller: vehicleNumberController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Vehicle Number',
                              labelStyle: TextStyle(
                                fontFamily: 'Bolt-Regular',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            title: 'PROCEED',
                            color: colorAccentPurple,
                            onPressed: () {
                              final vehicleInfo = {
                                'vehicleInfo': {
                                  'model': vehicleModelController.text,
                                  'color': vehicleColorController.text,
                                  'number': vehicleNumberController.text,
                                }
                              };
                              formKey.currentState!.validate()
                                  ? cubit.setVehicleInfo(vehicleInfo)
                                  : null;
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
