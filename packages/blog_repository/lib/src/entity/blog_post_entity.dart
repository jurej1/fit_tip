import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BlogPostDocKeys {
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

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      BlogPostDocKeys.authorId: authorId,
      if (author != null) BlogPostDocKeys.author: author,
      if (bannerUrl != null) BlogPostDocKeys.bannerUrl: bannerUrl,
      BlogPostDocKeys.content: content,
      BlogPostDocKeys.created: Timestamp.fromDate(created),
      BlogPostDocKeys.isPublic: isPublic,
      if (tags != null) BlogPostDocKeys.tags: tags,
      BlogPostDocKeys.title: title,
    };
  }

  static BlogPostEntity fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final created = data[BlogPostDocKeys.created] as Timestamp;

    return BlogPostEntity(
      id: snapshot.id,
      authorId: data[BlogPostDocKeys.authorId],
      title: data[BlogPostDocKeys.title],
      content: data[BlogPostDocKeys.content],
      isPublic: data[BlogPostDocKeys.isPublic],
      author: data.containsKey(BlogPostDocKeys.author) ? data[BlogPostDocKeys.author] : null,
      bannerUrl: data.containsKey(BlogPostDocKeys.bannerUrl) ? data[BlogPostDocKeys.bannerUrl] : null,
      created: created.toDate(),
      likes: data.containsKey(BlogPostDocKeys.likes) ? data[BlogPostDocKeys.likes] : null,
      tags: (data[BlogPostDocKeys.tags] as List<dynamic>).map<String>((e) => e.toString()).toList(),
    );
  }
}
