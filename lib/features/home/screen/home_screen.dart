import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/features/dashboard/screen/dashboard.dart';
import 'package:receipt_creator/features/customers/screen/statement_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [DashboardScreen(), const StatementPage()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void pushReceipt() {
    Routemaster.of(context).push("/customer-form");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.lightBlue,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.space_dashboard_rounded),
            label: AppLocalizations.of(context)!
                .dashboardLabel, // Use localization
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.view_list_rounded),
            label: AppLocalizations.of(context)!
                .statementLabel, // Use localization
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushReceipt(),
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
