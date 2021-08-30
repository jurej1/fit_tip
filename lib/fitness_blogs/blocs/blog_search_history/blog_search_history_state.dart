part of 'blog_search_history_bloc.dart';

class BlogSearchHistoryState extends Equatable {
  const BlogSearchHistoryState({
    required this.byTags,
    required this.byAuthor,
    required this.byTitle,
  });

  final List<String> byTags;
  final List<String> byAuthor;
  final List<String> byTitle;

  @override
  List<Object> get props => [byTags, byAuthor, byTitle];

  BlogSearchHistoryState copyWith({
    List<String>? byTags,
    List<String>? byAuthor,
    List<String>? byTitle,
  }) {
    return BlogSearchHistoryState(
      byTags: byTags ?? this.byTags,
      byAuthor: byAuthor ?? this.byAuthor,
      byTitle: byTitle ?? this.byTitle,
    );
  }

  factory BlogSearchHistoryState.initial() {
    return BlogSearchHistoryState(byTags: [], byAuthor: [], byTitle: []);
  }
}
