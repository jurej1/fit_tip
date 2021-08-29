import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../fitness_blogs.dart';

class BannerPicker extends StatelessWidget {
  BannerPicker({Key? key}) : super(key: key);
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBlogPostBloc, AddBlogPostState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Pick banner'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  _pickImage(context, ImageSource.camera);
                },
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: () {
                  _pickImage(context, ImageSource.gallery);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    XFile? file = await _imagePicker.pickImage(source: source);
    BlocProvider.of<AddBlogPostBloc>(context).add(AddBlogPostBannerUpdated(file));
  }
}
