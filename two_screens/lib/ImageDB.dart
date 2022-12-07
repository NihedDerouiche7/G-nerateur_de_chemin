import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:two_screens/Image.dart';

class ImageDB {
  ImageDB._();

  static final ImageDB db = ImageDB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();

    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'Images.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''Create table  'images' (
          'name' TEXT not null , 
          'new_strokes_x' Text not null, 
          'new_strokes_y' Text not null, 
          'direction' Text not null
        )''');
    });
  }

  Future<List<SavedImage>> getAllImages() async {
    List<Map> maps = await (await database).query("images");

    return maps.isNotEmpty
        ? maps.map((e) => SavedImage.fromJson(e)).toList()
        : [];
  }

  insert(SavedImage model) async {
    await (await database).insert("images", model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  update(SavedImage model) async {
    await (await database).update("images", model.toJson(),
        where: 'name = ?', whereArgs: [model.name]);
  }

  delete(String name) async {
    final result = await (await database)
        .delete("images", where: 'name = ?', whereArgs: [name]);

    print(result);
  }
}
