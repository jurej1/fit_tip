import 'package:blog_repository/src/entity/entity.dart';
import 'package:equatable/equatable.dart';

class BlogComment extends Equatable {
  final String id;
  final String blogId;
  final String ownerId;
  final String ownerName;
  final DateTime created;
  final String message;
  final int likes;

  BlogComment({
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
    return [id, blogId, ownerId, ownerName, created, message, likes];
  }

  BlogComment copyWith({
    String? id,
    String? blogId,
    String? ownerId,
    String? ownerName,
    DateTime? created,
    String? message,
    int? likes,
  }) {
    return BlogComment(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      created: created ?? this.created,
      message: message ?? this.message,
      likes: likes ?? this.likes,
    );
  }

  BlogCommentEntity toEntity() {
    return BlogCommentEntity(
      id: id,
      blogId: blogId,
      ownerId: ownerId,
      ownerName: ownerName,
      message: message,
      created: created,
      likes: likes,
    );
  }

  static BlogComment fromEntity(BlogCommentEntity entity) {
    return BlogComment(
      id: entity.id,
      blogId: entity.blogId,
      ownerId: entity.ownerId,
      ownerName: entity.ownerName,
      message: entity.message,
      created: entity.created,
      likes: entity.likes,
    );
  }
}
