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

  CollectionReference _usersReference() {
    return _firebaseFirestore.collection('users');
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

  Future<QuerySnapshot> getBlogPostsByOwnerId(
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

  Future<QuerySnapshot> getBlogPostsByCreated({
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

  Future<QuerySnapshot> getBlogPostsByBlogIds({
    List<String> blogIds = const [],
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) {
    final query = _blogsReference().where(FieldPath.documentId, whereIn: blogIds).limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostsByTag(
    String value, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final query = _blogsReference()
        .where(BlogPostDocKeys.tags, arrayContains: value)
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
        .orderBy(BlogPostDocKeys.created)
        .limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostsByTitle(
    String value, {
    List<String>? blogIds,
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final query = _blogsReference()
        .where(BlogPostDocKeys.title, isEqualTo: value)
        .where(BlogPostDocKeys.isPublic, isEqualTo: true)
        .orderBy(BlogPostDocKeys.created)
        .limit(limit);

    if (startAfterDoc != null) {
      return query.startAfterDocument(startAfterDoc).get();
    }

    return query.get();
  }

  Future<QuerySnapshot> getBlogPostsByAuthor(
    String value, {
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    final query = _blogsReference()
        .where(BlogPostDocKeys.author, isEqualTo: value)
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

  Future<DocumentSnapshot> getAuthorData(String userId) async {
    return _usersReference().doc(userId).get();
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
