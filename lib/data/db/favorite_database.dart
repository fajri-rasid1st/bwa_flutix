import 'package:cick_movie_app/data/models/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDatabase {
  static final FavoriteDatabase instance = FavoriteDatabase._init();

  static Database _database;

  FavoriteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('favorite_database.db');

    return _database;
  }

  // initialize, create, and open database
  Future<Database> _initDB(String file) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, file);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // create database table
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoriteTable (
        ${FavoriteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${FavoriteFields.favoriteId} INTEGER NOT NULL,
        ${FavoriteFields.title} TEXT NOT NULL,
        ${FavoriteFields.posterPath} TEXT,
        ${FavoriteFields.overview} TEXT,
        ${FavoriteFields.type} TEXT NOT NULL,
        ${FavoriteFields.createdAt} TEXT NOT NULL)
    ''');
  }

  // create favorite record and insert it into database table
  Future<Favorite> createFavorite(Favorite favorite) async {
    final db = await instance.database;

    final id = await db.insert(
      favoriteTable,
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return favorite.copyWith(id: id);
  }

  // read favorite records depending on its type
  Future<List<Favorite>> readFavorites(String type) async {
    final db = await instance.database;

    final maps = await db.query(
      favoriteTable,
      columns: [
        FavoriteFields.favoriteId,
        FavoriteFields.title,
        FavoriteFields.posterPath,
        FavoriteFields.overview,
        FavoriteFields.createdAt,
      ],
      where: '${FavoriteFields.type} = ?',
      whereArgs: [type],
      orderBy: '${FavoriteFields.createdAt} DESC',
    );

    if (maps.isNotEmpty) {
      final favorites = List<Favorite>.from(
        maps.map((favorite) {
          return Favorite.fromMap(favorite);
        }),
      );

      return favorites;
    }

    return <Favorite>[];
  }

  // delete favorite record depending on its id
  Future<int> deleteFavorite(int id) async {
    final db = await instance.database;

    final count = await db.delete(
      favoriteTable,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );

    return count;
  }

  // close database
  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
