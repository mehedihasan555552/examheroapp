import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/mcq_preparation/mcq_list_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/package_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class BatchMCQsPage extends StatefulWidget {
  const BatchMCQsPage({super.key});

  @override
  State<BatchMCQsPage> createState() => _BatchMCQsPageState();
}

class _BatchMCQsPageState extends State<BatchMCQsPage> {
  final AuthController _authController = Get.find();

  // Current step in the progressive disclosure
  int _currentStep = 0;
  
  // Selected values with full objects
  dynamic _selectedBook;
  dynamic _selectedBoard;
  dynamic _selectedYear;
  
  // Data lists
  List<dynamic> _books = [];
  List<dynamic> _boards = [];
  List<dynamic> _years = [];
  List<dynamic> _mcqResults = [];
  
  // Loading states
  bool _isLoadingBooks = true;
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

  // API Calls using the new MCQ Search endpoints
  Future<void> _fetchBooks() async {
    try {
      setState(() {
        _isLoadingBooks = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/mcq/books/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('MCQ Books API Response: ${response.body}');

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

  Future<void> _fetchBoards(int bookId) async {
    try {
      setState(() {
        _isLoadingBoards = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/mcq/names/$bookId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('MCQ Boards API Response: ${response.body}');

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

  Future<void> _fetchYears(int bookId, int boardNameId) async {
    try {
      setState(() {
        _isLoadingYears = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/mcq/years/$bookId/$boardNameId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('MCQ Years API Response: ${response.body}');

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

  Future<void> _fetchMCQDetails(int bookId, int boardNameId, int yearId) async {
    try {
      setState(() {
        _isLoadingResults = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://admin.examhero.xyz/api/v1/mcq-preparation/mcq/details/$bookId/$boardNameId/$yearId/'),
        headers: {
          'Authorization': 'Token ${_authController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('MCQ Details API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mcqResults = data is List ? data : [];
          _isLoadingResults = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load MCQ details (${response.statusCode})';
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
    if (_currentStep < 3) {
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
            Color(0xFF2196F3),
            Color(0xFF1976D2),
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
      case 0: return Icons.quiz;
      case 1: return Icons.account_balance;
      case 2: return Icons.calendar_today;
      case 3: return Icons.school;
      default: return Icons.quiz;
    }
  }

  String _getHeaderTitle() {
    switch (_currentStep) {
      case 0: return 'ব্যাচ MCQ';
      case 1: return 'নাম - ${_selectedBook?['book_name'] ?? 'Book'}';
      case 2: return 'সাল - ${_selectedBoard?['board_name'] ?? 'Board'}';
      case 3: return 'বিস্তারিত - ${_selectedYear?['board_year'] ?? 'Year'}';
      default: return 'ব্যাচ MCQ';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentStep) {
      case 0: return 'বই নির্বাচন করুন';
      case 1: return 'নাম নির্বাচন করুন';
      case 2: return 'সাল নির্বাচন করুন\n${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedBoard?['board_name'] ?? 'Board'}';
      case 3: return 'MCQ প্র্যাকটিস\n${_selectedBook?['book_name'] ?? 'Book'}\n${_selectedBoard?['board_name'] ?? 'Board'} - ${_selectedYear?['board_year'] ?? 'Year'}';
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
        return _buildBoardsGrid();
      case 2:
        return _buildYearsGrid();
      case 3:
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
                    color: Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.book_outlined,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                title: Text(
                  book['book_name'] ?? book['name'] ?? 'Unknown Book',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('MCQ Practice'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF2196F3),
                ),
                onTap: () {
                  setState(() {
                    _selectedBook = book;
                  });
                  _fetchBoards(book['id']);
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
                    color: Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_outlined,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                title: Text(
                  board['board_name'] ?? board['name'] ?? 'Unknown Board',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF2196F3),
                ),
                onTap: () {
                  setState(() {
                    _selectedBoard = board;
                  });
                  _fetchYears(_selectedBook['id'], board['id']);
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
                    color: Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                title: Text(
                  year['board_year']?.toString() ?? year['year']?.toString() ?? 'Unknown Year',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF2196F3),
                ),
                onTap: () {
                  setState(() {
                    _selectedYear = year;
                  });
                  _fetchMCQDetails(
                    _selectedBook['id'],
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
      return _buildLoadingState('MCQ তথ্য লোড হচ্ছে...');
    }

    // Create a dummy MCQ item based on selections and API results
    Map<String, dynamic> mcqData = {
      'id': _mcqResults.isNotEmpty ? _mcqResults.first['id'] : 1,
      'title': '${_selectedBook?['book_name'] ?? 'Book'} - ${_selectedBoard?['board_name'] ?? 'Board'} - ${_selectedYear?['board_year'] ?? 'Year'}',
      'marks': _mcqResults.isNotEmpty ? _mcqResults.first['marks']?.toString() ?? '৪টি' : '৪টি',
      'duration': _mcqResults.isNotEmpty ? _mcqResults.first['duration']?.toString() ?? '৩০ মিনিট' : '৩০ মিনিট',
      'question_count': _mcqResults.length > 0 ? _mcqResults.length : 4,
      'time_limit': _mcqResults.isNotEmpty ? _mcqResults.first['duration'] ?? 30 : 30,
      'department': 'science',
      'student_class': 'hsc',
      'board_book': _selectedBook?['book_name'],
      'board_name': _selectedBoard?['board_name'],
      'board_year': _selectedYear?['board_year'],
      'video_link': _mcqResults.isNotEmpty ? _mcqResults.first['video_link'] : null,
      'mcqs': _mcqResults, // Actual MCQ data if available
    };

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
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
                      color: Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          mcqData['title'] ?? 'কোনো শিরোনাম নেই',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (mcqData['video_link'] != null && mcqData['video_link'].toString().isNotEmpty)
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
                          'প্রশ্ন: ${mcqData['marks'] ?? 'N/A'} | সময়: ${mcqData['duration'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'বিভাগ: ${mcqData['department'] ?? 'science'} | শ্রেণি: ${mcqData['student_class'] ?? 'hsc'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Action buttons - Check if video is available
                (mcqData['video_link'] != null && mcqData['video_link'].toString().isNotEmpty)
                    ? Row(
                        children: [
                          Expanded(
                            child: rPrimaryElevatedButton(
                              onPressed: () => _handleStartExam(mcqData),
                              primaryColor: Color(0xFF2196F3),
                              buttonText: 'পরীক্ষা শুরু',
                              fontSize: 10.0,
                              borderRadius: 25,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: rPrimaryElevatedButton(
                              onPressed: () => _handleStudy(mcqData),
                              primaryColor: Colors.green,
                              buttonText: 'অধ্যয়ন',
                              fontSize: 10.0,
                              borderRadius: 25,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: rPrimaryElevatedButton(
                              onPressed: () => _handleVideo(mcqData),
                              primaryColor: Colors.purple,
                              buttonText: 'ভিডিও',
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
                              onPressed: () => _handleStartExam(mcqData),
                              primaryColor: Color(0xFF2196F3),
                              buttonText: 'পরীক্ষা শুরু',
                              fontSize: 13.0,
                              borderRadius: 25,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: rPrimaryElevatedButton(
                              onPressed: () => _handleStudy(mcqData),
                              primaryColor: Colors.green,
                              buttonText: 'অধ্যয়ন',
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
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCubeGrid(
            color: Color(0xFF2196F3),
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
                    if (_selectedBook != null) _fetchBoards(_selectedBook['id']);
                    break;
                  case 2:
                    if (_selectedBook != null && _selectedBoard != null) {
                      _fetchYears(_selectedBook['id'], _selectedBoard['id']);
                    }
                    break;
                  case 3:
                    if (_selectedBook != null && _selectedBoard != null && _selectedYear != null) {
                      _fetchMCQDetails(_selectedBook['id'], _selectedBoard['id'], _selectedYear['id']);
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

  void _handleVideo(dynamic data) {
    if (int.tryParse(_authController.profile.value.package.toString()) == null) {
      _showPremiumDialog();
    } else {
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
            title: data['title'] ?? 'ভিডিও',
          ));
    }
  }

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
                backgroundColor: Color(0xFF2196F3),
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
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Color(0xFF2196F3),
          progressColors: ProgressBarColors(
            playedColor: Color(0xFF2196F3),
            handleColor: Color(0xFF2196F3),
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
