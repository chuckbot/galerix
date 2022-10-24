import 'package:flutter/foundation.dart';
import '../api/galerix_api.dart';
import '../models/unsplash_image.dart';

class GalerixProvider extends ChangeNotifier {
  final List<UnsplashImage> homeImages = [];
  final List<UnsplashImage> userImages = [];

  Future<void> loadOnePageOfPhotos({
    int page = 1,
    required String urlPath,
    Map<String, dynamic>? extraQueryParameters,
    bool takeDataFromResultsAttribute = false,
    required ImagesOf imagesOf,
  }) async {
    final images = await GalerixApi().getOnePageOfPhotos(
      page: page,
      urlPath: urlPath,
      extraQueryParameters: extraQueryParameters,
      takeDataFromResultsAttribute: takeDataFromResultsAttribute,
    );
    switch (imagesOf) {
      case ImagesOf.homeScreen:
        homeImages.addAll(images);
        break;
      case ImagesOf.anUser:
        userImages.addAll(images);
        break;
      default:
    }
    notifyListeners();
  }
}

enum ImagesOf { homeScreen, anUser }
