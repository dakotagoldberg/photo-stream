import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/ModelProvider.dart';
import '../state/app_state_model.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final ImagePicker _picker = ImagePicker();

  var selectedImage;
  late String postTime;
  late String imageKey;
  bool imagePosted = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<String> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  Future<void> pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
    });
  }

  Future<String> getCurrentUserId() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  Future<bool> createAndUploadFile(File imageToUpload) async {
    try {
      String userId = await getCurrentUser();
      setState(() {
        postTime = DateTime.now().toString();
        imageKey = 'posts/$userId$postTime';
      });
      try {
        final UploadFileResult result = await Amplify.Storage.uploadFile(
            local: imageToUpload,
            key: imageKey,
            // options: S3UploadFileOptions(
            //   accessLevel: StorageAccessLevel.guest,
            // ),
            onProgress: (progress) {
              print('Fraction completed: ${progress.getFractionCompleted()}');
            });
        print('Successfully uploaded file: ${result.key}');
        return true;
      } on StorageException catch (e) {
        print('Error uploading file: $e');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      Navigator.pushNamed(context, '/profile');
      return false;
    }
  }

  Future<void> savePost() async {
    if (await createAndUploadFile(selectedImage)) {
      try {
        final userId = await getCurrentUserId();
        final newPost = Post(
          title: titleController.text,
          description: descriptionController.text,
          image: imageKey,
          userID: userId,
          Likes: const [],
        );
        await Amplify.DataStore.save(newPost);
        setState(() {
          imagePosted = true;
        });
        if (!mounted) return;
        Provider.of<AppStateModel>(context, listen: false).setFeedLoaded(false);
      } on DataStoreException catch (e) {
        print('Error: ${e.message}');
      }
    }
  }

  Future<void> deletePostWithId() async {
    final oldPosts = await Amplify.DataStore.query(Post.classType);
    final oldPost = oldPosts.first;
    try {
      await Amplify.DataStore.delete(oldPost);
      print('Deleted a post ${oldPost.id}');
    } on DataStoreException catch (e) {
      print('Delete failed: $e');
    }
  }

  Widget postedState() {
    if (imagePosted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.lightGreen,
          ),
          Text('Image successfully posted.',
              style: Theme.of(context).textTheme.titleLarge),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text('View in Feed'),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: pickImage,
            child: const Text('Select Photo'),
          ),
          selectedImage == null
              ? const SizedBox()
              : Image.file(
                  selectedImage,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Post Title'),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            maxLength: 200,
            decoration: const InputDecoration(hintText: 'Post Description'),
          ),
          ElevatedButton(
            onPressed: savePost,
            child: const Text('Post'),
          ),
          // ElevatedButton(
          //   onPressed: deletePostWithId,
          //   child: const Text('get data'),
          // ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: postedState(),
    );
  }
}
