import 'package:blog_repository/blog_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class _DocKeys {
  static String authorId = 'authorId';
  static String author = 'author';
  static String created = 'created';
  static String title = 'title';
  static String likes = 'likes';
  static String tags = 'tags';
  static String bannerUrl = 'bannerUrl';
  static String content = 'content';
  static String isPublic = 'isPublic';
}

class BlogPostEntity extends Equatable {
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

  BlogPostEntity({
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
    ];
  }

  Map<String, dynamic> documentSnapshot() {
    return {
      _DocKeys.authorId: authorId,
      if (author != null) _DocKeys.author: author,
      if (bannerUrl != null) _DocKeys.bannerUrl: bannerUrl,
      _DocKeys.content: content,
      _DocKeys.created: Timestamp.fromDate(created),
      _DocKeys.isPublic: isPublic,
      _DocKeys.likes: likes,
      if (tags != null) _DocKeys.tags: tags,
      _DocKeys.title: title,
    };
  }

  static BlogPostEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final created = data[_DocKeys.created] as Timestamp;

    return BlogPostEntity(
      id: snapshot.id,
      authorId: data[_DocKeys.authorId],
      title: data[_DocKeys.title],
      content: data[_DocKeys.content],
      isPublic: data[_DocKeys.isPublic],
      author: data.containsKey(_DocKeys.author) ? data[_DocKeys.author] : null,
      bannerUrl: data.containsKey(_DocKeys.bannerUrl) ? data[_DocKeys.bannerUrl] : null,
      created: created.toDate(),
      likes: data[_DocKeys.likes],
      tags: data[_DocKeys.tags],
    );
  }
}
