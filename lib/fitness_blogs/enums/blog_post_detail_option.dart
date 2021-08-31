enum BlogPostDetailOption { edit, delete }

extension BlogPostDetailOptionX on BlogPostDetailOption {
  bool get isEdit => this == BlogPostDetailOption.edit;
  bool get isDelete => this == BlogPostDetailOption.delete;

  String toStringReadable() {
    if (isEdit) {
      return 'Edit';
    }
    return 'Delete';
  }
}
