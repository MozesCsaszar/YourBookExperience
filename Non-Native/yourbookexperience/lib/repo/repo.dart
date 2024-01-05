import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:http/http.dart' as http;

import 'dart:async';

class Repo {
  List<Review> reviews = [];
  Completer initialized = Completer();
  late final Database database;
  final String dbName = "experiences";
  final Uri url = Uri.http("localhost:8000", "/api/reviews/");

  Future<void> initLocalDB() async {
    sqflite_ffi.sqfliteFfiInit();
    sqflite_ffi.databaseFactory = databaseFactoryFfi;

    database = await openDatabase(
        join(await getDatabasesPath(), 'experiences_database.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE experiences(id INTEGER PRIMARY KEY, userId INTEGER, bTitle TEXT, bAuthor TEXT, description TEXT, experiences TEXT, pros TEXT, cons TEXT, rating REAL); CREATE TABLE offline_backup(action TEXT, id INT, PRIMARY KEY (action, id))');
    }, version: 1);

    initialized.complete();
  }

  Future<void> init() async {
    await initLocalDB();
  }

  List<Review> getReviews() {
    return reviews;
  }

  Future<void> loadReviews() async {
    try {
      var response = await http.get(url);
      if (response.statusCode != 200) {
        print("Error when sending data to the server: ${response.body}");
        throw "Error when adding to the server; the changes will be saved locally.";
      }
      final List<dynamic> jsonList = jsonDecode(response.body);
      reviews = jsonList.map((json) => Review.load(json)).toList();
    } catch (e) {
      print("Error when connecting to the server: $e");
      await loadOfflineReviews();
      throw "Error when connecting to the server; data will be loaded from device.";
    }
  }

  Future<void> loadOfflineReviews() async {
    await database.query(dbName).then((value) {
      reviews = List.generate(value.length, (i) {
        return Review.load(value[i]);
      });
    }).catchError((error) {
      print("Error when loading reviews from local database: $error");
      throw "Error when loading reviews from local database.";
    });
  }

  Future<void> addReview(Review review) async {
    try {
      var response = await http.post(url, body: review.toMap());
      if (response.statusCode != 201) {
        print("Error when sending data to the server: ${response.body}");
        throw "Error when adding to the server; the changes will be saved locally.";
      }
    } catch (e) {
      print("Error when connecting to the server: $e");
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await addReviewOffline(review);
    }
  }

  Future<void> addReviewOffline(Review review) async {
    try {
      await database.insert(dbName, review.toMap());

      reviews.add(review);
    } catch (e) {
      print("Database error when adding a new review: $e ");

      throw "An error occured when adding the review.";
    }
  }

  Future<void> removeReview(int id) async {
    try {
      var url = Uri.http("localhost:8000", "/api/reviews/$id/");
      var response = await http.delete(url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        print("Error when sending data to the server: ${response.body}");
        throw "Error when adding to the server; the changes will be saved locally.";
      }
    } catch (e) {
      print("Error when connecting to the server: $e");
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await removeReviewOffline(id);
    }
  }

  Future<void> removeReviewOffline(int id) async {
    try {
      await database.delete(dbName, where: 'id=?', whereArgs: [id]);

      reviews.removeWhere((element) => element.id == id);
    } catch (e) {
      print("Database error when removing a review: $e");
      throw "An error occured when deleting the review.";
    }
  }

  Future<void> updateReview(int oldId, Review newReview) async {
    try {
      var url = Uri.http("localhost:8000", "/api/reviews/$oldId/");
      var response = await http.put(url, body: newReview.toMap());
      if (response.statusCode != 200 && response.statusCode != 204) {
        print("Error when sending data to the server: ${response.body}");
        throw "Error when adding to the server; the changes will be saved locally.";
      }
    } catch (e) {
      print("Error when connecting to the server: $e");
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await updateReviewOffline(oldId, newReview);
    }
  }

  Future<void> updateReviewOffline(int oldId, Review newReview) async {
    try {
      await database.update(dbName, newReview.toMap(),
          where: "id = ?", whereArgs: [oldId]);

      for (int i = 0; i < reviews.length; i++) {
        if (reviews[i].id == oldId) {
          reviews[i] = newReview;
        }
      }
    } catch (e) {
      print("Database error when updating a review: $e");
      throw "An error occured when updating the review.";
    }
  }
}
