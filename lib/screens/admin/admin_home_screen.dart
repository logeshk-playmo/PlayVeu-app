import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_icon.dart';
import 'admin_bookings_screen.dart';
import 'admin_catalogue_screen.dart';
import 'admin_drawer.dart';
import 'admin_facilities_screen.dart';
import 'admin_more_screen.dart';
import 'admin_notification_screen.dart';
import 'admin_plans_list_screen.dart';
import 'admin_plans_screen.dart';
import 'admin_player_list_screen.dart';
import 'admin_revenue_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_ui.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  AdminDrawerItem _selectedDrawerItem = AdminDrawerItem.home;
  late final TabController _catalogueTabs;

  static const _titles = ['Home', 'Facilities', 'Bookings', 'Catalogue', 'Profile'];

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
    } else if (_tabIndex == 1) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminFacilityEditorScreen(),
        ),
      );
    } else if (_tabIndex == 3) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminCatalogueEditorScreen(),
        ),
      );
    }
  }

  void _onSelectDrawerItem(AdminDrawerItem item) {
    Navigator.of(context).pop();
    switch (item) {
      case AdminDrawerItem.home:
        setState(() {
          _selectedDrawerItem = item;
          _tabIndex = 0;
        });
        break;
      case AdminDrawerItem.plans:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AdminPlansListScreen(),
          ),
        );
        break;
      case AdminDrawerItem.players:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AdminPlayerListScreen(),
          ),
        );
        break;
      case AdminDrawerItem.revenue:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AdminRevenueScreen(),
          ),
        );
        break;
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _tabIndex = index;
      switch (index) {
        case 0:
          _selectedDrawerItem = AdminDrawerItem.home;
          break;
        case 1:
        case 2:
        case 3:
        case 4:
          break;
      }
    });
  }

  String get _addBtnLabel {
    switch (_tabIndex) {
      case 0:
        return 'Add Plan';
      case 1:
        return 'Add Facility';
      case 3:
        return 'Add Item';
      default:
        return 'Add';
    }
  }

  @override
  Widget build(BuildContext context) {
    final showCatalogueTabs = _tabIndex == 3;
    final canAdd =
        _tabIndex == 0 || _tabIndex == 1 || (_tabIndex == 3 && _catalogueTabs.index == 0);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundBottom,
      drawer: AdminDrawer(
        selectedItem: _selectedDrawerItem,
        onSelectItem: _onSelectDrawerItem,
        onLogout: () {
          Navigator.of(context).pop();
          showAdminLogoutDialog(context);
        },
      ),
      appBar: AppBar(
        leadingWidth: 48,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Menu',
          icon: const AppIcon(HugeIcons.strokeRoundedMenu01, size: 22),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(_titles[_tabIndex]),
        actions: [
          if (canAdd)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Center(
                child: FilledButton(
                  onPressed: _onAdd,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_tabIndex == 0) ...[
                        Image.asset(
                          'assets/add_plan_logo.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ] else ...[
                        const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(_addBtnLabel),
                    ],
                  ),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Notifications',
            icon: const AppIcon(
              HugeIcons.strokeRoundedNotification01,
              size: 22,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AdminNotificationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
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
          AdminPlansScreen(
            onOpenProfile: () => _onDestinationSelected(4),
            onOpenFacilities: () => _onDestinationSelected(1),
            onOpenBookings: () => _onDestinationSelected(2),
            onOpenCatalogue: () => _onDestinationSelected(3),
            onOpenCatalogueRentals: () {
              _onDestinationSelected(3);
              _catalogueTabs.animateTo(1);
            },
          ),
          const AdminFacilitiesScreen(),
          const AdminBookingsScreen(),
          AdminCatalogueScreen(tabController: _catalogueTabs),
          AdminMoreScreen(
            onOpenNotifications: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AdminNotificationScreen(),
                ),
              );
            },
            onOpenSettings: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AdminSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: AppSurfaces.bar,
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: const [
              NavigationDestination(
                icon: AppIcon(HugeIcons.strokeRoundedHome01),
                selectedIcon: AppIcon(
                  HugeIcons.strokeRoundedHome01,
                  strokeWidth: 2.4,
                ),
                label: 'Home',
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
