import 'package:flowery_rider/core/app_manger/app_cubit.dart';
import 'package:flowery_rider/core/app_manger/app_states.dart';
import 'package:flowery_rider/features/main_layout/cubit/layout_cubit.dart';
import 'package:flowery_rider/features/main_layout/cubit/layout_state.dart';
import 'package:flowery_rider/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final List<Widget> _screens = [
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Explore Screen')),
    const ProfileScreen(),
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
