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
import 'package:mission_dmc/screens/screen_parts/pdf_viewPage.dart'; // For PDF viewer
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // For YouTube player
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class FilteredExamListView extends StatefulWidget {
  const FilteredExamListView({
    super.key,
    required this.categoryData,
  });
  
  final dynamic categoryData;

  @override
  State<FilteredExamListView> createState() => _FilteredExamListViewState();
}

class _FilteredExamListViewState extends State<FilteredExamListView>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find();
  
  List<dynamic> _allItems = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Filter options
  String? _selectedBoardBook;
  String? _selectedBoardSection;
  String? _selectedBoardName;
  String? _selectedBoardYear;
  
  // API fetched data
  Map<String, String> _boardBooks = {};
  Map<String, String> _boardSections = {};
  Map<String, String> _boardNames = {};
  Map<String, String> _boardYears = {};
  
  // Loading states for dropdowns
  bool _isLoadingBooks = true;
  bool _isLoadingSections = true;
  bool _isLoadingNames = true;
  bool _isLoadingYears = true;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Fetch all dropdown data first
    await Future.wait([
      _fetchBoardBooks(),
      _fetchBoardSections(),
      _fetchBoardNames(),
      _fetchBoardYears(),
    ]);
    
    // Set default selections after fetching data
    _selectedBoardBook = "";
    _selectedBoardSection = "";
    _selectedBoardName = "";
    _selectedBoardYear = "";
    
    // Fetch CQ data
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
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-books/cq/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Books API Response: $data');
        
        Map<String, String> bookMap = {
          "": "বই" // Default option
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

  Future<void> _fetchBoardSections() async {
    try {
      setState(() {
        _isLoadingSections = true;
      });

      Map<String, String> headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Token ${_authController.token.value}',
      };

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-book-sections/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Sections API Response: $data');
        
        Map<String, String> sectionMap = {
          "": "অধ্যায়" // Default option
        };
        if (data is List) {
          for (var item in data) {
            String key = item['book_section_name'] ?? 'Unknown Section';
            String value = item['book_section_name'] ?? 'Unknown Section';
            sectionMap[key] = value;
          }
        }
        
        setState(() {
          _boardSections = sectionMap;
          _isLoadingSections = false;
        });
      } else {
        setState(() {
          _isLoadingSections = false;
        });
        print('Board Sections API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoadingSections = false;
      });
      print('Board Sections API Error: $e');
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
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-names/cq/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Names API Response: $data');
        
        Map<String, String> nameMap = {
          "": "বোর্ড" // Default option
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
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/board-years/cq/'),
        headers: headers,
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Board Years API Response: $data');
        
        Map<String, String> yearMap = {
          "": "সাল" // Default option
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
      final String url = 'https://admin.examhero.xyz/api/v1/mcq-preparation/board-cq/'
          '?board_book=$_selectedBoardBook'
          '&board_book_section=$_selectedBoardSection'
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
        
        if (data['cqs'] != null && data['cqs'] is List) {
          List<dynamic> cqsData = data['cqs'];
          
          List<dynamic> transformedItems = cqsData.map((item) {
            return {
              'id': item['id'],
              'title': '${item['board_book']['book_name']} - ${item['board_book_section']['book_section_name']} - ${item['board_name']['board_name']} - ${item['board_year']['board_year']}',
              'marks': '70',
              'duration': '180',
              'question': item['question'],
              'option_one': item['option_one'],
              'option_two': item['option_two'],
              'option_three': item['option_three'],
              'option_four': item['option_four'],
              'answer': item['answer'],
              'department': item['department'],
              'student_class': item['student_class'],
              'board_book': item['board_book']['book_name'],
              'board_section': item['board_book_section']['book_section_name'],
              'board_name': item['board_name']['board_name'],
              'board_year': item['board_year']['board_year'].toString(),
              'video_link': item['video_link'], // Video link for YouTube player
              'pdf_file': item['pdf_file'], // PDF file for PDF viewer
            };
          }).toList();

          setState(() {
            _allItems = transformedItems;
            _filteredItems = List.from(_allItems);
            _isLoading = false;
          });
          
          print('Successfully loaded ${_allItems.length} CQs from API');
        } else {
          setState(() {
            _allItems = [];
            _filteredItems = [];
            _isLoading = false;
            _errorMessage = 'কোনো CQ পাওয়া যায়নি';
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

  // Check if there are any videos with links in the current filtered items
  bool _hasVideosWithLinks() {
    return _filteredItems.any((item) => 
      item['video_link'] != null && 
      item['video_link'].toString().isNotEmpty
    );
  }

  // Check if there are any PDFs with links in the current filtered items
  bool _hasPdfsWithLinks() {
    return _filteredItems.any((item) => 
      item['pdf_file'] != null && 
      item['pdf_file'].toString().isNotEmpty
    );
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
              height: size.height * .35,
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
                          Icon(Icons.filter_list, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'বোর্ড CQ',
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
                          SizedBox(width: 8),
                          // PDF List Button - Show only if there are PDFs
                          if (!_isLoading && _hasPdfsWithLinks())
                            Container(
                              height: 35,
                              child: ElevatedButton.icon(
                                onPressed: () => _handlePdfList(),
                                icon: Icon(Icons.picture_as_pdf, size: 18, color: Colors.white),
                                label: Text(
                                  'পিডিএফ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
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
                      
                      // First Row - Three Dropdowns
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
                          
                          // Board Section Dropdown
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: _isLoadingSections
                                  ? Center(child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ))
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedBoardSection,
                                        isExpanded: true,
                                        hint: Text('বিভাগ নির্বাচন করুন'),
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                        items: _boardSections.entries.map((entry) {
                                          return DropdownMenuItem<String>(
                                            value: entry.key,
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedBoardSection = newValue;
                                          });
                                          _applyFilters();
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 8),
                          
                          // Board Year Dropdown
                          Expanded(
                            child: Container(
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
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      
                      // Second Row - Board Name Dropdown
                      Container(
                        width: double.infinity,
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
                      SizedBox(height: 12),
                      
                      // Filter Apply Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ফিল্টার করুন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Content Area - Keep your existing content area the same
            Positioned(
              top: 240,
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
          child: SpinKitCubeGrid(
            color: Theme.of(context).primaryColor,
            size: 50.0,
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
              ElevatedButton(
                onPressed: _fetchData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: Text(
                  'পুনরায় চেষ্টা',
                  style: TextStyle(color: Colors.white),
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
                Icons.search_off,
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'কোনো CQ পাওয়া যায়নি',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _categoryItem({
    required dynamic data,
    required BuildContext context,
  }) {
    bool hasVideo = data['video_link'] != null && data['video_link'].toString().isNotEmpty;
    bool hasPdf = data['pdf_file'] != null && data['pdf_file'].toString().isNotEmpty;
    
    return Card(
      elevation: 8,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
                  Row(
                    children: [
                      if (hasVideo)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: EdgeInsets.only(right: 4),
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
                                size: 12,
                                color: Colors.purple,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'ভিডিও',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasPdf)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: 12,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'পিডিএফ',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
            ),
            SizedBox(height: 12),
            
            // Button row based on available media
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Video button - only if video available
                if (hasVideo)
                  Expanded(
                    child: rPrimaryElevatedButton(
                      onPressed: () => _handleVideo(data),
                      primaryColor: Colors.purple,
                      buttonText: 'ভিডিও দেখুন',
                      fontSize: 10.0,
                      borderRadius: 20,
                    ),
                  ),
                if (hasVideo && hasPdf) SizedBox(width: 8),
                // PDF button - only if PDF available
                if (hasPdf)
                  Expanded(
                    child: rPrimaryElevatedButton(
                      onPressed: () => _handlePdf(data),
                      primaryColor: Colors.blue,
                      buttonText: 'পিডিএফ দেখুন',
                      fontSize: 10.0,
                      borderRadius: 20,
                    ),
                  ),
                // If no media available, show message
                if (!hasVideo && !hasPdf)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'কোনো মিডিয়া ফাইল নেই',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handle individual video - YouTube Player
  void _handleVideo(dynamic data) {
    final videoUrl = data['video_link']?.toString() ?? '';
    if (videoUrl.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'ভিডিও লিংক পাওয়া যায়নি',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Convert URL to YouTube videoId
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) {
      Get.snackbar(
        'ত্রুটি',
        'অবৈধ ইউটিউব লিংক',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.to(() => _YouTubeVideoPlayer(
          videoId: videoId,
          title: data['title']?.toString() ?? 'ভিডিও',
        ));
  }

  // Handle individual PDF - PDF Viewer
  void _handlePdf(dynamic data) {
    final pdfUrl = data['pdf_file']?.toString() ?? '';
    if (pdfUrl.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'পিডিএফ লিংক পাওয়া যায়নি',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    Get.to(() => ShowNoticePDFView(pdfUrl: pdfUrl));
  }

  // Video list handler
  void _handleVideoList() {
    List<dynamic> videosWithLinks = _filteredItems.where((item) =>
        item['video_link'] != null && item['video_link'].toString().isNotEmpty
    ).toList();

    Get.to(() => _MediaListScreen(
      items: videosWithLinks,
      type: _MediaType.video,
      title: 'ভিডিও তালিকা',
    ));
  }

  // PDF list handler
  void _handlePdfList() {
    List<dynamic> pdfsWithLinks = _filteredItems.where((item) =>
        item['pdf_file'] != null && item['pdf_file'].toString().isNotEmpty
    ).toList();

    Get.to(() => _MediaListScreen(
      items: pdfsWithLinks,
      type: _MediaType.pdf,
      title: 'পিডিএফ তালিকা',
    ));
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'প্রিমিয়াম ফিচার',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'এই কোর্সটি আনলক করতে আপনাকে এটি কিনতে হবে।',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'বাতিল',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => PackageView(), fullscreenDialog: true);
              },
              child: const Text(
                'ঠিক আছে',
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

// YouTube Video Player Screen
class _YouTubeVideoPlayer extends StatefulWidget {
  final String videoId;
  final String title;

  const _YouTubeVideoPlayer({
    Key? key,
    required this.videoId,
    required this.title,
  }) : super(key: key);

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        forceHD: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Theme.of(context).primaryColor,
          progressColors: ProgressBarColors(
            playedColor: Theme.of(context).primaryColor,
            handleColor: Theme.of(context).primaryColorDark,
          ),
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
            ],
          );
        },
      ),
    );
  }
}

// Media List Screen
enum _MediaType { video, pdf }

class _MediaListScreen extends StatelessWidget {
  final List<dynamic> items;
  final _MediaType type;
  final String title;

  const _MediaListScreen({
    Key? key,
    required this.items,
    required this.type,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: type == _MediaType.video ? Colors.purple : Colors.blue,
                child: Icon(
                  type == _MediaType.video ? Icons.play_arrow : Icons.picture_as_pdf,
                  color: Colors.white,
                ),
              ),
              title: Text(
                item['title'] ?? 'No Title',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (type == _MediaType.video) {
                  final videoId = YoutubePlayer.convertUrlToId(item['video_link']);
                  if (videoId != null) {
                    Get.to(() => _YouTubeVideoPlayer(
                          videoId: videoId,
                          title: item['title'] ?? 'ভিডিও',
                        ));
                  }
                } else {
                  Get.to(() => ShowNoticePDFView(pdfUrl: item['pdf_file']));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
