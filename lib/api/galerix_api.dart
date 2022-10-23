import 'dart:convert';
import 'package:galerix/models/unsplash_image.dart';
import 'package:http/http.dart' as http;

class GalerixApi {
  final _unsplashClientId =
      'a2f508640cb62f314e0e0763594d40aab1c858a7ef796184067c537a88b276aa';

  Future<List<UnsplashImage>> getRandomImages({int page = 0}) async {
    final url = Uri.https(
      'api.unsplash.com',
      '/photos',
      {
        'client_id': _unsplashClientId,
        'page': '$page',
      },
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body as List)
          .map((imageData) => UnsplashImage(
                id: imageData['id'],
                imageUrl: imageData['urls']['regular'],
              ))
          .toList();
    } else {
      throw Exception();
    }
  }
}
