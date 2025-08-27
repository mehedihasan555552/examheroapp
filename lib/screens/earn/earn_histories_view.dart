import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/package_controller.dart';
import 'package:mission_dmc/screens/profile/profile_screen.dart';

class EarnHistoriesView extends StatefulWidget {
  const EarnHistoriesView({super.key});

  @override
  _EarnHistoriesViewState createState() => _EarnHistoriesViewState();
}

class _EarnHistoriesViewState extends State<EarnHistoriesView> {
  final PackageController _packageController = Get.put(PackageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _packageController.loadEarningHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _packageController.loadingEarningHistoryList.value,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Earn by Referring'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Obx(
            () => _packageController.listEarningHistory.isEmpty
                ? const Center(
                    child: Text(
                      'No history available',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _packageController.listEarningHistory.length,
                    itemBuilder: (context, index) {
                      dynamic data =
                          _packageController.listEarningHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              onTap: () => Get.to(() => ProfileScreen(
                                    userId: data['referred_user_profile']
                                        ['user']['uid'],
                                  )),
                              leading: data['referred_user_profile']
                                          ['profile_image'] ==
                                      null
                                  ? const CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      backgroundImage: AssetImage(
                                          'assets/default/profile.jpg'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              data['referred_user_profile']
                                                  ['profile_image']),
                                    ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['referred_user_profile']
                                      ['full_name']),
                                  Text(
                                    'Earn: ${data['earn_amount']} BDT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                // '27th Aug, 2022',
                                DateFormat.yMMMd().add_jm().format(
                                    DateTime.parse(data['datetime']).toLocal()),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
