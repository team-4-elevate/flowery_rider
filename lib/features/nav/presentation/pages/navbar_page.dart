// features/nav/presentation/pages/navbar_page.dart

import 'package:flowery_rider/features/Home_layout/presentation/cubit/home_cubit.dart';
import 'package:flowery_rider/features/Home_layout/presentation/page/home_layout.dart';
import 'package:get_it/get_it.dart';
import 'package:flowery_rider/features/nav/presentation/cubit/nav_cubit.dart';
import 'package:flowery_rider/features/nav/presentation/cubit/nav_state.dart';
import 'package:flowery_rider/features/orders/orders_page.dart';
import 'package:flowery_rider/features/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavbarPage extends StatefulWidget {
  final int initialTabIndex;
  final int selectedCategoryIndex;
  const NavbarPage(
      {super.key, this.initialTabIndex = 0, this.selectedCategoryIndex = 0});

  // ignore: library_private_types_in_public_api
  static _NavbarPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NavbarPageState>();
  }

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int currentTabIndex = 0;
  final Map<int, Widget> _cachedTabs = {};

  static const List<int> _allTabIndices = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.initialTabIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedTabs.isEmpty) {
      for (final index in _allTabIndices) {
        _cachedTabs[index] = _buildTab(index);
      }
    }
  }

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return BlocProvider(
          create: (_) => GetIt.I<HomeCubit>(),
          child: const HomeLayout(),
        );
      case 1:
        return OrdersPage();
      case 2:
        return ProfilePage();
      default:
        return const SizedBox();
    }
  }

  List<Widget> _buildAllTabs() {
    return _allTabIndices.map((index) => _cachedTabs[index]!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavCubit, NavState>(
      listener: (context, state) {
        if (state.tabIndex != currentTabIndex) {
          if (!_cachedTabs.containsKey(state.tabIndex)) {
            _cachedTabs[state.tabIndex] = _buildTab(state.tabIndex);
          }
          setState(() {
            currentTabIndex = state.tabIndex;
          });
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentTabIndex,
          children: _buildAllTabs(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (index) {
            context.read<NavCubit>().changeTab(index);
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
