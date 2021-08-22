import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BlogCommentDocumentKeys {
  static String blogId = 'blogId';
  static String ownerId = 'ownertId';
  static String ownerName = 'ownerName';
  static String created = 'created';
  static String message = 'message';
  static String likes = 'likes';
}

class BlogCommentEntity extends Equatable {
  final String id;
  final String blogId;
  final String ownerId;
  final String ownerName;
  final DateTime created;
  final String message;
  final int likes;

  BlogCommentEntity({
    required this.id,
    required this.blogId,
    required this.ownerId,
    required this.ownerName,
    DateTime? created,
    required this.message,
    this.likes = 0,
  }) : this.created = created ?? DateTime.now();

  @override
  List<Object> get props {
    return [
      id,
      blogId,
      ownerId,
      ownerName,
      created,
      message,
      likes,
    ];
  }

  BlogCommentEntity copyWith({
    String? id,
    String? blogId,
    String? ownerId,
    String? ownerName,
    DateTime? created,
    String? message,
    int? likes,
  }) {
    return BlogCommentEntity(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      created: created ?? this.created,
      message: message ?? this.message,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      BlogCommentDocumentKeys.blogId: blogId,
      BlogCommentDocumentKeys.created: Timestamp.fromDate(created),
      BlogCommentDocumentKeys.likes: likes,
      BlogCommentDocumentKeys.message: message,
      BlogCommentDocumentKeys.ownerId: ownerId,
      BlogCommentDocumentKeys.ownerName: ownerName,
    };
  }

  BlogCommentEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final created = data[BlogCommentDocumentKeys.created] as Timestamp;
    return BlogCommentEntity(
      id: snapshot.id,
      blogId: data[BlogCommentDocumentKeys.blogId],
      message: data[BlogCommentDocumentKeys.message],
      ownerId: data[BlogCommentDocumentKeys.ownerId],
      ownerName: data[BlogCommentDocumentKeys.ownerName],
      created: created.toDate(),
      likes: data[BlogCommentDocumentKeys.likes],
    );
  }
}
