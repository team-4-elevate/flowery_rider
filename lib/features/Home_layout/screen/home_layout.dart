import 'package:flowery_rider/features/Home_layout/cubit/app_cubit.dart';
import 'package:flowery_rider/features/Home_layout/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final List<Widget> _screens = [
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Explore Screen')),
    const Center(child: Text('Profile Screen')),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          body: _screens[state.bottomNavBarIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.bottomNavBarIndex,
            onTap: (index) {
              context.read<AppCubit>().changeBottomNavBarIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.fact_check_outlined,
                  size: 30,
                ),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: 30,
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
