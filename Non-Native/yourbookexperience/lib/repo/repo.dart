import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (review.id == -1) {
      review.id = reviews.last.id + 1;
    }
    await database.insert('experiences', review.toMap());

    reviews.add(review);
  }

  static void removeReview(int id) {
    database.delete('experiences', where: 'id=?', whereArgs: [id]).then(
        (value) => reviews.removeWhere((element) => element.id == id),
        onError: (error) => print(id));
  }

  static void updateReview(int oldId, Review newReview) {
    database.update(
        'experiences', newReview.toMap(), where: "id = ?", whereArgs: [
      oldId
    ]).then((value) => {
          for (int i = 0; i < reviews.length; i++)
            {
              if (reviews[i].id == oldId) {reviews[i] = newReview}
            }
        });
  }
}
