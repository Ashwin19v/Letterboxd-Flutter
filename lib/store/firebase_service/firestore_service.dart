import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/store/firebase_service/firestore_provider.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addToWatchlist(
      String uid, Map<String, dynamic> movie, WidgetRef ref) async {
    try {
      await _db.collection('watchlist').add(
          {...movie, 'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
      // Invalidate the watchlist provider to trigger refresh
      ref.invalidate(watchlistProvider);
    } on Exception catch (e) {
      throw Exception('Failed to add to watchlist: $e');
    }
  }

  Future<void> addReview(
      String uid, Map<String, dynamic> review, WidgetRef ref) async {
    try {
      await _db.collection('reviews').add(
          {...review, 'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
      ref.invalidate(reviewProvider);
      ref.invalidate(userReviewProvider);
    } on Exception catch (e) {
      throw Exception('Failed to add to recent watches: $e');
    }
  }

  Future<void> addToRecentWatch(
      String uid, Map<String, dynamic> movie, WidgetRef ref) async {
    try {
      await _db.collection('recent_watches').add(
          {...movie, 'uid': uid, 'createdAt': FieldValue.serverTimestamp()});
      // Invalidate the recent watch provider to trigger refresh
      ref.invalidate(recentWatchProvider);
    } on Exception catch (e) {
      throw Exception('Failed to add to recent watches: $e');
    }
  }

  Future<void> addToList(String uid, String listName,
      Map<String, dynamic> movie, WidgetRef ref) async {
    final docId = '${uid}_$listName';

    final docRef = _db.collection('lists').doc(docId);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({
        'movies': FieldValue.arrayUnion([movie]),
      });
      ref.invalidate(getUserLists);
      ref.invalidate(getListByName);
    } else {
      await docRef.set({
        'uid': uid,
        'listName': listName,
        'movies': [movie],
      });
      ref.invalidate(getUserLists);
      ref.invalidate(getListByName);
    }
  }

  Future<void> deleteFromWatchlist(String documentId, WidgetRef ref) async {
    try {
      await _db.collection('watchlist').doc(documentId).delete();

      ref.invalidate(watchlistProvider);
    } on Exception catch (e) {
      throw Exception('Failed to delete from watchlist: $e');
    }
  }

  Future<void> deleteFromRecentWatch(String documentId, WidgetRef ref) async {
    try {
      await _db.collection('recent_watches').doc(documentId).delete();
      ref.invalidate(recentWatchProvider);
    } on Exception catch (e) {
      throw Exception('Failed to delete from recent watches: $e');
    }
  }

  Future<void> deleteReview(String documentId, WidgetRef ref) async {
    try {
      await _db.collection('reviews').doc(documentId).delete();

      ref.invalidate(reviewProvider);
      ref.invalidate(userReviewProvider);
    } on Exception catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  Future<void> deleteList(String uid, String listName, WidgetRef ref) async {
    try {
      final docId = '${uid}_$listName';
      await _db.collection('lists').doc(docId).delete();
      ref.invalidate(getUserLists);
    } on Exception catch (e) {
      throw Exception('Failed to delete list: $e');
    }
  }

  Future<void> deleteFromList(
    String uid,
    String listName,
    Map<String, dynamic> movie,
    WidgetRef ref,
  ) async {
    try {
      final docId = '${uid}_$listName';
      await _db.collection('lists').doc(docId).update({
        'movies': FieldValue.arrayRemove([movie])
      });
      ref.invalidate(getListByName);
      ref.invalidate(getUserLists);
    } on Exception catch (e) {
      throw Exception('Failed to delete movie from list: $e');
    }
  }
}
