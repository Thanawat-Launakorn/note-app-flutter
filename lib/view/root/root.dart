import 'package:flutter/material.dart';
import 'package:app/view/root/home/home.dart';
import 'package:app/view/root/calendar/calendar.dart';
import 'package:go_router/go_router.dart';

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
            currentTab: _selectTab,
            onChangePage: handleNavigationFloatBottomBar,
          ),
          // -- bottomFloatNavigationBar --
        ],
      ),
    );
  }
}

class _BottomFloatNavigationBar extends StatelessWidget {
  const _BottomFloatNavigationBar({
    required this.currentTab,
    required this.onChangePage,
    super.key,
  });
  final Function(String tab) onChangePage;
  final int currentTab;

  _manageNote(BuildContext context) {
    context.go('/root/manageNote');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> pageButtons = {
      'home': {
        'icon': Icons.home,
        'label': 'Home',
        'onPressed': () => onChangePage('home'),
        'isActive': currentTab == 0,
      },

      'calendar': {
        'icon': Icons.calendar_month,
        'label': 'Calendar',
        'onPressed': () => onChangePage('calendar'),
        'isActive': currentTab == 1,
      },
    };

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
            ...pageButtons.entries.map((entry) {
              final pageName = entry.key;
              final Map<String, dynamic> buttonData = entry.value;

              return IconButton(
                onPressed: buttonData['onPressed'],
                icon: Icon(
                  buttonData['icon'],
                  color: buttonData['isActive'] ? Colors.blue : Colors.grey,
                ),
              );
            }),
            IconButton(onPressed: () => _manageNote(context), icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
