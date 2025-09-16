
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/staggered_controller.dart';

class StaggeredScreen extends StatelessWidget {
  StaggeredScreen({super.key});
  final controller = Get.put(StaggeredController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Random Unsplash Images'),

            // Optional loading indicator while fetching
            Obx(() {
              if (controller.photos.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox.shrink(); // Hide if photos loaded
            }),

            Expanded(
              child: Obx(() => MasonryGridView.builder(
                itemCount: controller.photos.length,
                gridDelegate:
                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final photo = controller.photos[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photo.urls.small.toString(), // Use .small for performance
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

