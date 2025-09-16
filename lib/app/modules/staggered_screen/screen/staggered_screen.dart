import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../controller/staggered_controller.dart';

class StaggeredScreen extends StatelessWidget {
  StaggeredScreen({super.key});
  final controller = Get.put(StaggeredController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Random Unsplash Images'),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.photos.isEmpty) {
                  // show EasyLoading only for first-time load
                  return SizedBox.shrink();
                }

                if (controller.photos.isEmpty) {
                  return Center(child: Text("No photos yet"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Clear and fetch new set of photos
                    await controller.fetchRandomPhotos(
                      total: 100,
                      batchSize: 10,
                    );
                  },
                  child: MasonryGridView.builder(
                    physics:
                        const AlwaysScrollableScrollPhysics(), // ensures pull works even if content small
                    itemCount: controller.photos.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    itemBuilder: (context, index) {
                      final photo = controller.photos[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            photo.urls.small.toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 150,
                                color: Colors.grey.shade300,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),

            /*
            // Optional loading indicator while fetching
            Obx(() {
              if (controller.photos.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox.shrink(); // Hide if photos loaded
            }),
            

            Expanded(
              child: Obx(
                () => MasonryGridView.builder(
                  itemCount: controller.photos.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final photo = controller.photos[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photo.urls.small
                              .toString(), // Use .small for performance
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
