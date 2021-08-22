import 'package:blog_repository/blog_repository.dart';
import 'package:blog_repository/src/entity/blog_post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity/entity.dart';

class BlogRepository {
  final FirebaseFirestore _firebaseFirestore;

  BlogRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  CollectionReference _blogsReference() {
    return _firebaseFirestore.collection('blogs');
  }

  /// The function returns null if the document does not exists
  Future<DocumentSnapshot> getBlogPostById(String id) async {
    return _blogsReference().doc(id).get();
  }

  Future<QuerySnapshot> getBlogPostsWithSpecificLikeCounts({
    int minimum = 0,
    int? maximum,
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final query = _blogsReference()
        .where(BlogPostDocKeys.likes, isGreaterThanOrEqualTo: minimum, isLessThanOrEqualTo: maximum)
        .orderBy(BlogPostDocKeys.created)
        .limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<void> likeBlogPost() async {
    return _blogsReference().doc().update({
      BlogPostDocKeys.likes: FieldValue.increment(1),
    });
  }

  Future<void> dislikeBlogPost() async {
    return _blogsReference().doc().update({
      BlogPostDocKeys.likes: FieldValue.increment(-1),
    });
  }

  Future<QuerySnapshot> getBlogPostsWithSpecificDateCreated({
    required DateTime firstDate,
    required DateTime lastDate,
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final lowerBound = DateTime(firstDate.year, firstDate.month, firstDate.day);
    final upperBound = DateTime(firstDate.year, firstDate.month, firstDate.day, 23, 59, 59);

    Query query = _blogsReference()
        .orderBy(BlogPostDocKeys.created)
        .where(
          BlogPostDocKeys.created,
          isGreaterThanOrEqualTo: Timestamp.fromDate(lowerBound),
          isLessThanOrEqualTo: Timestamp.fromDate(upperBound),
        )
        .limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostByOwnerId(
    String uid, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) {
    final query = _blogsReference().where(BlogPostDocKeys.authorId, isEqualTo: uid).orderBy(BlogPostDocKeys.created).limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostByTag(
    List<String> tags, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final query = _blogsReference().where(BlogPostDocKeys.tags, arrayContains: tags).orderBy(BlogPostDocKeys.created).limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<DocumentReference> addBlogPost(BlogPost blogPost) async {
    return _blogsReference().add(blogPost.toEntity().toDocumentSnapshot());
  }

  Future<void> updateBlogPost(BlogPost blogPost) async {
    return _blogsReference().doc(blogPost.id).update(blogPost.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteBlogPost(String id) async {
    return _blogsReference().doc(id).delete();
  }
}
