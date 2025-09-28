// const kDomain = 'http://192.168.166.47:8000';
const kDomain = 'https://admin.examhero.xyz';
const _baseUrl = '$kDomain/api/v1';
//Auth
const kLoginUrl = 'https://admin.examhero.xyz/api/v1/auth/token/';
const kRegisterWithProfileUrl = '$_baseUrl/auth/register-with-profile-create/';
const kLogoutUrl = '$_baseUrl/auth/logout/';
const kChangePasswordUpdateUrl = '$_baseUrl/auth/change-password/';
const kPasswordResetOtpGenerateCreateUrl =
    '$_baseUrl/auth/password-reset-otp-create/';
const kResetPasswordWithOtpUpdateUrl = '$_baseUrl/auth/reset-password/';

// Profile stuffs
String kProfileRetrieveUrl(int userId) =>
    '$_baseUrl/profiles/profile-retrieve/$userId/';
const kProfileUpdateUrl = '$_baseUrl/profiles/self-profile-update/';

// MCQ Preparation
const kExamCategoryListUrl = '$_baseUrl/mcq-preparation/exam-category-list/';
String kExamListUrl(int categoryId) =>
    '$_baseUrl/mcq-preparation/exam-list/$categoryId/';
String kCategoryWiseMCQListUrl(int examId) =>
    '$_baseUrl/mcq-preparation/category-wise-mcq-list/$examId/';
const kSubjectListUrl = '$_baseUrl/mcq-preparation/subject-list/';
String kSectionListUrl(int subjectId) =>
    '$_baseUrl/mcq-preparation/section-list/$subjectId/';
String kSectionMCQListUrl(int sectionId) =>
    '$_baseUrl/mcq-preparation/section-mcq-list/$sectionId/';
String kMCQTestAnswerSubmitCreateUrl(int testId) =>
    '$_baseUrl/mcq-preparation/mcq-test-answer-submit/$testId/';
String kMCQTestRankingListUrl(int testId) =>
    '$_baseUrl/mcq-preparation/mcq-test-ranking-list/$testId/';
// Performace
const kMyPerformaceRetrieveUrl =
    '$_baseUrl/mcq-preparation/my-performance-retrieve/';

// Balance
const kPaymentMethodListUrl = '$_baseUrl/balance/payment-method-list/';
const kBalanceRetrieveUrl = '$_baseUrl/balance/balance-retrieve/';
const kDepositHistoryListUrl = '$_baseUrl/balance/deposit-request-list/';
const kDepositRequestCreateUrl = '$_baseUrl/balance/deposit-request-create/';
const kWithdrawHistoryUrl = '$_baseUrl/balance/withdraw-request-list/';
const kWithdrawRequestCreateUrl = '$_baseUrl/balance/withdraw-request-create/';
// Package
const kPackageRetrieveUrl = '$_baseUrl/balance/package-retrieve/';
const kPackagePurchasedCreateUrl =
    '$_baseUrl/balance/package-purchased-create/';
const kEarningHistoryListUrl = '$_baseUrl/balance/earning-history-list/';

//new update endpoind
const kBannerList = 'https://admin.examhero.xyz/api/v1/mcq-preparation/banner/';
const kBottomBannerList = 'http://admin.examhero.xyz/api/v1/mcq-preparation/banner-second/';
const kFreePdfList = 'https://admin.examhero.xyz/api/v1/documents/pdfs/free/';
const kPaidPdfList = 'https://admin.examhero.xyz/api/v1/documents/pdfs/paid/';
const kLiveList = 'http://admin.examhero.xyz/api/v1/mcq-preparation/live/';
const kArchiveList = 'https://admin.examhero.xyz/api/v1/mcq-preparation/archive/';
const kUpcomingList = 'https://admin.examhero.xyz/api/v1/mcq-preparation/upcoming/';
const kModelTestList =
    'https://admin.examhero.xyz/api/v1/mcq-preparation/model-test-subject-list/';
String kBookmarks(int mcqId) =>
    'https://admin.examhero.xyz/api/v1/mcq-preparation/mcq-bookmark/$mcqId/';
