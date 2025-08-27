import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/auth_controller.dart';

class PrivacyPolicyView extends GetView {
  final AuthController authController;
  const PrivacyPolicyView({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.privacy_tip_rounded,
                        size: 48,
                        color: Colors.blue[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Privacy Protection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your privacy matters to us',
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
                              Colors.blue.withOpacity(0.1),
                              Colors.blue.withOpacity(0.05),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security_rounded,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600],
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
                          "${authController.contentList.length > 2 ? authController.contentList[2]["content"] ?? "Loading privacy policy..." : "Please wait while we load the privacy policy..."}",
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
                      
                      // Key Points Section
                      _buildKeyPointsSection(context),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Footer Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.blue[600]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Data Protection Commitment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are committed to protecting your personal information and respecting your privacy preferences.',
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
                            'Effective: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
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

  Widget _buildKeyPointsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Privacy Points',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 12),
        
        _buildPrivacyPoint(
          'Data Collection',
          'We collect minimal personal information necessary for app functionality',
          Icons.data_usage_rounded,
          Colors.green,
        ),
        
        _buildPrivacyPoint(
          'Information Use',
          'Your data is used only to provide and improve our services',
          Icons.info_outline_rounded,
          Colors.blue,
        ),
        
        _buildPrivacyPoint(
          'Data Security',
          'We use industry-standard security measures to protect your information',
          Icons.security_rounded,
          Colors.orange,
        ),
        
        _buildPrivacyPoint(
          'Third Parties',
          'We do not share your personal information without your consent',
          Icons.people_outline_rounded,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildPrivacyPoint(String title, String description, IconData icon, Color color) {
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
}

const htmlData = r"""
<div dir="auto">**Privacy Policy**<div dir="auto"><br></div><div dir="auto">Easy education Ltd.built the Target DMC app as a Commercial app. This SERVICE is provided by Easy education and is intended for use as is.</div><div dir="auto"><br></div><div dir="auto">This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.</div><div dir="auto"><br></div><div dir="auto">If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.</div><div dir="auto"><br></div><div dir="auto">The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Target DMC unless otherwise defined in this Privacy Policy.</div><div dir="auto"><br></div><div dir="auto">**Information Collection and Use**</div><div dir="auto"><br></div><div dir="auto">For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to picture,mail,phon number. The information that we request will be retained by us and used as described in this privacy policy.</div><div dir="auto"><br></div><div dir="auto">The app does use third-party services that may collect information used to identify you.</div><div dir="auto"><br></div><div dir="auto">Link to the privacy policy of third-party service providers used by the app</div><div dir="auto"><br></div><div dir="auto">*   [Google Play Services](<a href="https://www.google.com/policies/privacy/" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://www.google.com/policies/privacy/&amp;source=gmail&amp;ust=1668256050997000&amp;usg=AOvVaw2Qpp4pzCw_vUTFFatf3I3Q">https://www.google.<wbr>com/policies/privacy/</a>)</div><div dir="auto">*   [Google Analytics for Firebase](<a href="https://firebase.google.com/policies/analytics" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://firebase.google.com/policies/analytics&amp;source=gmail&amp;ust=1668256050997000&amp;usg=AOvVaw2-7ARqNfXZkG7NC9EeG7hj">https://firebase.<wbr>google.com/policies/analytics</a>)</div><div dir="auto">*   [Firebase Crashlytics](<a href="https://firebase.google.com/support/privacy/" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://firebase.google.com/support/privacy/&amp;source=gmail&amp;ust=1668256050997000&amp;usg=AOvVaw2jtXzRwRsGzTqNC645dis1">https://firebase.<wbr>google.com/support/privacy/</a>)</div><div dir="auto"><br></div><div dir="auto">**Log Data**</div><div dir="auto"><br></div><div dir="auto">We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.</div><div dir="auto"><br></div><div dir="auto">**Cookies**</div><div dir="auto"><br></div><div dir="auto">Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.</div><div dir="auto"><br></div><div dir="auto">This Service does not use these "cookies" explicitly. However, the app may use third-party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.</div><div dir="auto"><br></div><div dir="auto">**Service Providers**</div><div dir="auto"><br></div><div dir="auto">We may employ third-party companies and individuals due to the following reasons:</div><div dir="auto"><br></div><div dir="auto">*   To facilitate our Service;</div><div dir="auto">*   To provide the Service on our behalf;</div><div dir="auto">*   To perform Service-related services; or</div><div dir="auto">*   To assist us in analyzing how our Service is used.</div><div dir="auto"><br></div><div dir="auto">We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.</div><div dir="auto"><br></div><div dir="auto">**Security**</div><div dir="auto"><br></div><div dir="auto">We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.</div><div dir="auto"><br></div><div dir="auto">**Links to Other Sites**</div><div dir="auto"><br></div><div dir="auto">This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.</div><div dir="auto"><br></div><div dir="auto">**Children's Privacy**</div><div dir="auto"><br></div><div dir="auto">These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.</div><div dir="auto"><br></div><div dir="auto">**Changes to This Privacy Policy**</div><div dir="auto"><br></div><div dir="auto">We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.</div><div dir="auto"><br></div><div dir="auto">This policy is effective as of 2022-11-07</div><div dir="auto"><br></div><div dir="auto">**Contact Us**</div><div dir="auto"><br></div><div dir="auto">If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at 01926005478 OR <a href="mailto:targetdmc1@gmail.com" target="_blank">targetdmc1@gmail.com</a></div></div>
""";
