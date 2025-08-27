import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/inner_page_header.dart';
import 'package:mission_dmc/screens/mcq_preparation/exam_list_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/section_list_view.dart';

class SubjectListView extends StatelessWidget {
  SubjectListView({super.key});
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: kPrimaryColor,
              height: size.height * .23,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //main colum started
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                //Container For header icon and text
                InnerHeader(
                  text: 'Subject Wise Preparation',
                  image: Image.asset(
                    'assets/icons/centraltest.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
              ],
            ),
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: _mcqPreparationController.fetchSubjectList(),
                  builder: (context, snapshot) {
                    // Checking if future is resolved
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error occurred',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // Extracting data from snapshot object
                        final listData = snapshot.data as List<dynamic>;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listData.length,
                          itemBuilder: ((context, index) => _subjectItem(
                                data: listData[index],
                                context: context,
                              )),
                        );
                      }
                    }
                    // Displaying LoadingSpinner to indicate waiting state
                    return Center(
                      child: SpinKitCubeGrid(
                        color: Theme.of(context).primaryColor,
                        size: 50.0,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _subjectItem({
    required dynamic data,
    required BuildContext context,
  }) =>
      Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //set border radius more than 50% of height and width to make circle
        ),
        child: ListTile(
          onTap: () => Get.to(() => SectionListView(subjectData: data)),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          horizontalTitleGap: 4,
          leading: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(80),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: data['subject_image'],
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
          title: Text(
            data['title'],
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
      );
}
