import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/mcq_preparation/package_view.dart';
import 'package:mission_dmc/screens/screen_parts/pdf_viewPage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BatchCQsPage extends StatefulWidget {
  const BatchCQsPage({super.key});

  @override
  State<BatchCQsPage> createState() => _BatchCQsPageState();
}

class _BatchCQsPageState extends State<BatchCQsPage>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find();

  // Current step in the progressive disclosure
  int _currentStep = 0;
  
  // Selected values
  dynamic _selectedBook;
  dynamic _selectedSection;
  dynamic _selectedBoard;
  dynamic _selectedYear;
  
  // Data lists
  List<dynamic> _books = [];
  List<dynamic> _sections = [];
  List<dynamic> _boards = [];
  List<dynamic> _years = [];
  List<dynamic> _cqResults = [];
  
  // Loading states
  bool _isLoadingBooks = true;
  bool _isLoadingSections = false;
  bool _isLoadingBoards = false;
  bool _isLoadingYears = false;
  bool _isLoadingResults = false;
  
  // Error states
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // API Calls based on the actual API structure
  Future<void> _fetchBooks() async {
    try {
      setState(() {
        _isLoadingBooks = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/CQSearch/books/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Books API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data is List ? data : [];
          _isLoadingBooks = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load books (${response.statusCode})';
          _isLoadingBooks = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoadingBooks = false;
      });
    }
  }

  Future<void> _fetchSections(int bookId) async {
    try {
      setState(() {
        _isLoadingSections = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/CQSearch/sections/$bookId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Sections API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _sections = data is List ? data : [];
          _isLoadingSections = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load sections (${response.statusCode})';
          _isLoadingSections = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoadingSections = false;
      });
    }
  }

  Future<void> _fetchBoards(int bookId) async {
    try {
      setState(() {
        _isLoadingBoards = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/CQSearch/names/$bookId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Boards API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _boards = data is List ? data : [];
          _isLoadingBoards = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load boards (${response.statusCode})';
          _isLoadingBoards = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoadingBoards = false;
      });
    }
  }

  Future<void> _fetchYears(int bookId, int sectionId) async {
    try {
      setState(() {
        _isLoadingYears = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/CQSearch/years/$bookId/$sectionId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Years API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _years = data is List ? data : [];
          _isLoadingYears = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load years (${response.statusCode})';
          _isLoadingYears = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoadingYears = false;
      });
    }
  }

  Future<void> _fetchCQDetails(int bookId, int sectionId, int boardId, int yearId) async {
    try {
      setState(() {
        _isLoadingResults = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/CQSearch/details/$bookId/$sectionId/$boardId/$yearId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('CQ Details API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cqResults = data is List ? data : [];
          _isLoadingResults = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load CQ details (${response.statusCode})';
          _isLoadingResults = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoadingResults = false;
      });
    }
  }

  // Navigation methods
  void _goToNextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildCurrentStepContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8E44AD),
            Color(0xFFBA68C8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Stack(
        children: [
          // Back Button
          Positioned(
            top: 12,
            left: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  if (_currentStep > 0) {
                    _goToPreviousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // Header Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getHeaderIcon(),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getHeaderTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getHeaderSubtitle(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getHeaderIcon() {
    switch (_currentStep) {
      case 0: return Icons.edit;
      case 1: return Icons.menu_book;
      case 2: return Icons.account_balance;
      case 3: return Icons.calendar_today;
      case 4: return Icons.quiz;
      default: return Icons.edit;
    }
  }

  String _getHeaderTitle() {
    switch (_currentStep) {
      case 0: return 'ব্যাচ CQ';
      case 1: return 'অধ্যায় - ${_selectedBook?['book_name'] ?? 'Book'}';
      case 2: return 'বোর্ড - ${_selectedSection?['book_section_name'] ?? 'Section'}';
      case 3: return 'সাল - ${_selectedBoard?['board_name'] ?? 'Board'}';
      case 4: return 'প্রশ্ন বিস্তারিত - ${_selectedYear?['board_year'] ?? 'Year'}';
      default: return 'ব্যাচ CQ';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentStep) {
      case 0: return 'বই নির্বাচন করুন';
      case 1: return 'অধ্যায় নির্বাচন করুন';
      case 2: return '${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedSection?['book_section_name'] ?? 'Section'}';
      case 3: return 'সাল নির্বাচন করুন\n${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedSection?['book_section_name'] ?? 'Section'} - ${_selectedBoard?['board_name'] ?? 'Board'}';
      case 4: return '${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedSection?['book_section_name'] ?? 'Section'}\n${_selectedBoard?['board_name'] ?? 'Board'} - ${_selectedYear?['board_year'] ?? 'Year'}';
      default: return 'বই নির্বাচন করুন';
    }
  }

  Widget _buildCurrentStepContent() {
    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    switch (_currentStep) {
      case 0:
        return _buildBooksGrid();
      case 1:
        return _buildSectionsGrid();
      case 2:
        return _buildBoardsGrid();
      case 3:
        return _buildYearsGrid();
      case 4:
        return _buildResultsList();
      default:
        return _buildBooksGrid();
    }
  }

  Widget _buildBooksGrid() {
    if (_isLoadingBooks) {
      return _buildLoadingState('বই লোড হচ্ছে...');
    }

    if (_books.isEmpty) {
      return _buildEmptyState('কোনো বই পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8E44AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.book_outlined,
                    color: Color(0xFF8E44AD),
                    size: 24,
                  ),
                ),
                title: Text(
                  book['book_name'] ?? 'Unknown Book',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Creative Question'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF8E44AD),
                ),
                onTap: () {
                  setState(() {
                    _selectedBook = book;
                  });
                  _fetchSections(book['id']);
                  _goToNextStep();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionsGrid() {
    if (_isLoadingSections) {
      return _buildLoadingState('অধ্যায় লোড হচ্ছে...');
    }

    if (_sections.isEmpty) {
      return _buildEmptyState('কোনো অধ্যায় পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8E44AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    color: Color(0xFF8E44AD),
                    size: 24,
                  ),
                ),
                title: Text(
                  section['book_section_name'] ?? 'Unknown Section',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF8E44AD),
                ),
                onTap: () {
                  setState(() {
                    _selectedSection = section;
                  });
                  _fetchBoards(_selectedBook['id']);
                  _goToNextStep();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBoardsGrid() {
    if (_isLoadingBoards) {
      return _buildLoadingState('বোর্ড লোড হচ্ছে...');
    }

    if (_boards.isEmpty) {
      return _buildEmptyState('কোনো বোর্ড পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _boards.length,
      itemBuilder: (context, index) {
        final board = _boards[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8E44AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_outlined,
                    color: Color(0xFF8E44AD),
                    size: 24,
                  ),
                ),
                title: Text(
                  board['board_name'] ?? 'Unknown Board',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF8E44AD),
                ),
                onTap: () {
                  setState(() {
                    _selectedBoard = board;
                  });
                  _fetchYears(_selectedBook['id'], _selectedSection['id']);
                  _goToNextStep();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearsGrid() {
    if (_isLoadingYears) {
      return _buildLoadingState('সাল লোড হচ্ছে...');
    }

    if (_years.isEmpty) {
      return _buildEmptyState('কোনো সাল পাওয়া যায়নি');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _years.length,
      itemBuilder: (context, index) {
        final year = _years[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8E44AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF8E44AD),
                    size: 24,
                  ),
                ),
                title: Text(
                  year['board_year']?.toString() ?? 'Unknown Year',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF8E44AD),
                ),
                onTap: () {
                  setState(() {
                    _selectedYear = year;
                  });
                  _fetchCQDetails(
                    _selectedBook['id'],
                    _selectedSection['id'],
                    _selectedBoard['id'],
                    year['id'],
                  );
                  _goToNextStep();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsList() {
    if (_isLoadingResults) {
      return _buildLoadingState('CQ তথ্য লোড হচ্ছে...');
    }

    return Column(
      children: [
        // PDF and Video Options
        Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              // PDF Card
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      title: const Text(
                        'PDF দেখুন',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('প্রশ্নের PDF ফাইল দেখুন'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF8E44AD),
                      ),
                      onTap: () {
                        // Handle PDF view with dummy data based on selections
                        Map<String, dynamic> pdfData = {
                          'pdf_file': 'https://admin.examhero.xyz/media/mcq_preparation/model_test_subjects/images/01a8cffb-f702-48e0-a03b-2e940c9c96f1.pdf',
                          'title': '${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedSection?['book_section_name'] ?? 'Section'} - ${_selectedBoard?['board_name'] ?? 'Board'} - ${_selectedYear?['board_year'] ?? 'Year'}'
                        };
                        
                        if (_cqResults.isNotEmpty && _cqResults[0]['pdf_file'] != null) {
                          _handlePdf(_cqResults[0]);
                        } else {
                          _handlePdf(pdfData);
                        }
                      },
                    ),
                  ),
                ),
              ),
              // Video Card
              Container(
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.play_circle_filled,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      title: const Text(
                        'ভিডিও দেখুন',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('সমাধানের ভিডিও দেখুন'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF8E44AD),
                      ),
                      onTap: () {
                        // Handle Video view with dummy data based on selections
                        Map<String, dynamic> videoData = {
                          'video_link': 'https://www.youtube.com/watch?v=po4hunYqld0&list=RDZOQaMp4ef14&index=3',
                          'title': '${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedSection?['book_section_name'] ?? 'Section'} - ${_selectedBoard?['board_name'] ?? 'Board'} - ${_selectedYear?['board_year'] ?? 'Year'}'
                        };
                        
                        if (_cqResults.isNotEmpty && _cqResults[0]['video_link'] != null) {
                          _handleVideo(_cqResults[0]);
                        } else {
                          _handleVideo(videoData);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Show actual CQ results if available
        if (_cqResults.isNotEmpty)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'সব CQ তালিকা (${_cqResults.length}টি)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8E44AD),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cqResults.length,
                      itemBuilder: (context, index) {
                        final cq = _cqResults[index];
                        bool hasVideo = cq['video_link'] != null && cq['video_link'].toString().isNotEmpty;
                        bool hasPdf = cq['pdf_file'] != null && cq['pdf_file'].toString().isNotEmpty;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF8E44AD).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.quiz_outlined,
                                            color: Color(0xFF8E44AD),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            cq['title'] ?? 'CQ ${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Media buttons
                                    if (hasVideo || hasPdf) ...[
                                      Row(
                                        children: [
                                          if (hasVideo)
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () => _handleVideo(cq),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                icon: const Icon(Icons.play_circle_filled, size: 18),
                                                label: const Text('ভিডিও'),
                                              ),
                                            ),
                                          if (hasVideo && hasPdf) const SizedBox(width: 8),
                                          if (hasPdf)
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () => _handlePdf(cq),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                icon: const Icon(Icons.picture_as_pdf, size: 18),
                                                label: const Text('পিডিএফ'),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ] else
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'কোনো মিডিয়া ফাইল উপলব্ধ নেই',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCubeGrid(
            color: Color(0xFF8E44AD),
            size: 50.0,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'ত্রুটি ঘটেছে',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = '';
                });
                // Retry current step
                switch (_currentStep) {
                  case 0:
                    _fetchBooks();
                    break;
                  case 1:
                    if (_selectedBook != null) _fetchSections(_selectedBook['id']);
                    break;
                  case 2:
                    if (_selectedBook != null) _fetchBoards(_selectedBook['id']);
                    break;
                  case 3:
                    if (_selectedBook != null && _selectedSection != null) {
                      _fetchYears(_selectedBook['id'], _selectedSection['id']);
                    }
                    break;
                  case 4:
                    if (_selectedBook != null && _selectedSection != null && 
                        _selectedBoard != null && _selectedYear != null) {
                      _fetchCQDetails(_selectedBook['id'], _selectedSection['id'], 
                                    _selectedBoard['id'], _selectedYear['id']);
                    }
                    break;
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('পুনরায় চেষ্টা', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Handle video playback
  void _handleVideo(dynamic data) {
    final videoUrl = data['video_link']?.toString() ?? '';
    if (videoUrl.isEmpty) {
      Get.snackbar('ত্রুটি', 'ভিডিও লিংক পাওয়া যায়নি',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) {
      Get.snackbar('ত্রুটি', 'অবৈধ ইউটিউব লিংক',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.to(() => _YouTubeVideoPlayer(
          videoId: videoId,
          title: data['title']?.toString() ?? 'ভিডিও',
        ));
  }

  // Handle PDF viewing
  void _handlePdf(dynamic data) {
    final pdfUrl = data['pdf_file']?.toString() ?? '';
    if (pdfUrl.isEmpty) {
      Get.snackbar('ত্রুটি', 'পিডিএফ লিংক পাওয়া যায়নি',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    Get.to(() => ShowNoticePDFView(pdfUrl: pdfUrl));
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
        backgroundColor: Color(0xFF8E44AD),
        foregroundColor: Colors.white,
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Color(0xFF8E44AD),
        ),
        builder: (context, player) {
          return Column(children: [player]);
        },
      ),
    );
  }
}
