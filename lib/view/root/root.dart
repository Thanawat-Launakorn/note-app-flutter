import 'package:app/view/root/calendar/calendar.dart';
import 'package:app/view/root/home/home.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectTab = 0;
  final List<Widget> _page = [HomeScreen(), CalendarScreen()];
  @override
  Widget build(BuildContext context) {
    void handleNavigationFloatBottomBar(String tab) {
      setState(() {
        _selectTab = tab == 'home' ? 0 : 1;
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // -- main content --
          Positioned.fill(child: _page[_selectTab]),
          // -- main content --
          // -- bottomFloatNavigationBar --
          _BottomFloatNavigationBar(
            onChangePage: handleNavigationFloatBottomBar,
          ),
          // -- bottomFloatNavigationBar --
        ],
      ),
    );
  }
}

class _BottomFloatNavigationBar extends StatelessWidget {
  const _BottomFloatNavigationBar({required this.onChangePage, super.key});
  final Function(String tab) onChangePage;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => onChangePage('home'),
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () => onChangePage('calendar'),
              icon: const Icon(Icons.calendar_month),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
