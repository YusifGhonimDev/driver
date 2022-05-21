import 'package:driver/business_logic/cubit/authentication_cubit/authentication_cubit.dart';
import 'package:driver/business_logic/cubit/vehicle_info_cubit/vehicle_info_cubit.dart';
import 'package:driver/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'business_logic/cubit/maps_cubit/maps_cubit.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = AppRouter();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => VehicleInfoCubit(),
        ),
        BlocProvider(
          create: (context) => MapsCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Bolt-Regular'),
        initialRoute: currentUser == null ? loginScreen : mainScreen,
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
  }
}
