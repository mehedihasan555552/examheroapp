import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller.dart';

class RefunPolicyView extends GetView {
  final AuthController authController;
  const RefunPolicyView({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Refund Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Icon and Title
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.monetization_on_rounded,
                        size: 48,
                        color: Colors.green[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Refund & Returns',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your satisfaction is our priority',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Content Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.1),
                              Colors.green.withOpacity(0.05),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.policy_rounded,
                              color: Colors.green[600],
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Refund Policy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Content Text
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "${authController.contentList.length > 1 ? authController.contentList[1]["content"] ?? "Loading refund policy..." : "Please wait while we load the refund policy..."}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Key Refund Points Section
                      _buildRefundPointsSection(context),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              
              
              SizedBox(height: 24),
              
              // Footer Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.8),
                      Colors.green[600]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Customer Satisfaction Guarantee',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are committed to providing quality service and ensuring customer satisfaction with our refund policy.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '5-Day Refund Window',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefundPointsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Refund Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 12),
        
        _buildRefundPoint(
          'Time Limit',
          'Refund requests must be made within 5 days of purchase',
          Icons.timer_rounded,
          Colors.blue,
        ),
        
        _buildRefundPoint(
          'Written Request',
          'All refund requests must be submitted in writing via email',
          Icons.email_rounded,
          Colors.orange,
        ),
        
        _buildRefundPoint(
          'Product Condition',
          'Items must be unused and in original packaging for hard goods',
          Icons.inventory_2_rounded,
          Colors.purple,
        ),
        
        _buildRefundPoint(
          'Digital/Subscription',
          'Special refund terms apply to digital and subscription services',
          Icons.cloud_download_rounded,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildRefundPoint(String title, String description, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange[600],
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const htmlData = r"""
<div dir="auto">Refund Policy<div dir="auto"><br></div><div dir="auto">Last modified: 11/08/2022</div><div dir="auto"><br></div><div dir="auto">Introduction:</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">"Target DMC " is committed to your satisfaction. If you have purchased digital/hard goods/subscription from  Target DMC and are unhappy with the product received, you may be eligible for a refund/partial refund if requested within 5 days of the original purchase date.</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">Refunds of Hard Goods:</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">To be eligible for return and refund, the following steps must be taken:</div><div dir="auto"><br></div><div dir="auto">Refund must be requested in writing by contacting <a href="mailto:hridoyhasanvai@gmail.com" target="_blank">hridoyhasanvai@gmail.com</a></div><div dir="auto">Request of refund must be made within 5 days of the original purchase date</div><div dir="auto">Hard goods must be returned to Target DMC immediately, according to the instructions you will receive once contacting <a href="mailto:hridoyhasanvai@gmail.com" target="_blank">hridoyhasanvai@gmail.com</a> as directed in step 1.</div><div dir="auto">The item(s) must be unused and returned in the original packaging, in like-new, or re-sellable condition, as determined in Target DMC sole, reasonable discretion.</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">Non-returnable Items:</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">The following items are non-returnable as stated at the time of purchase on It is very helpful for students.</div><div dir="auto"><br></div><div dir="auto">Item</div><div dir="auto">Item</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">Refunds of Digital/Subscription Based Goods:</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">To be eligible for a refund on any digital/subscription based goods, the following steps must be taken:</div><div dir="auto"><br></div><div dir="auto">Refund must be requested in writing by contacting <a href="mailto:hridoyhasanvai@gmail.com" target="_blank">hridoyhasanvai@gmail.com</a></div><div dir="auto">Request of refund must be made within 5 days of the original purchase date</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">Target DMC is committed to its consumers, and while we stand by our policy as written above, we also want to understand how we can resolve the dissatisfaction and better understand how we can serve you. Please contact Target DMC at <a href="mailto:hridoyhasanvai@gmail.com" target="_blank">hridoyhasanvai@gmail.com</a> for any questions related to our policy, or simply to let us know how we can help.&nbsp;</div><div dir="auto"><br></div><div dir="auto"><br></div><div dir="auto">Target DMC</div><div dir="auto">sreebordi,sherpur,mymensing,<wbr>Bangladesh, sherpur</div><div dir="auto">sreebordi ( Post code- 2100 ), Bangladesh&nbsp;</div><div dir="auto"><a href="mailto:hridoyhasanvai@gmail.com" target="_blank">hridoyhasanvai@gmail.com</a></div><div dir="auto">01926005478</div><div dir="auto">It is very helpful for students.</div></div>
""";
