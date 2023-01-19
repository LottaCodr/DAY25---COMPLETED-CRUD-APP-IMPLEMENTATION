import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'Mydatabase.db';
  static const _databaseVerion = 1;

  static const table = 'lota_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';

  late Database _db;

  //Here's an SQLite code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table (
  $columnId INTEGER PRIMARY KEY,
  $columnName TEXT NOT NULL,
  $columnAge INTEGER NOT NULL
  ) ''');
  }

  //this would open the database (and creates it if it doesnt exist)

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVerion,
      onCreate: _onCreate,
    );
  }

  //creating a helper method
  //here i will insert row in the database where each key in the Map is a column name
  //while the value is the colum value. The return value is the id of the inserted row

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  //here all the rows are retuned as a list of maps.
  //each map is a key-value list of columns.

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

//Lets assum here that the id colum in the map is set.
//Then the colujmn values will be used to update the row
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  //This will now delete a specified id row
  //while the number of affected rows would be returned, this should be 1.
  //given the row exists

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  //for the row count

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }
}
//COMPLETED AND IMPLEMENTED CRUD