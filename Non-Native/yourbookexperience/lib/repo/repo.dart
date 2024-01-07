import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:http/http.dart' as http;

import 'dart:async';

class Repo {
  Function? setState;
  List<Review> reviews = [];
  Completer initialized = Completer();
  late final Database database;
  final String dbName = "experiences";
  final String backupDbName = "offline_backup";
  final Uri url = Uri.http("localhost:8000", "/api/reviews/");
  bool lastRequestFailed = false;

  Future<void> onlineSync() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      // sync device changes to server
      var elements = await database.query(backupDbName, orderBy: "id ASC");
      try {
        var updated = elements.isNotEmpty;
        for (var element in elements) {
          switch (element["action"]) {
            case "add":
              int id = await addReviewOnline(Review.load((await database.query(
                  dbName,
                  where: "id=?",
                  whereArgs: [element["rId"]]))[0]));
              // syncrhonize id's with the one got from the server
              Review review = Review.load((await database.query(dbName,
                  where: "id=?", whereArgs: [element["rId"]]))[0]);
              // remove old review from DB because we can't update indexes directly
              await removeReviewOffline(review.id);
              review.id = id;
              // add new review with correct index
              await addReviewOffline(review, false);
              break;
            case "update":
              await updateReviewOnline(
                  int.parse(element["rId"].toString()),
                  Review.load((await database.query(dbName,
                      where: "id=?", whereArgs: [element["rId"]]))[0]));
              break;
            case "delete":
              await removeReviewOnline(int.parse(element["rId"].toString()));
              break;
          }
          database
              .delete(backupDbName, where: "id=?", whereArgs: [element["id"]]);
        }
        // sync server changes to device only if the last sync operation failed

        if (lastRequestFailed) {
          await loadOnlineReviews();
          for (var review in reviews) {
            // if the offline db doesn't have the online elements, add them to db
            if ((await database
                    .query(dbName, where: "id=?", whereArgs: [review.id]))
                .isEmpty) {
              Map<String, dynamic> reviewMap = review.toMap();

              reviewMap.putIfAbsent("id", () => review.id);

              await database.insert(dbName, reviewMap);
              updated = true;
            }
          }
          lastRequestFailed = false;
          if (updated) {
            setState!();
          }
        }
      } catch (e) {
        print("Sync error: $e");
        lastRequestFailed = true;
      }
    }
  }

  Future<void> initLocalDB() async {
    sqflite_ffi.sqfliteFfiInit();
    sqflite_ffi.databaseFactory = databaseFactoryFfi;

    // await deleteDatabase(
    //     join(await getDatabasesPath(), 'experiences_database.db'));

    database = await openDatabase(
        join(await getDatabasesPath(), 'experiences_database.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $dbName(id INTEGER PRIMARY KEY, userId INTEGER, bTitle TEXT, bAuthor TEXT, description TEXT, experiences TEXT, pros TEXT, cons TEXT, rating REAL); CREATE TABLE $backupDbName(action TEXT, rId INTEGER, id INTEGER PRIMARY KEY)');
    }, version: 1);

    initialized.complete();
  }

  Future<void> init() async {
    await initLocalDB();
    onlineSync();
  }

  List<Review> getReviews() {
    return reviews;
  }

  Future<void> loadReviews() async {
    try {
      await loadOnlineReviews();
    } catch (e) {
      print("Error when connecting to the server: $e");
      await loadOfflineReviews();
      lastRequestFailed = true;
      throw "Error when connecting to the server; data will be loaded from device.";
    }
  }

  Future<void> loadOnlineReviews() async {
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print("Error when sending data to the server: ${response.body}");
      throw "Error when adding to the server; the changes will be saved locally.";
    }
    final List<dynamic> jsonList = jsonDecode(response.body);
    reviews = jsonList.map((json) => Review.load(json)).toList();
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
    bool backup = false;
    try {
      // set review's id to global one
      review.id = await addReviewOnline(review);
    } catch (e) {
      print("Error when connecting to the server: $e");
      backup = true;
      lastRequestFailed = true;
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await addReviewOffline(review, backup);
    }
  }

  Future<int> addReviewOnline(Review review) async {
    var response = await http.post(url, body: review.toMap());
    if (response.statusCode != 201) {
      print("Error when sending data to the server: ${response.body}");
      throw "Error when adding to the server; the changes will be saved locally.";
    }
    return int.parse(jsonDecode(response.body)["id"].toString());
  }

  Future<void> addReviewOffline(Review review, bool backup) async {
    try {
      Map<String, dynamic> reviewMap = review.toMap();
      // if the ID is not a placeholder, add it with this id to the DB; otherwise,
      // let it choose an ID automatically
      if (review.id != -1) {
        reviewMap.putIfAbsent("id", () => review.id);
      }
      int id = await database.insert(dbName, reviewMap);
      if (backup) {
        await database.insert(backupDbName, {"action": "add", "rId": id});
      }
      review.id = id;
      reviews.add(review);
    } catch (e) {
      print("Database error when adding a new review: $e ");

      throw "An error occured when adding the review.";
    }
  }

  Future<void> removeReview(int id) async {
    try {
      await removeReviewOnline(id);
    } catch (e) {
      print("Error when connecting to the server: $e");
      // if we didn't add the element offline, delete every modification relating  to it
      // and notify server that we deleted it
      if ((await database.query(backupDbName,
              where: "rId=? and action=?", whereArgs: [id, "add"]))
          .isEmpty) {
        await database.delete(backupDbName, where: "rId=?", whereArgs: [id]);
        await database.insert(backupDbName, {"action": "delete", "rId": id});
        // if we added the element offline, just remove it from the record if it wasn't yet
        // synced
      } else {
        await database.delete(backupDbName, where: "rId=?", whereArgs: [id]);
      }
      lastRequestFailed = true;
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await removeReviewOffline(id);
    }
  }

  Future<void> removeReviewOnline(int id) async {
    var url = Uri.http("localhost:8000", "/api/reviews/$id/");
    var response = await http.delete(url);
    if (response.statusCode != 200 && response.statusCode != 204) {
      print("Error when sending data to the server: ${response.body}");
      throw "Error when adding to the server; the changes will be saved locally.";
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
    bool backup = false;
    try {
      await updateReviewOnline(oldId, newReview);
    } catch (e) {
      print("Error when connecting to the server: $e");
      backup = true;
      lastRequestFailed = true;
      throw "Error when connecting to the server; the changes will be saved locally.";
    } finally {
      await updateReviewOffline(oldId, newReview, backup);
    }
  }

  Future<void> updateReviewOnline(int oldId, Review newReview) async {
    var url = Uri.http("localhost:8000", "/api/reviews/$oldId/");
    var response = await http.put(url, body: newReview.toMap());
    if (response.statusCode != 200 && response.statusCode != 204) {
      print("Error when sending data to the server: ${response.body}");
      throw "Error when adding to the server; the changes will be saved locally.";
    }
  }

  Future<void> updateReviewOffline(
      int oldId, Review newReview, bool backup) async {
    try {
      Map<String, Object?> reviewMap = newReview.toMap();
      reviewMap.putIfAbsent("id", () => newReview.id);
      await database
          .update(dbName, reviewMap, where: "id = ?", whereArgs: [oldId]);

      newReview.id = oldId;
      if (backup) {
        await database.insert(backupDbName, {"action": "update", "rId": oldId});
      }

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
