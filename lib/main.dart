import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flowery_rider/core/app_bloc_observer.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/core/routes/app_router.dart';
import 'package:flowery_rider/core/routes/navigator_observer.dart';
import 'package:flowery_rider/core/routes/routes.dart';
import 'package:flowery_rider/core/theme/theme_data/theme_data_light.dart';
import 'package:flowery_rider/features/Home_layout/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await _configureFirebase();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: BlocProvider(
            create: (context) => getIt<AppCubit>()..getUserLoggedInState(),
            child: FloweryRider())),
  );
}

class FloweryRider extends StatelessWidget {
  const FloweryRider({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [getIt<AppNavigatorObserver>()],
        //initialRoute: Routes.login,
        initialRoute: context.read<AppCubit>().state.isLoggedIn
            ? Routes.homeLayout
            : Routes.onboarding,
        onGenerateRoute: generateRoute,
        theme: getLightTheme(),
        darkTheme: ThemeData(),
        themeMode: ThemeMode.light,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
Future<void> _configureFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    return true;
  };
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);
}


/// user app firebase service
@lazySingleton
class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get _ordersRef => _database.ref('orders');

  Future<void> addOrderToRTDB({
    required String orderId,
    required String userId,
    required String status,
    required DateTime estimatedArrival,
  }) async {
    try {
      await _ordersRef.child(orderId).set({
        'userId': userId,
        'status': status,
        'createdAt': DateTime.now().toIso8601String(),
        'estimatedArrival': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        'location': {
          'lat': 0.0,
          'lng': 0.0,
        },
      });
    } catch (e) {
      throw Exception('Failed to add order to Firebase: $e');
    }
  }

  Stream<String> listenToOrderStatus(String orderId) {
    return _ordersRef
        .child(orderId)
        .child('status')
        .onValue
        .map((event) => event.snapshot.value as String);
  }

  Stream<Map<String, double>> listenToDriverLocation(String orderId) {
    return _ordersRef
        .child(orderId)
        .child('location')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        return {'lat': 0.0, 'lng': 0.0};
      }

      return {
        'lat': (data['lat'] as num?)?.toDouble() ?? 0.0,
        'lng': (data['lng'] as num?)?.toDouble() ?? 0.0,
      };
    });
  }

  Future<void> bookOrder({
    required String orderId,
    required String userId,
    required DateTime estimatedArrival,
  }) async {
    await addOrderToRTDB(
      orderId: orderId,
      userId: userId,
      status: 'pending',
      estimatedArrival: estimatedArrival,
    );
  }
}

/// driver app firebase service

@lazySingleton
class DeliveryFirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Location _location = Location();

  DatabaseReference get _ordersRef => _database.ref('orders');

  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await _ordersRef.child(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> startLocationTracking(String orderId, String driverId) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 10000,
    );

    await _ordersRef.child(orderId).update({
      'driverId': driverId,
    });

    _locationSubscription = _location.onLocationChanged.listen(
          (LocationData currentLocation) async {
        await _ordersRef.child(orderId).child('location').update({
          'lat': currentLocation.latitude,
          'lng': currentLocation.longitude,
        });
      },
    );
  }

  Future<void> stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> acceptOrder({
    required String orderId,
    required String driverId,
  }) async {
    // Update status to accepted
    await updateOrderStatus(
      orderId: orderId,
      status: 'accepted',
    );

    await startLocationTracking(orderId, driverId);
  }

  Future<void> markOrderAsPickedUp(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      status: 'picked_up',
    );
  }

  Future<void> dispose() async {
    await stopLocationTracking();
  }
}