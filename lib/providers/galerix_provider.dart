import 'package:flutter/foundation.dart';
import '../api/galerix_api.dart';
import '../models/unsplash_image.dart';

class GalerixProvider extends ChangeNotifier {
  final List<UnsplashImage> images = [];

  void loadHomeImages([int page = 0]) {
    GalerixApi().getRandomImages(page: page).then((images) {
      this.images.addAll(images);
      notifyListeners();
    });
  }
}
