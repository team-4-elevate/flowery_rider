import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: FloweryRider()),
  );
}

class FloweryRider extends StatelessWidget {
  const FloweryRider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const Scaffold(
        body: Center(
          child: Text('hello'),
        ),
      ),
    );
  }
}
