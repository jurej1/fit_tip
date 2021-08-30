import 'package:equatable/equatable.dart';

import 'package:fit_tip/fitness_blogs/blocs/blocs.dart';

class BlogSearchResult extends Equatable {
  final String query;
  final SearchBy searchBy;

  const BlogSearchResult({
    required this.query,
    required this.searchBy,
  });

  @override
  List<Object> get props => [query, searchBy];

  BlogSearchResult copyWith({
    String? query,
    SearchBy? searchBy,
  }) {
    return BlogSearchResult(
      query: query ?? this.query,
      searchBy: searchBy ?? this.searchBy,
    );
  }
}
