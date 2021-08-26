import 'dart:io';

import 'package:blog_repository/blog_repository.dart';
import 'package:blog_repository/src/entity/blog_post_entity.dart';
import 'package:blog_repository/src/enums/blog_comment_order_by.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'entity/entity.dart';

class BlogRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  BlogRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        this._firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  CollectionReference _blogsReference() {
    return _firebaseFirestore.collection('blogs');
  }

  CollectionReference _commentsReference() {
    return _firebaseFirestore.collection('blog_comments');
  }

  Reference _blogBannerBucketRef(String fileName) {
    return _firebaseStorage.ref().child('blog_banner_images/$fileName');
  }

  /// The function returns null if the document does not exists
  Future<DocumentSnapshot> getBlogPostById(String id) async {
    return _blogsReference().doc(id).get();
  }

  Future<void> likeBlogPost(String blogId, Like action) async {
    return _blogsReference().doc(blogId).update({
      BlogPostDocKeys.likes: FieldValue.increment(action.isYes ? 1 : -1),
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
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
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

  Future<QuerySnapshot> getBlogPostByCreated({
    bool descending = false,
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) {
    final query = _blogsReference()
        .orderBy(BlogPostDocKeys.created, descending: descending)
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
        .limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostByLikes({
    bool descending = false,
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) {
    final query = _blogsReference()
        .orderBy(BlogPostDocKeys.likes, descending: descending)
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
        .limit(limit);

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
    final query = _blogsReference()
        .where(BlogPostDocKeys.tags, arrayContains: tags)
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
        .orderBy(BlogPostDocKeys.created)
        .limit(limit);

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

  String _editFilePath(String fileName) {
    int last = fileName.lastIndexOf('/');

    return fileName.substring(last);
  }

  Future<String?> uploadBlogBanner(File file, String userId) async {
    String fileName = _editFilePath(file.path) + userId;

    Reference ref = _blogBannerBucketRef(fileName);

    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot task = await uploadTask;

    if (task.state == TaskState.error) {
      return null;
    } else if (task.state == TaskState.success) {
      return await task.ref.getDownloadURL();
    }
  }

///////////////////////////////////////
  Future<DocumentReference> addBlogComment(BlogComment comment) async {
    return _commentsReference().add(comment.toEntity().toDocumentSnapshot());
  }

  Future<void> deleteBlogComment(String id) async {
    return _commentsReference().doc(id).delete();
  }

  Future<void> updateBlogComment(BlogComment comment) async {
    return _commentsReference().doc(comment.id).update(comment.toEntity().toDocumentSnapshot());
  }

  Future<void> likeBlogComment(String commentId, Like action) {
    return _commentsReference().doc(commentId).update({
      BlogCommentDocumentKeys.likes: FieldValue.increment(action.isYes ? 1 : -1),
    });
  }

  Query _getBlogCommenQueryByOrderBy(Query query, BlogCommentOrderBy orderBy) {
    if (orderBy.isCreatedAscending) {
      return query.orderBy(BlogCommentDocumentKeys.created, descending: false);
    } else if (orderBy.isCreatedDescending) {
      return query.orderBy(BlogCommentDocumentKeys.created, descending: true);
    } else if (orderBy.isLikesAscending) {
      return query.orderBy(BlogCommentDocumentKeys.likes, descending: false);
    } else if (orderBy.isLikesDescending) {
      return query.orderBy(BlogCommentOrderBy.likesDescending, descending: true);
    } else {
      return query.orderBy(BlogCommentDocumentKeys.likes, descending: true).orderBy(BlogCommentDocumentKeys.created, descending: true);
    }
  }

  Future<QuerySnapshot> getBlogCommentsBySpecificBlogId(
    String blogId, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
    BlogCommentOrderBy orderBy = BlogCommentOrderBy.likesAndCreatedDescending,
  }) async {
    Query query = _commentsReference().where(BlogCommentDocumentKeys.blogId, isEqualTo: blogId).limit(limit);

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }
    return _getBlogCommenQueryByOrderBy(query, orderBy).get();
  }

  Future<QuerySnapshot> getBlogCommentsByOwnerId(
    String ownerId, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
    BlogCommentOrderBy orderBy = BlogCommentOrderBy.likesAndCreatedDescending,
  }) async {
    Query query = _commentsReference().where(BlogCommentDocumentKeys.ownerId, isEqualTo: ownerId).limit(limit);

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }
    return _getBlogCommenQueryByOrderBy(query, orderBy).get();
  }
}
