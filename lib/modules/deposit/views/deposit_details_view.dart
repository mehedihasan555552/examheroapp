import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DepositDetailsView extends GetView {
  const DepositDetailsView({super.key, required this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['payment_method']['title']),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Receiver number: ${data['payment_method']['account_number']}'),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Sender number: ${data['sender_number']}'),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      'Amount: ${double.parse(data['amount']).toStringAsFixed(2)} BDT'),
                  const SizedBox(
                    height: 8,
                  ),
                  data['payment_method']['is_receive_transaction_id'] == true
                      ? Text('Trx ID: ${data['transaction_id']}')
                      : Container(),
                  data['payment_method']['is_receive_transaction_id'] == true
                      ? const SizedBox(
                          height: 8,
                        )
                      : Container(),
                  Text('Feedback: ${data['feedback'] ?? 'No feedback'}'),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Status: ${data['is_accepted'] == true ? 'Approved' : data['is_declined'] == true ? 'Declined' : 'Pending'}',
                    style: TextStyle(
                        color: data['is_accepted'] == true
                            ? Colors.green
                            : data['is_declined'] == true
                                ? Colors.red
                                : Colors.amber,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      'Date: ${DateFormat.yMMMd().add_jm().format(DateTime.parse(data['requested_datetime']).toLocal())}'),
                  const SizedBox(
                    height: 8,
                  ),
                  CachedNetworkImage(
                    imageUrl: data['screenshot'],
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
