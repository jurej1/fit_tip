import 'package:blog_repository/blog_repository.dart';
import 'package:fit_tip/fitness_blogs/widgets/blog_post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fitness_blogs.dart';

class BlogPostsListBuilder extends StatefulWidget {
  const BlogPostsListBuilder({
    Key? key,
    required this.blogs,
    required this.hasReachedMax,
  }) : super(key: key);

  final List<BlogPost> blogs;
  final bool hasReachedMax;

  @override
  _BlogPostsListBuilderState createState() => _BlogPostsListBuilderState();
}

class _BlogPostsListBuilderState extends State<BlogPostsListBuilder> {
  late final ScrollController _scrollController;
  final double _loaderSpace = 200;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.hasReachedMax ? widget.blogs.length : widget.blogs.length + 1;

    return ListView.separated(
      controller: _scrollController,
      itemCount: length,
      itemBuilder: (context, index) {
        return index >= length ? BottomLoader() : BlogPostTile(item: widget.blogs[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }

  void _onScroll() {
    if (_isBottom) BlocProvider.of<BlogPostsListBloc>(context).add(BlogPostsListLoadMore());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll + _loaderSpace >= maxScroll;
  }
}
