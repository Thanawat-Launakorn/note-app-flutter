import 'package:app/bloc/note/note_bloc.dart';
import 'package:app/common_widget/alert_error_dialog.dart';
import 'package:app/common_widget/button.dart';
import 'package:app/helpers/response_api.dart';
import 'package:app/router/arguments.dart';
import 'package:app/shared/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/view/root/home/home.dart';
import 'package:app/view/root/calendar/calendar.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _isSelectItem = false;
  List<int> _selectedItem = [];
  int _selectTab = 0;

  @override
  Widget build(BuildContext context) {
    isSelectItem(v) {
      setState(() {
        _isSelectItem = true;
        _selectedItem = v;
      });
    }

    final List<Widget> _page = [
      HomeScreen(
        isSelectItem: (v) {
          isSelectItem(v);
        },
      ),
      CalendarScreen(),
    ];

    void handleNavigationFloatBottomBar(String tab) {
      setState(() {
        _selectTab = tab == 'home' ? 0 : 1;
      });

      setState(() {
        _isSelectItem = false;
      });
    }

    return BlocListener<NoteBloc, NoteState>(
      listener: (context, deleteState) {
        if (deleteState is NoteError) {
          final payload = deleteState.payload;
          AlertErrorDialog.show(context, payload);
        } else if (deleteState is NoteSuccess) {
          setState(() {
            _isSelectItem = false;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // -- main content --
            Positioned.fill(child: _page[_selectTab]),
            // -- main content --
            // -- bottomFloatNavigationBar --
            _BottomFloatNavigationBar(
              selectItem: _selectedItem,
              isSelectItem: _isSelectItem,
              currentTab: _selectTab,
              onChangePage: handleNavigationFloatBottomBar,
            ),
            // -- bottomFloatNavigationBar --
          ],
        ),
      ),
    );
  }
}

class _BottomFloatNavigationBar extends StatelessWidget {
  const _BottomFloatNavigationBar({
    required this.currentTab,
    required this.onChangePage,
    required this.isSelectItem,
    required this.selectItem,
    super.key,
  });
  final bool isSelectItem;
  final List<int> selectItem;
  final Function(String tab) onChangePage;
  final int currentTab;

  _manageNote(BuildContext context) {
    context.go('/root/manageNote', extra: ManageNoteArguments(method: 'save'));
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
            IconButton(
              onPressed: () {
                if (isSelectItem) {
                  debugPrint('deleteItem');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('delete item'),
                        actions: [
                          Button(
                            title: 'accept',
                            onTap: () {
                              final req = FetchAPI(
                                endpoint: '$localpath/notes/delete-notes',
                                body: {
                                  'ids': selectItem,
                                },
                              );
                              context.read<NoteBloc>().add(DeleteNote(req));
                              context.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  _manageNote(context);
                }
              },
              icon:
                  isSelectItem
                      ? const Icon(Icons.delete, color: Colors.red)
                      : const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
