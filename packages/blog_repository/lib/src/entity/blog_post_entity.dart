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
  static String images = 'images';
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
  final List<String>? images;
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
    this.images,
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
      images,
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
      if (images != null) BlogPostDocKeys.images: images,
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
      likes: data.containsKey(BlogPostDocKeys.likes) ? data[BlogPostDocKeys.likes] : 0,
      tags: data.containsKey(BlogPostDocKeys.tags)
          ? (data[BlogPostDocKeys.tags] as List<dynamic>)
              .map<String>(
                (e) => e.toString(),
              )
              .toList()
          : null,
      images: data.containsKey(BlogPostDocKeys.images)
          ? (data[BlogPostDocKeys.images] as List<dynamic>)
              .map<String>(
                (e) => e.toString(),
              )
              .toList()
          : null,
    );
  }

  BlogPostEntity copyWith({
    String? id,
    String? authorId,
    String? author,
    DateTime? created,
    String? title,
    int? likes,
    List<String>? tags,
    String? bannerUrl,
    String? content,
    List<String>? images,
    bool? isPublic,
  }) {
    return BlogPostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      created: created ?? this.created,
      title: title ?? this.title,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      content: content ?? this.content,
      images: images ?? this.images,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
