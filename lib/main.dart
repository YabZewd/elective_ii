import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/bloc/auth/auth_bloc.dart';
import 'package:mobile/bloc/locations/location_bloc.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/login_auth.dart';

void main() {
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<LocationBloc>(
        create: (_) => LocationBloc(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nova Parking',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(28, 93, 102, 0)),
          fontFamily: 'Poppins',
        ),
        home:         const child: LoginAuthScreen(),
      ),
    );
  }
}
