import 'package:flutter/material.dart';
import 'Dashboard_screen.dart';
import 'stock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(), // Sustainability Dashboard
    const StockScreen(), //Stock Market Data
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Stocks",
          ),
        ],
      ),
    );
  }
}
