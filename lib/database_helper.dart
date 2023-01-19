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
}
