import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';

class BookMarksView extends StatefulWidget {
  const BookMarksView({super.key});


  @override
  State<BookMarksView> createState() => _BookMarksViewState();
}

class _BookMarksViewState extends State<BookMarksView> {
  BannerController bannerController = Get.find();
  dynamic _examData;
  bool isStartExam = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder(
        future: bannerController.fetchBookMarksList(),
        builder: (context, snapshot) {
          // Checking if future is resolved

          return Obx(() {
            return LoadingOverlay(
              isLoading: bannerController.isbookloading.value,
              //opacity: .6,
              progressIndicator: SpinKitCubeGrid(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: bannerController.bookMarksList.isEmpty
                        ? Center(
                            child: const Text('You have no bookmarks'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(4.0),
                            itemCount: bannerController
                                .bookMarksList['mcq_list'].length,
                            itemBuilder: ((context, index) => _mcqItem(
                                  data: bannerController
                                      .bookMarksList['mcq_list'][index],
                                  context: context,
                                  serialNumber: index + 1,
                                )),
                          ),
                  ),
                ],
              ),
            );
          });

          // Displaying LoadingSpinner to indicate waiting state
        },
      ),
    );
  }

  Widget _mcqItem(
      {required dynamic data,
      required BuildContext context,
      required int serialNumber}) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: Get.width * 0.78,
                  child: Text(
                    '$serialNumber. ${data['question']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    bannerController.addBookmarks(mcqId: data['id']);
                  },
                  icon: Obx(() => Icon(
                    bannerController.bookmarkedItems.contains(data['id'])
                        ? Icons.star_rounded // Filled star when bookmarked
                        : Icons.star_border_rounded, // Border star when not bookmarked
                    color: bannerController.bookmarkedItems.contains(data['id'])
                        ? Colors.amber // Golden color for bookmarked items
                        : Colors.grey, // Default color for non-bookmarked items
                  )),
                )

              ],
            ),
            Container(
              height: .5,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            _optionItem(data: data, optionName: 'option_one'),
            _optionItem(data: data, optionName: 'option_two'),
            _optionItem(data: data, optionName: 'option_three'),
            _optionItem(data: data, optionName: 'option_four'),
            const SizedBox(
              height: 4,
            ),
            Text('Hints: ${data['hints']}')
          ],
        ),
      ),
    );
  }

  Widget _optionItem({required dynamic data, required String optionName}) =>
      Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Icon(
            data['answer'] == optionName
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_off_outlined,
            color: data['answer'] == optionName ? Colors.green : Colors.grey,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              child: Text(
            data[optionName],
            style: TextStyle(
              color:
                  data['answer'] == optionName ? Colors.green : Colors.black87,
            ),
          )),
        ],
      );
}
