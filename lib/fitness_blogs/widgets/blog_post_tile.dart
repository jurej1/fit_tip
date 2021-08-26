import 'package:blog_repository/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogPostTile extends StatelessWidget {
  const BlogPostTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BlogPost item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: item.bannerUrl != null
          ? Image.network(
              item.bannerUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!)
                      : null,
                );
              },
            )
          : null,
      title: Text(item.title),
    );
  }
}
