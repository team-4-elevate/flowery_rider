import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/widget/dialog_utils.dart';
import 'package:get_it/get_it.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      GetIt.I<DialogUtils>().showSnackBar(
        textColor: AppColors.error,
        message: 'Error selecting image: $e',
        context: context,
      );
      return null;
    }
  }

  void addImageToCollection(
      File newFile, List<File> collection, ValueSetter<File?> setPrimaryImage) {
    if (collection.isEmpty) {
      collection.add(newFile);
    } else {
      bool isDuplicate = collection.any((file) => file.path == newFile.path);
      if (!isDuplicate) {
        collection.add(newFile);
      }
    }
    setPrimaryImage(newFile);
  }

  void clearImages(List<File> collection, ValueSetter<File?> setPrimaryImage) {
    collection.clear();
    setPrimaryImage(null);
  }

  void removeSpecificImage(File specificFile, List<File> collection,
      File? primaryImage, ValueSetter<File?> setPrimaryImage) {
    collection.removeWhere((file) => file.path == specificFile.path);

    if (primaryImage != null && primaryImage.path == specificFile.path) {
      setPrimaryImage(collection.isNotEmpty ? collection.last : null);
    }
  }
}
