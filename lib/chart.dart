import 'package:budget_tracker/budget_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';

import 'item_model.dart';

class Chart extends StatelessWidget {
  final List<Item> items;
  const Chart({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speading = <String, double>{};

    items.forEach((item) => speading.update(
          item.category,
          (value) => value + item.price,
          ifAbsent: () => item.price,
        ));
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(18.0),
        height: 360.0,
        child: Column(children: [
          Expanded(
            child: PieChart(PieChartData(
              sections: speading
                  .map((Category, amountspent) => MapEntry(
                      Category,
                      PieChartSectionData(
                        color: getcoloritem(Category),
                        radius: 100.0,
                        title: '\₹${amountspent.toStringAsFixed(2)}',
                        value: amountspent,
                        titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )))
                  .values
                  .toList(),
              sectionsSpace: 0,
            )),
          ),
          SizedBox(
            height: 20.0,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: speading.keys
                .map((Category) =>
                    Indicator(color: getcoloritem(Category), text: Category))
                .toList(),
          ),
        ]),
      ),
    );
  }
}
