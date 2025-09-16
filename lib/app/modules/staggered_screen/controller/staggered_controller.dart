import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  var isLoading = false.obs;

  Future<void> fetchRandomPhotos({int total = 100, int batchSize = 10}) async {
    try {
      isLoading.value = true;
      // EasyLoading.show(status: 'Loading photos...');

      photos.clear(); // clear old data

      for (int i = 0; i < total; i += batchSize) {
        final response =
            await client.photos.random(count: batchSize).goAndGet();
        photos.addAll(response);

        // trigger UI update gradually
        await Future.delayed(Duration(milliseconds: 300));
      }
    } catch (e) {
      debugPrint('Error fetching photos: $e');
      EasyLoading.showError('Failed to load photos');
    } finally {
      isLoading.value = false;
      // EasyLoading.dismiss();
    }
  }

  // Future<void> fetchRandomPhotos() async {
  //   try {
  //     isLoading.value = true;
  //     EasyLoading.show(status: 'Loading photos...');

  //     final response = await client.photos.random(count: 10).goAndGet();
  //     photos.assignAll(response);
  //   } catch (e) {
  //     debugPrint('Error fetching photos: $e');
  //     EasyLoading.showError('Failed to load photos');
  //   } finally {
  //     isLoading.value = false;
  //     EasyLoading.dismiss();
  //   }
  // }

  // Future<void> fetchRandomPhotos() async {
  //   try {
  //     final response = await client.photos.random(count: 20).goAndGet();
  //     photos.assignAll(response);
  //   } catch (e) {
  //     debugPrint('Error fetching photos: $e');
  //   }
  // }
}
