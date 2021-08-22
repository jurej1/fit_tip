import 'package:blog_repository/src/entity/entity.dart';
import 'package:equatable/equatable.dart';

class BlogPost extends Equatable {
  final String id;
  final String authorId;
  final String? author;
  final DateTime created;
  final String title;
  final int likes;
  final List<String>? tags;
  final String? bannerUrl;
  final String content;
  final bool isPublic;

  BlogPost({
    required this.id,
    required this.authorId,
    this.author,
    DateTime? created,
    required this.title,
    this.likes = 0,
    this.tags,
    this.bannerUrl,
    required this.content,
    required this.isPublic,
  }) : this.created = created ?? DateTime.now();

  @override
  List<Object?> get props {
    return [
      id,
      authorId,
      author,
      created,
      title,
      likes,
      tags,
      bannerUrl,
      content,
      isPublic,
    ];
  }

  BlogPost copyWith({
    String? id,
    String? authorId,
    String? author,
    DateTime? created,
    String? title,
    int? likes,
    List<String>? tags,
    String? bannerUrl,
    String? content,
    bool? isPublic,
  }) {
    return BlogPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      created: created ?? this.created,
      title: title ?? this.title,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      content: content ?? this.content,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  BlogPostEntity toEntity() {
    return BlogPostEntity(
      id: id,
      authorId: authorId,
      title: title,
      content: content,
      isPublic: isPublic,
      author: author,
      bannerUrl: bannerUrl,
      created: created,
      likes: likes,
      tags: tags,
    );
  }

  static BlogPost fromEntity(BlogPostEntity entity) {
    return BlogPost(
      id: entity.id,
      authorId: entity.authorId,
      title: entity.title,
      content: entity.content,
      isPublic: entity.isPublic,
      author: entity.author,
      bannerUrl: entity.bannerUrl,
      created: entity.created,
      likes: entity.likes,
      tags: entity.tags,
    );
  }
}
