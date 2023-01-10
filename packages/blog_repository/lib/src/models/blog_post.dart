import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class BlogPost extends Equatable {
  final String id;
  final String authorId;
  final String? author;
  final DateTime created;
  final String title;
  final int likes;
  final List<String>? tags;
  final String? bannerUrl;
  final List<String>? images;
  final String content;
  final bool isPublic;

  final bool isAuthor;
  final Like like;
  final bool isSaved;

  BlogPost({
    DateTime? created,
    required this.id,
    required this.authorId,
    this.author,
    required this.title,
    this.likes = 0,
    this.tags,
    this.bannerUrl,
    required this.content,
    required this.isPublic,
    this.isAuthor = false,
    this.like = Like.no,
    this.images,
    this.isSaved = false,
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
      images,
      content,
      isPublic,
      isAuthor,
      like,
      isSaved,
    ];
  }

  factory BlogPost.empty() {
    return BlogPost(id: '', authorId: '', title: '', content: '', isPublic: false);
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
    List<String>? images,
    String? content,
    bool? isPublic,
    bool? isAuthor,
    Like? like,
    bool? isSaved,
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
      images: images ?? this.images,
      content: content ?? this.content,
      isPublic: isPublic ?? this.isPublic,
      isAuthor: isAuthor ?? this.isAuthor,
      like: like ?? this.like,
      isSaved: isSaved ?? this.isSaved,
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
      images: images,
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
      images: entity.images,
    );
  }

  static List<BlogPost> mapQuerySnapshotToBlogPosts(
    QuerySnapshot snapshot, {
    List<String>? saveBlogIds,
    List<String>? likedBlogIds,
    String? userId,
  }) {
    return snapshot.docs.map((e) {
      BlogPost blog = BlogPost.fromEntity(BlogPostEntity.fromDocumentSnapshot(e));

      blog = blog.copyWith(
        isAuthor: userId == blog.authorId,
        isSaved: saveBlogIds?.contains(blog.id),
        like: (likedBlogIds?.contains(blog.id) ?? false) ? Like.yes : Like.no,
      );

      return blog;
    }).toList();
  }
}
