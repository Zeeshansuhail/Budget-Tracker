import 'package:budget_tracker/budget_responsitary.dart';
import 'package:budget_tracker/chart.dart';
import 'package:budget_tracker/failer_model.dart';
import 'package:budget_tracker/item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItem;

  @override
  void initState() {
    super.initState();
    _futureItem = BudgetRespositary().getitem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Budget Tracker",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        )),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItem = BudgetRespositary().getitem();
          setState(() {});
        },
        child: FutureBuilder<List<Item>>(
          future: _futureItem,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: items.length + 1,
                itemBuilder: (BuildContext context, index) {
                  if (index == 0) {
                    return Chart(items: items);
                  }
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all(
                            width: 2.0,
                            color: getcoloritem(items[index - 1].category)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ]),
                    child: ListTile(
                      title: Text(items[index - 1].name),
                      subtitle: Text(
                          '${items[index - 1].category}. ${DateFormat.yMd().format(items[index - 1].date)} '),
                      trailing: Text(
                          '-\₹${items[index - 1].price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              final failor = snapshot.error as Failer;
              return Center(
                child: Text(failor.message),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Color getcoloritem(String Category) {
  switch (Category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportattion':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
