import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:unsplash_client/unsplash_client.dart';

class StaggeredController extends GetxController {
  final client = UnsplashClient(
    settings: ClientSettings(
      credentials: AppCredentials(
        accessKey: dotenv.env['UNSPLASH_ACCESS_KEY']!,
        secretKey: dotenv.env['UNSPLASH_SECRET_KEY']!,
      ),
    ),
  );

  var photos = <Photo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRandomPhotos();
  }

  Future<void> fetchRandomPhotos() async {
    try {
      final response = await client.photos.random(count: 20).goAndGet();
      photos.assignAll(response); // assign to observable list
    } catch (e) {
      print('Error fetching photos: $e');
    }
  }
}
