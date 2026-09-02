import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_bookings_screen.dart';
import 'admin_catalogue_screen.dart';
import 'admin_facilities_screen.dart';
import 'admin_more_screen.dart';
import 'admin_plans_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  late final TabController _catalogueTabs;

  static const _titles = ['Plans', 'Facilities', 'Bookings', 'Catalogue', 'Profile'];

  @override
  void initState() {
    super.initState();
    _catalogueTabs = TabController(length: 2, vsync: this);
    _catalogueTabs.addListener(_onCatalogueTab);
  }

  @override
  void dispose() {
    _catalogueTabs.removeListener(_onCatalogueTab);
    _catalogueTabs.dispose();
    super.dispose();
  }

  void _onCatalogueTab() {
    if (mounted) setState(() {});
  }

  void _onAdd() {
    if (_tabIndex == 0) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const AdminPlanEditorScreen()),
      );
    } else if (_tabIndex == 3) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminCatalogueEditorScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showCatalogueTabs = _tabIndex == 3;
    final canAdd =
        _tabIndex == 0 || (_tabIndex == 3 && _catalogueTabs.index == 0);

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text(_titles[_tabIndex]),
        actions: [
          if (canAdd)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: FilledButton(
                  onPressed: _onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(_tabIndex == 0 ? 'Add plan' : 'Add item'),
                ),
              ),
            ),
        ],
        bottom: showCatalogueTabs
            ? TabBar(
                controller: _catalogueTabs,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.navy,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                dividerColor: AppColors.fieldBorder,
                tabs: const [
                  Tab(text: 'Items'),
                  Tab(text: 'Rentals'),
                ],
              )
            : null,
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          const AdminPlansScreen(),
          const AdminFacilitiesScreen(),
          const AdminBookingsScreen(),
          AdminCatalogueScreen(tabController: _catalogueTabs),
          const AdminMoreScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: (index) => setState(() => _tabIndex = index),
            destinations: const [
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedWallet01),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedWallet01,
                  strokeWidth: 2.4,
                ),
                label: 'Plans',
              ),
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedFootballPitch),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedFootballPitch,
                  strokeWidth: 2.4,
                ),
                label: 'Facilities',
              ),
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedCalendar03),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedCalendar03,
                  strokeWidth: 2.4,
                ),
                label: 'Bookings',
              ),
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedDumbbell02),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedDumbbell02,
                  strokeWidth: 2.4,
                ),
                label: 'Catalogue',
              ),
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedUser),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedUser,
                  strokeWidth: 2.4,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
