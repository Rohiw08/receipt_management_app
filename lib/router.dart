import 'package:flutter/material.dart';
import 'package:receipt_creator/features/auth/screen/login_screen.dart';
import 'package:receipt_creator/features/customers/screen/add_customer_screen.dart';
import 'package:receipt_creator/features/customers/screen/image_picker_screen.dart';
import 'package:receipt_creator/features/home/screen/home_screen.dart';
import 'package:receipt_creator/features/profile/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    "/customer-form": (_) => const MaterialPage(
          child: CustomerForm(),
        ),
    "/profile-Screen": (_) => const MaterialPage(
          child: ProfileScreen(),
        ),
    "/image-picker/:uuid": (routeData) => MaterialPage(
          child: ImagePickerScreen(uuid: routeData.pathParameters['uuid']!),
        )
  },
);
