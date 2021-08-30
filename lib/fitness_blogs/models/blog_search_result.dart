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
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
