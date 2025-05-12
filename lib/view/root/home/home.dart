import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"Flutter": 5, "React": 3, "Xamarin": 2};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -- header --
        Stack(
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
              bottom: 20,
              left: 36,
              right: 36,
              child: Container(
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
                        Flexible(
                          flex: 2,
                          child: PieChart(
                            ringStrokeWidth: 10,
                            dataMap: dataMap,
                            chartRadius: MediaQuery.of(context).size.width / 2,
                            chartType: ChartType.ring,
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: false,
                            ),
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                        Flexible(
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
                                        const SizedBox(width: 8),
                                        Text(entry.key),
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
        ),
        // -- header --
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Todays Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12),
            itemBuilder: (context, idx) {
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
                        Checkbox(value: true, onChanged: (V) {}),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Title $idx'), Text('SubTitle $idx')],
                        ),
                      ],
                    ),

                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              );
            },
            separatorBuilder: (context, idx) => const SizedBox(height: 10),
            itemCount: 10,
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
