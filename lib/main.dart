import 'package:flutter/material.dart';
import 'database_helper.dart';

//using a global variable, to test run

final dbHelper = DatabaseHelper();

Future<void> main() async {
  //now lets ensure the database is intialized
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lota SQFLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyDataBase(),
    );
  }
}

class MyDataBase extends StatelessWidget {
  const MyDataBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My sqflite database'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: Text('insert'),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _query, child: Text('query')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _update, child: Text('update me')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _delete, child: Text('Delete me')),
          ],
        ),
      ),
    );
  }
}

//The methods for the buttons
void _insert() async {
  //row to insert

  Map<String, dynamic> row = {
    DatabaseHelper.columnName: "Lota",
    DatabaseHelper.columnAge: 29
  };
  final id = await dbHelper.insert(row);
  debugPrint('inserted row id: $id');
}

void _query() async {
  final allRows = await dbHelper.queryAllRows();
  debugPrint('query all rows:');
  for (final row in allRows) {
    debugPrint(row.toString());
  }
}

void _update() async {
  //updating the row

  Map<String, dynamic> row = {
    DatabaseHelper.columnId: 1,
    DatabaseHelper.columnName: 'Lotanna',
    DatabaseHelper.columnAge: 32
  };
  final rowsAffected = await dbHelper.update(row);
  debugPrint('Updated $rowsAffected row(s)');
}

void _delete() async {
  //lets assume that the number of rows is the id for the last row.
  final id = await dbHelper.queryRowCount();
  final rowsDeleted = await dbHelper.delete(id);
  debugPrint('deleted $rowsDeleted row(s): row $id');
}
