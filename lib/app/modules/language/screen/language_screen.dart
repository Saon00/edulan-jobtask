import 'package:eduline/app/core/app_size.dart';
import 'package:eduline/app/core/colors.dart';
import 'package:eduline/app/modules/language/controller/language_controller.dart';
import 'package:eduline/app/modules/language/model/language_model.dart';
import 'package:eduline/app/modules/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageController languageController = Get.put(LanguageController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(getWidth(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getWidth(50)),
            // Back button
            InkWell(
              onTap: () => Get.back(),
              splashColor: AppColors.greyColor.withAlpha(100),
              borderRadius: BorderRadius.circular(getWidth(25)),
              child: Container(
                width: getWidth(45),
                height: getWidth(45),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.greyColor.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textColor,
                  size: getWidth(20),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Title
            Text(
              "What is Your Mother Language",
              style: TextStyle(
                fontSize: getWidth(20),
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: getHeight(16)),

            // Description with email
            Center(
              child: Text(
                "Discover what is a podcast description and podcast summary.",
                style: TextStyle(
                  fontSize: getWidth(16),
                  color: AppColors.descriptionTextColor,
                ),
              ),
            ),

            // Language list
            Expanded(
              child: ListView.builder(
                itemCount: LanguageModel.languages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: getWidth(3)),
                    child: Obx(
                      () => InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          languageController.currentIndex(index);
                        },
                        child: Card(
                          elevation:
                              languageController.selectedIndex.value == index
                                  ? 2
                                  : 0,
                          color:
                              languageController.selectedIndex.value == index
                                  ? AppColors.tealColor.withAlpha(300)
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(getWidth(10)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidth(10),
                              vertical: getWidth(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      LanguageModel.languages[index].flag,
                                      style: TextStyle(fontSize: getWidth(30)),
                                    ),
                                    SizedBox(width: getWidth(10)),
                                    Text(
                                      LanguageModel.languages[index].name,
                                      style: TextStyle(
                                        fontSize: getWidth(18),
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      getWidth(20),
                                    ),
                                    color:
                                        languageController
                                                    .selectedIndex
                                                    .value ==
                                                index
                                            ? AppColors.skyblueColor
                                            : AppColors.greyColor.withAlpha(60),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(getWidth(8)),
                                    child: Row(
                                      children: [
                                        languageController
                                                    .selectedIndex
                                                    .value ==
                                                index
                                            ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: getWidth(20),
                                            )
                                            : const SizedBox.shrink(),
                                        Text(
                                          languageController
                                                      .selectedIndex
                                                      .value ==
                                                  index
                                              ? "Selected"
                                              : "Select",
                                          style: TextStyle(
                                            color:
                                                languageController
                                                            .selectedIndex
                                                            .value ==
                                                        index
                                                    ? Colors.white
                                                    : AppColors.greyColor,
                                            fontSize: getWidth(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue button
            CustomButtonWidget(
              buttonText: "Continue",
              onPressed: () {
                // Handle continue action
                Get.back(); // Navigate back or to the next screen
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
