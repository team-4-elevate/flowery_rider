// features/main_layout/screen/layout_screen.dart
import 'package:flowery_rider/core/di/injectable.dart';
import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/page/home_screen.dart';
import 'package:flowery_rider/features/main_layout/cubit/layout_cubit.dart';
import 'package:flowery_rider/features/main_layout/cubit/layout_state.dart';
import 'package:flowery_rider/features/order_details/presentation/order_details_page/order_details_page.dart';
import 'package:flowery_rider/features/orders/presentation/pages/orders_screen.dart';
import 'package:flowery_rider/features/orders/domain/usecase/order_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final List<Widget> _screens = [
    BlocProvider(
        create: (context) => getIt<HomeCubit>(), child: const HomeScreen()),
    /*    BlocProvider(
        create: (context) => OrdersCubit(getIt()), child: const OrdersScreen()), */
    BlocProvider(
        create: (context) => getIt<HomeCubit>(), 
        child: FutureBuilder<String?>(
          future: getIt<OdersUsecase>().execute(),
          builder: (context, snapshot) => OrdersScreen(driverId: snapshot.data),
        ),
    ),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: _screens[state.bottomNavBarIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.bottomNavBarIndex,
            onTap: (index) {
              context.read<LayoutCubit>().changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.fact_check_outlined,
                ),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      buildWhen: (previous, current) {
        return previous.bottomNavBarIndex != current.bottomNavBarIndex;
      },
    );
  }
}
