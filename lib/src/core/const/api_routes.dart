class ApiRoutes {
  
  static const String baseURL = 'http://64.227.170.206/kayal.com/public/api/restaurant';
  
  static const String imageBaseURL = 'http://64.227.170.206/kayal.com/public/storage/';
  static const String apiKey = 'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn';

  
  // Auth & Onboarding Endpoints
  static const String status = '/status';
  static const String sendOtp = '/send_otp';
  static const String resendOtp = '/resend_otp';
  static const String verifyOtp = '/verify_otp';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String profile = '/profile';
  static const String updateProfile = '/update_profile';
  static const String getDocuments = '/get_documents';
  static const String uploadDocument = '/upload_document';

  // Category Endpoints
  static const String categories = '/categories';
  static const String addCategory = '/add_category';
  static const String deleteCategory = '/delete_category';

  // Product Endpoints
  static const String products = '/products';
  static const String addProduct = '/add_product';
  static const String updateProduct = '/update_product';
  static const String deleteProduct = '/delete_product';

  // Dashboard & Media Endpoints
  static const String getDashboard = '/get_dashboard';
  static const String banners = '/banners';
  static const String updateStatus = '/update_status';
  static const String updateSettings = '/update_settings';
  static const String updateBankDetails = '/update_bank_details';
  static const String salesReport = '/sales_report';
  static const String feedbacks = '/feedbacks';
  static const String reviews = '/reviews';
  static const String replyReview = '/reply_review';
  static const String submitSupport = '/submit_support';
  static const String orders = '/orders';
  static const String orderDetails = '/order_details';
  static const String acceptOrder = '/accept_order';
  static const String foodReady = '/food_ready';
  static const String rejectOrder = '/reject_order';
  static const String recentOrders = '/recent_orders';
  static const String orderInvoice = '/order_invoice';
}
