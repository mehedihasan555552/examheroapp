import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/inner_page_header.dart';
import 'package:mission_dmc/screens/mcq_preparation/mcq_list_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/package_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/video_list_screen.dart'; // Add this
import 'package:mission_dmc/screens/mcq_preparation/video_player_screen.dart'; // Add this
import 'package:mission_dmc/widgets/reusable_widgets.dart';


class BoardMCQListView extends StatefulWidget {
  const BoardMCQListView({
    super.key,
    required this.categoryData,
  });
  
  final dynamic categoryData;


  @override
  State<BoardMCQListView> createState() => _BoardMCQListViewState();
}


class _BoardMCQListViewState extends State<BoardMCQListView> {
  final AuthController _authController = Get.find();
  
  List<dynamic> _allItems = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Filter options
  String? _selectedBoardBook;
  String? _selectedBoardName;
  String? _selectedBoardYear;
  
  // API fetched data - Changed to store name as key and display name as value
  Map<String, String> _boardBooks = {};
  Map<String, String> _boardNames = {};
  Map<String, String> _boardYears = {};
  
  // Loading states for dropdowns
  bool _isLoadingBooks = true;
  bool _isLoadingNames = true;
  bool _isLoadingYears = true;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Check if there are any videos with links in the current filtered items
  bool _hasVideosWithLinks() {
    return _filteredItems.any((item) => 
      item['video_link'] != null && 
      item['video_link'].toString().isNotEmpty
    );
  }


  Future<void> _initializeData() async {
    // Fetch all dropdown data first
    await Future.wait([
      _fetchBoardBooks(),
      _fetchBoardNames(),
      _fetchBoardYears(),
    ]);
    
    // Set default selections after fetching data
    if (_boardBooks.isNotEmpty) {
      _selectedBoardBook = _boardBooks.keys.first;
    }
    if (_boardNames.isNotEmpty) {
      _selectedBoardName = _boardNames.keys.first;
    }
    if (_boardYears.isNotEmpty) {
      _selectedBoardYear = _boardYears.keys.first;
    }
    
    // Fetch MCQ data
    _fetchData();
  }


  Future<void> _fetchBoardBooks() async {
    try {
      setState(() {
        _isLoadingBooks = true;
      });


      Map<String, String> headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${_authController.token.value}',
      };


      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-books/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Books API Response: $data');
        
        Map<String, String> bookMap = {
            "": "বই" // Default key-value pair
          };
          if (data is List) {
            for (var item in data) {
              String key = item['book_name'] ?? 'Unknown Book';
              String value = item['book_name'] ?? 'Unknown Book';
              bookMap[key] = value;
            }
          }


        
        setState(() {
          _boardBooks = bookMap;
          _isLoadingBooks = false;
        });
      } else {
        setState(() {
          _isLoadingBooks = false;
        });
        print('Board Books API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoadingBooks = false;
      });
      print('Board Books API Error: $e');
    }
  }


  Future<void> _fetchBoardNames() async {
    try {
      setState(() {
        _isLoadingNames = true;
      });


      Map<String, String> headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${_authController.token.value}',
      };


      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-names/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Names API Response: $data');
        
        Map<String, String> nameMap = {
          "": "বোর্ড" // Default key-value pair (key can also be "default" or "" as you need)
        };
        if (data is List) {
          for (var item in data) {
            String key = item['board_name'] ?? 'Unknown Board';
            String value = item['board_name'] ?? 'Unknown Board';
            nameMap[key] = value;
          }
        }


        
        setState(() {
          _boardNames = nameMap;
          _isLoadingNames = false;
        });
      } else {
        setState(() {
          _isLoadingNames = false;
        });
        print('Board Names API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoadingNames = false;
      });
      print('Board Names API Error: $e');
    }
  }


  Future<void> _fetchBoardYears() async {
    try {
      setState(() {
        _isLoadingYears = true;
      });


      Map<String, String> headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${_authController.token.value}',
      };


      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-years/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Years API Response: $data');
        
        Map<String, String> yearMap = {
            "": "সাল" // Default key-value pair
          };
          if (data is List) {
            for (var item in data) {
              String key = item['board_year']?.toString() ?? 'Unknown Year';
              String value = item['board_year']?.toString() ?? 'Unknown Year';
              yearMap[key] = value;
            }
          }


        
        setState(() {
          _boardYears = yearMap;
          _isLoadingYears = false;
        });
      } else {
        setState(() {
          _isLoadingYears = false;
        });
        print('Board Years API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoadingYears = false;
      });
      print('Board Years API Error: $e');
    }
  }


  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });


    try {
      // Now using names instead of IDs in the API call
      final String url = 'https://admin.examhero.xyz/api/v1/mcq-preparation/board-mcq/'
          '?board_book=$_selectedBoardBook'
          '&board_name=$_selectedBoardName'
          '&board_year=$_selectedBoardYear';


      print('API Request URL: $url');


      Map<String, String> headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${_authController.token.value}',
      };


      print('Using auth token: ${_authController.token.value.substring(0, 10)}...');


      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(Duration(seconds: 30));


      print('API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Raw API Response: $data');
        
        if (data['mcqs'] != null && data['mcqs'] is List) {
          List<dynamic> mcqsData = data['mcqs'];
          
          List<dynamic> transformedItems = mcqsData.map((item) {
            String boardName = item['board_name']['board_name'] ?? 'Unknown';
            String boardBook = item['board_book']['book_name'] ?? 'Unknown';
            String boardYear = item['board_year']['board_year']?.toString() ?? 'Unknown';
            
            String titleString = '$boardBook বই - $boardName বোর্ড  - $boardYear';


            return {
              'id': item['id'],
              'title': titleString,
              'marks': item['marks']?.toString() ?? '100',
              'duration': item['duration']?.toString() ?? '120',
              'question': item['question'],
              'option_one': item['option_one'],
              'option_two': item['option_two'],
              'option_three': item['option_three'],
              'option_four': item['option_four'],
              'answer': item['answer'],
              'explanation': item['explanation'],
              'board_book': item['board_book']['book_name'],
              'board_name': item['board_name']['board_name'],
              'board_year': item['board_year']['board_year'].toString(),
              'subject': item['subject'],
              'chapter': item['chapter'],
              'topic': item['topic'],
              'video_link': item['video_link'], // Added video_link
            };
          }).toList();


          setState(() {
            _allItems = transformedItems;
            _filteredItems = List.from(_allItems);
            _isLoading = false;
          });
          
          print('Successfully loaded ${_allItems.length} MCQs from API');
        } else {
          setState(() {
            _allItems = [];
            _filteredItems = [];
            _isLoading = false;
            _errorMessage = 'কোনো MCQ পাওয়া যায়নি';
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'অনুমতি নেই। দয়া করে লগইন করুন';
        });
      } else if (response.statusCode == 403) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'এই ফিচার ব্যবহারের অনুমতি নেই';
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'সার্ভার সমস্যা। অনুগ্রহ করে পরে আবার চেষ্টা করুন';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ডেটা লোড করতে সমস্যা হয়েছে (${response.statusCode})';
        });
        print('API Error Response: ${response.body}');
      }
    } catch (e) {
      print('API Error: $e');
      setState(() {
        _isLoading = false;
        if (e.toString().contains('TimeoutException')) {
          _errorMessage = 'সংযোগ সময়সীমা শেষ। ইন্টারনেট সংযোগ পরীক্ষা করুন';
        } else {
          _errorMessage = 'ইন্টারনেট সংযোগ পরীক্ষা করুন';
        }
      });
    }
  }


  void _applyFilters() {
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: kPrimaryColor,
              height: size.height * .32,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      // Title for filters
                      Row(
                        children: [
                          Icon(Icons.tune, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'বোর্ড MCQ ফিল্টার',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          // Video List Button - Show only if there are videos
                          if (!_isLoading && _hasVideosWithLinks())
                            Container(
                              height: 35,
                              child: ElevatedButton.icon(
                                onPressed: () => _handleVideoList(),
                                icon: Icon(Icons.video_library, size: 18, color: Colors.white),
                                label: Text(
                                  'ভিডিও',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      
                      // First Row - Board Book and Board Name
                      Row(
                        children: [
                          // Board Book Dropdown
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: _isLoadingBooks
                                  ? Center(child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ))
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedBoardBook,
                                        isExpanded: true,
                                        hint: Text('বই নির্বাচন করুন'),
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                        items: _boardBooks.entries.map((entry) {
                                          return DropdownMenuItem<String>(
                                            value: entry.key,
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedBoardBook = newValue;
                                          });
                                          _applyFilters();
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 8),
                          
                          // Board Name Dropdown
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: _isLoadingNames
                                  ? Center(child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ))
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedBoardName,
                                        isExpanded: true,
                                        hint: Text('বোর্ড নির্বাচন করুন'),
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                        items: _boardNames.entries.map((entry) {
                                          return DropdownMenuItem<String>(
                                            value: entry.key,
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedBoardName = newValue;
                                          });
                                          _applyFilters();
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      
                      // Second Row - Board Year
                      Container(
                        width: double.infinity,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _isLoadingYears
                            ? Center(child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ))
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedBoardYear,
                                  isExpanded: true,
                                  hint: Text('বছর নির্বাচন করুন'),
                                  style: TextStyle(color: Colors.black, fontSize: 14),
                                  items: _boardYears.entries.map((entry) {
                                    return DropdownMenuItem<String>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedBoardYear = newValue;
                                    });
                                    _applyFilters();
                                  },
                                ),
                              ),
                      ),
                      SizedBox(height: 12),
                      
                      // Filter Apply Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: _applyFilters,
                          icon: Icon(Icons.search, color: Colors.white),
                          label: Text(
                            'অনুসন্ধান করুন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Content Area
            Positioned(
              top: 220,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Results count
                        if (!_isLoading && _filteredItems.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.green, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'মোট ${_filteredItems.length}টি MCQ পাওয়া গেছে',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  if (_hasVideosWithLinks()) ...[
                                    SizedBox(width: 12),
                                    Icon(Icons.video_library, color: Colors.purple, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '${_filteredItems.where((item) => item['video_link'] != null && item['video_link'].toString().isNotEmpty).length}টি ভিডিও',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple[700],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        
                        // Data Display
                        _buildDataDisplay(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDataDisplay() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              SpinKitWave(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
              SizedBox(height: 20),
              Text(
                'MCQ লোড করা হচ্ছে...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }


    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchData,
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'পুনরায় চেষ্টা',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }


    if (_filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'কোনো MCQ পাওয়া যায়নি',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'অন্য ফিল্টার দিয়ে চেষ্টা করুন',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }


    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) => _categoryItem(
        data: _filteredItems[index],
        context: context,
        index: index,
      ),
    );
  }


  Widget _categoryItem({
    required dynamic data,
    required BuildContext context,
    required int index,
  }) {
    bool hasVideo = data['video_link'] != null && data['video_link'].toString().isNotEmpty;
    
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/icons/centraltest.png',
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['title'] ?? 'কোনো শিরোনাম নেই',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (hasVideo)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              size: 14,
                              color: Colors.purple,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'ভিডিও',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'নম্বর: ${data['marks'] ?? 'N/A'} | সময়: ${data['duration'] ?? 'N/A'} মিনিট',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              
              // Dynamic action buttons based on video availability
              hasVideo 
                  ? Row(
                      children: [
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleStartExam(data),
                            primaryColor: Theme.of(context).primaryColor,
                            buttonText: 'পরীক্ষা শুরু',
                            fontSize: 10.0,
                            borderRadius: 25,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleStudy(data),
                            primaryColor: Colors.green,
                            buttonText: 'অধ্যয়ন',
                            fontSize: 10.0,
                            borderRadius: 25,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleVideo(data),
                            primaryColor: Colors.purple,
                            buttonText: 'ভিডিও',
                            fontSize: 10.0,
                            borderRadius: 25,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleRanking(data),
                            primaryColor: Colors.orange,
                            buttonText: 'র‍্যাঙ্কিং',
                            fontSize: 10.0,
                            borderRadius: 25,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleStartExam(data),
                            primaryColor: Theme.of(context).primaryColor,
                            buttonText: 'পরীক্ষা শুরু',
                            fontSize: 13.0,
                            borderRadius: 25,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleStudy(data),
                            primaryColor: Colors.green,
                            buttonText: 'অধ্যয়ন',
                            fontSize: 13.0,
                            borderRadius: 25,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: rPrimaryElevatedButton(
                            onPressed: () => _handleRanking(data),
                            primaryColor: Colors.orange,
                            buttonText: 'র‍্যাঙ্কিং',
                            fontSize: 13.0,
                            borderRadius: 25,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }


  void _handleStartExam(dynamic data) {
    if (int.tryParse(_authController.profile.value.package.toString()) == null) {
      _showPremiumDialog();
    } else {
      Get.to(() => MCQListView(
            isStartExam: true,
            isSubjectWise: false,
            testId: 0,
            mcqTest: data,
          ));
    }
  }


  
  


  void _handleStudy(dynamic data) {
    if (int.tryParse(_authController.profile.value.package.toString()) == null) {
      _showPremiumDialog();
    } else {
      Get.to(() => MCQListView(
            isStartExam: false,
            isSubjectWise: false,
            testId: 0,
            mcqTest: data,
          ));
    }
  }


  void _handleRanking(dynamic data) {
    Get.to(() => RankingScreen(
          isSubjectWise: false,
          mcqTest: data,
        ));
  }

  // New method to handle individual video
  void _handleVideo(dynamic data) {
    if (int.tryParse(_authController.profile.value.package.toString()) == null) {
      _showPremiumDialog();
    } else {
      if (data['video_link'] != null && data['video_link'].toString().isNotEmpty) {
        Get.to(() => VideoPlayerScreen(
          videoUrl: data['video_link'],
          title: data['title'] ?? 'ভিডিও',
        ));
      } else {
        Get.snackbar(
          'ত্রুটি',
          'ভিডিও লিংক পাওয়া যায়নি',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // New method to handle video list
  void _handleVideoList() {
    if (int.tryParse(_authController.profile.value.package.toString()) == null) {
      _showPremiumDialog();
    } else {
      Get.to(() => VideoListScreen(filteredItems: _filteredItems));
    }
  }



//   void _handleVideo(dynamic data) {
//   // Comment out the premium check for testing
//   // if (int.tryParse(_authController.profile.value.package.toString()) == null) {
//   //   _showPremiumDialog();
//   // } else {
//     if (data['video_link'] != null && data['video_link'].toString().isNotEmpty) {
//       Get.to(() => VideoPlayerScreen(
//         videoUrl: data['video_link'],
//         title: data['title'] ?? 'ভিডিও',
//       ));
//     } else {
//       Get.snackbar(
//         'ত্রুটি',
//         'ভিডিও লিংক পাওয়া যায়নি',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   // }
// }

// void _handleVideoList() {
//   // Comment out the premium check for testing
//   // if (int.tryParse(_authController.profile.value.package.toString()) == null) {
//   //   _showPremiumDialog();
//   // } else {
//     Get.to(() => VideoListScreen(filteredItems: _filteredItems));
//   // }
// }


  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'প্রিমিয়াম ফিচার',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'এই MCQ সেট আনলক করতে আপনাকে প্রিমিয়াম প্যাকেজ কিনতে হবে।',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'বাতিল',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => PackageView(), fullscreenDialog: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'প্যাকেজ দেখুন',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
