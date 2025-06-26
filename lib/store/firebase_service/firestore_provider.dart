import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';
import 'package:letterboxd/store/firebase_service/firestore_service.dart';
import 'package:letterboxd/store/omdb_service/omdb_service.dart';

final omdbProvider = Provider((ref) => OmdbService());
final firestoreProvider = Provider((ref) => FirestoreService());

final watchlistProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final uid = ref.watch(authControllerProvider)?.uid;
  if (uid == null) return [];
  final snapshot = await FirebaseFirestore.instance
      .collection('watchlist')
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .get();
  return snapshot.docs
      .map((doc) => {
            ...doc.data(),
            'documentId': doc.id,
          })
      .toList();
});

final userReviewProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final uid = ref.watch(authControllerProvider)?.uid;
  if (uid == null) return [];
  final snapshot = await FirebaseFirestore.instance
      .collection('reviews')
      .where('uid', isEqualTo: uid)
      .get();
  return snapshot.docs
      .map((doc) => {
            ...doc.data(),
            'documentId': doc.id,
          })
      .toList();
});

final reviewProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('reviews')
      .orderBy('createdAt', descending: true)
      .get();
  return snapshot.docs
      .map((doc) => {
            ...doc.data(),
            'documentId': doc.id,
          })
      .toList();
});

final recentWatchProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final uid = ref.watch(authControllerProvider)?.uid;
  if (uid == null) return [];
  final snapshot = await FirebaseFirestore.instance
      .collection('recent_watches')
      .where('uid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .get();
  return snapshot.docs
      .map((doc) => {
            ...doc.data(),
            'documentId': doc.id,
          })
      .toList();
});

final getUserLists = FutureProvider((ref) async {
  final uid = ref.watch(authControllerProvider)?.uid;
  if (uid == null) return [];

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('lists')
        .where('uid', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'listName': data['listName'] ?? 'Untitled List',
        'movies': data['movies'] ?? [],
        'documentId': doc.id,
      };
    }).toList();
  } catch (e) {
    print('Error fetching lists: $e');
    return [];
  }
});

final getListByName =
    FutureProvider.family<List<dynamic>, String>((ref, listName) async {
  final uid = ref.watch(authControllerProvider)?.uid;
  if (uid == null) return [];

  final docId = '${uid}_$listName';
  final doc =
      await FirebaseFirestore.instance.collection('lists').doc(docId).get();

  if (!doc.exists) return [];

  final data = doc.data();
  return (data?['movies'] as List?)
          ?.map((movie) => Map<String, dynamic>.from(movie))
          .toList() ??
      [];
});
