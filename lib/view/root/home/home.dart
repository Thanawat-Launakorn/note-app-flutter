import 'package:app/shared/path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:app/router/arguments.dart';
import 'package:app/bloc/note/note_bloc.dart';
import 'package:app/helpers/response_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/helpers/shared_preference.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<int> ids) isSelectItem;

  const HomeScreen({required this.isSelectItem, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<bool> _selectedItem = [];

  @override
  void initState() {
    _loadNotes();
    super.initState();
  }

  Future<void> _loadNotes() async {
    final token = await SharedPreferencesHelpers.getPrefs('authorization');
    final req = FetchAPI(
      methodAPI: METHOD.get,
      endpoint: '$localpath/notes/list-note',
      headers: {'authorization': token},
    );
    if (!mounted) return;
    context.read<NoteBloc>().add(LoadNote(req));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Completed tasks": 5,
      "missed tasks": 3,
      "yet to complete 1 task": 2,
    };

    Widget header() {
      return (Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.only(top: 64, left: 12, right: 12, bottom: 0),
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                stops: [0, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Colors.cyanAccent],
              ),
            ),
            margin: EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.go('/root/info');
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.network(
                          fit: BoxFit.cover,
                          'https://easydrawingart.com/wp-content/uploads/2019/08/How-to-draw-an-anime-face.jpg',
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Hello Auos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Nenver do tommorow what you can do to day, precentination is the thief of time',
                ),
              ],
            ),
          ),
          // --- pie chart ---
          Positioned(
            bottom: 0,
            left: 36,
            right: 36,
            child: Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                color: const Color.fromARGB(239, 255, 255, 255),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text('Today, Sap 10 2022'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return PieChart(
                              ringStrokeWidth: 10,
                              dataMap: dataMap,
                              chartRadius: constraints.maxWidth,
                              chartType: ChartType.ring,
                              chartValuesOptions: ChartValuesOptions(
                                showChartValues: false,
                              ),
                              legendOptions: const LegendOptions(
                                showLegends: false,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                              dataMap.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        color:
                                            Colors
                                                .red, // helper to match pie colors
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(child: Text(entry.key)),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -- Header --
        header(),
        // -- Header --
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Todays Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is NoteLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is NoteError) {
                return Center(
                  child: Text(
                    'Error: ${state.payload['message'] ?? 'Unknown error'}',
                  ),
                );
              } else if (state is NoteSuccess) {
                final payload = state.payload;
                final List<dynamic> items =
                    payload['data']?['note_items'] ?? [];

                if (_selectedItem.length != items.length) {
                  _selectedItem.clear();
                  _selectedItem.addAll(List.filled(items.length, false));
                }

                if (items.isEmpty) {
                  return Center(child: Text('No notes found'));
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                  itemCount: items.length,
                  separatorBuilder:
                      (context, idx) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final item = items[idx];
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _selectedItem[idx],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedItem[idx] = val ?? false;
                                  });
                                  debugPrint('item id => ${item['id']}');
                                  List<int> selectedIndexes = [];
                                  for (
                                    int i = 0;
                                    i < _selectedItem.length;
                                    i++
                                  ) {
                                    if (_selectedItem[i]) {
                                      selectedIndexes.add(items[i]['id']);
                                    }
                                  }
                                  widget.isSelectItem(selectedIndexes);
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] ?? 'No title'),
                                  Text(item['detail'] ?? 'No subtitle'),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              context.go(
                                '/root/manageNote',
                                extra: ManageNoteArguments(
                                  method: 'edit',
                                  data: item,
                                ),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}
