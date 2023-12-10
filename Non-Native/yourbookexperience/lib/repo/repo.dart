import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import 'dart:async';

class Repo {
  static List<Review> reviews = [];
  static bool initialized = false;
  static late final Database database;

  static Future<void> init() async {
    if (!initialized) {
      sqflite_ffi.sqfliteFfiInit();
      sqflite_ffi.databaseFactory = databaseFactoryFfi;

      database = await openDatabase(
          join(await getDatabasesPath(), 'experiences_database.db'),
          onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE experiences(id INTEGER PRIMARY KEY, userId INTEGER, bTitle TEXT, bAuthor TEXT, description TEXT, experiences TEXT, pros TEXT, cons TEXT, rating REAL)');
      }, version: 1);
      await loadReviews();
      initialized = true;
    }
  }

  static List<Review> getReviews() {
    return reviews;
  }

  static Future<void> loadReviews() async {
    final List<Map<String, dynamic>> maps = await database.query('experiences');

    reviews = List.generate(maps.length, (i) {
      return Review.load(maps[i]);
    });
  }

  static void addReview(Review review) async {
    await database.insert('experiences', review.toMap());

    reviews.add(review);
  }

  static void removeReview(int id) async {
    await database.delete('experiences', where: 'id=?', whereArgs: [id]);

    reviews.removeWhere((element) => element.id == id);
  }

  static void updateReview(int oldId, Review newReview) async {
    await database.update('experiences', newReview.toMap(),
        where: "id = ?", whereArgs: [oldId]);

    for (int i = 0; i < reviews.length; i++) {
      if (reviews[i].id == oldId) {
        reviews[i] = newReview;
      }
    }
  }
}
