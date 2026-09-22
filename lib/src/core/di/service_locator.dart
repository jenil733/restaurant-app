import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core Services
import '../services/api_services.dart';
import '../services/local_storage_services.dart';

// Repositories
import '../../domain/repository/register_repository.dart';
import '../../data/repository/register_repository_impl.dart';
import '../../domain/repository/otp_repository.dart';
import '../../data/repository/otp_repository_impl.dart';
import '../../data/repository/send_otp_repository_impl.dart';
import '../../data/repository/verify_otp_repository_impl.dart';
import '../../data/repository/resend_restaurant_otp_repository_impl.dart';
import '../../domain/repository/status_repository.dart';
import '../../data/repository/status_repository_impl.dart';
import '../../data/repository/update_status_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repository/category_repository.dart';
import '../../data/repository/category_repository_impl.dart';
import '../../data/repository/add_category_repository_impl.dart';
import '../../data/repository/delete_category_repository_impl.dart';
import '../../domain/repository/product_repository.dart';
import '../../data/repository/product_repository_impl.dart';
import '../../data/repository/add_product_repository_impl.dart';
import '../../data/repository/update_product_repository_impl.dart';
import '../../data/repository/delete_product_repository_impl.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../domain/repository/banner_repository.dart';
import '../../data/repository/banner_repository_impl.dart';
import '../../domain/repository/profile_repository.dart';
import '../../data/repository/profile_repository_impl.dart';
import '../../domain/repository/settings_repository.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../../domain/repository/bank_details_repository.dart';
import '../../data/repository/bank_details_repository_impl.dart';
import '../../domain/repository/sales_report_repository.dart';
import '../../data/repository/sales_report_repository_impl.dart';
import '../../domain/repository/feedback_repository.dart';
import '../../data/repository/feedback_repository_impl.dart';
import '../../domain/repository/reviews_repository.dart';
import '../../data/repository/reviews_repository_impl.dart';
import '../../domain/repository/reply_review_repository.dart';
import '../../data/repository/reply_review_repository_impl.dart';
import '../../domain/repository/support_repository.dart';
import '../../data/repository/support_repository_impl.dart';
import '../../domain/repository/order_repository.dart';
import '../../data/repository/order_repository_impl.dart';
import '../../domain/repository/order_detail_repository.dart';
import '../../data/repository/order_detail_repository_impl.dart';
import '../../domain/repository/accept_order_repository.dart';
import '../../data/repository/accept_order_repository_impl.dart';
import '../../domain/repository/food_ready_repository.dart';
import '../../data/repository/food_ready_repository_impl.dart';
import '../../domain/repository/reject_order_repository.dart';
import '../../data/repository/reject_order_repository_impl.dart';
import '../../domain/repository/recent_orders_repository.dart';
import '../../data/repository/recent_orders_repository_impl.dart';
import '../../domain/repository/order_invoice_repository.dart';
import '../../data/repository/order_invoice_repository_impl.dart';
import '../../domain/repository/document_repository.dart';
import '../../data/repository/document_repository_impl.dart';

// Use Cases
import '../../domain/usecase/register_usecase.dart';
import '../../domain/usecase/send_otp_usecase.dart';
import '../../domain/usecase/resend_restaurant_otp_usecase.dart';
import '../../domain/usecase/verify_otp_usecase.dart';
import '../../domain/usecase/get_status_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/add_category_usecase.dart';
import '../../domain/usecase/delete_category_usecase.dart';
import '../../domain/usecase/get_restaurant_products_usecase.dart';
import '../../domain/usecase/add_product_usecase.dart';
import '../../domain/usecase/update_product_usecase.dart';
import '../../domain/usecase/delete_product_usecase.dart';
import '../../domain/usecase/get_dashboard_usecase.dart';
import '../../domain/usecase/get_banners_usecase.dart';
import '../../domain/usecase/update_status_usecase.dart';
import '../../domain/usecase/get_profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import '../../domain/usecase/update_settings_usecase.dart';
import '../../domain/usecase/update_bank_details_usecase.dart';
import '../../domain/usecase/get_sales_report_usecase.dart';
import '../../domain/usecase/get_feedbacks_usecase.dart';
import '../../domain/usecase/get_reviews_usecase.dart';
import '../../domain/usecase/reply_review_usecase.dart';
import '../../domain/usecase/submit_support_usecase.dart';
import '../../domain/usecase/get_orders_usecase.dart';
import '../../domain/usecase/get_order_details_usecase.dart';
import '../../domain/usecase/accept_order_usecase.dart';
import '../../domain/usecase/food_ready_usecase.dart';
import '../../domain/usecase/reject_order_usecase.dart';
import '../../domain/usecase/get_recent_orders_usecase.dart';
import '../../domain/usecase/get_order_invoice_usecase.dart';
import '../../domain/usecase/get_documents_usecase.dart';
import '../../domain/usecase/upload_document_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== CORE & STORAGE ====================
  final prefs = await SharedPreferences.getInstance();
  await LocalStorageService().init();

  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerSingleton<SharedPreferences>(prefs);
  }

  if (!sl.isRegistered<LocalStorageService>()) {
    sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  }

  if (!sl.isRegistered<ApiService>()) {
    sl.registerLazySingleton<ApiService>(() => ApiService());
  }

  // ==================== REPOSITORIES ====================
  if (!sl.isRegistered<RegisterRepository>()) {
    sl.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OtpRepository>()) {
    sl.registerLazySingleton<OtpRepository>(
      () => OtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SendOtpRepository>()) {
    sl.registerLazySingleton<SendOtpRepository>(
      () => SendOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<VerifyOtpRepository>()) {
    sl.registerLazySingleton<VerifyOtpRepository>(
      () => VerifyOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ResendRestaurantOtpRepository>()) {
    sl.registerLazySingleton<ResendRestaurantOtpRepository>(
      () => ResendRestaurantOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<StatusRepository>()) {
    sl.registerLazySingleton<StatusRepository>(
      () => StatusRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateStatusRepository>()) {
    sl.registerLazySingleton<UpdateStatusRepository>(
      () => UpdateStatusRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<CategoryRepository>()) {
    sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AddCategoryRepository>()) {
    sl.registerLazySingleton<AddCategoryRepository>(
      () => AddCategoryRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<DeleteCategoryRepository>()) {
    sl.registerLazySingleton<DeleteCategoryRepository>(
      () => DeleteCategoryRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ProductRepository>()) {
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AddProductRepository>()) {
    sl.registerLazySingleton<AddProductRepository>(
      () => AddProductRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateProductRepository>()) {
    sl.registerLazySingleton<UpdateProductRepository>(
      () => UpdateProductRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<DeleteProductRepository>()) {
    sl.registerLazySingleton<DeleteProductRepository>(
      () => DeleteProductRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<DashboardRepository>()) {
    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<BannerRepository>()) {
    sl.registerLazySingleton<BannerRepository>(
      () => BannerRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<BankDetailsRepository>()) {
    sl.registerLazySingleton<BankDetailsRepository>(
      () => BankDetailsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SalesReportRepository>()) {
    sl.registerLazySingleton<SalesReportRepository>(
      () => SalesReportRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<FeedbackRepository>()) {
    sl.registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ReviewsRepository>()) {
    sl.registerLazySingleton<ReviewsRepository>(
      () => ReviewsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ReplyReviewRepository>()) {
    sl.registerLazySingleton<ReplyReviewRepository>(
      () => ReplyReviewRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SupportRepository>()) {
    sl.registerLazySingleton<SupportRepository>(
      () => SupportRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OrderRepository>()) {
    sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OrderDetailRepository>()) {
    sl.registerLazySingleton<OrderDetailRepository>(
      () => OrderDetailRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AcceptOrderRepository>()) {
    sl.registerLazySingleton<AcceptOrderRepository>(
      () => AcceptOrderRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<FoodReadyRepository>()) {
    sl.registerLazySingleton<FoodReadyRepository>(
      () => FoodReadyRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<RejectOrderRepository>()) {
    sl.registerLazySingleton<RejectOrderRepository>(
      () => RejectOrderRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<RecentOrdersRepository>()) {
    sl.registerLazySingleton<RecentOrdersRepository>(
      () => RecentOrdersRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OrderInvoiceRepository>()) {
    sl.registerLazySingleton<OrderInvoiceRepository>(
      () => OrderInvoiceRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<DocumentRepository>()) {
    sl.registerLazySingleton<DocumentRepository>(
      () => DocumentRepositoryImpl(sl<ApiService>()),
    );
  }

  // ==================== USE CASES ====================
  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<RegisterRepository>()),
    );
  }

  if (!sl.isRegistered<SendOtpUseCase>()) {
    sl.registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(sl<SendOtpRepository>()),
    );
  }

  if (!sl.isRegistered<ResendRestaurantOtpUseCase>()) {
    sl.registerLazySingleton<ResendRestaurantOtpUseCase>(
      () => ResendRestaurantOtpUseCase(sl<ResendRestaurantOtpRepository>()),
    );
  }

  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(sl<VerifyOtpRepository>()),
    );
  }

  if (!sl.isRegistered<GetStatusUseCase>()) {
    sl.registerLazySingleton<GetStatusUseCase>(
      () => GetStatusUseCase(sl<StatusRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateStatusUseCase>()) {
    sl.registerLazySingleton<UpdateStatusUseCase>(
      () => UpdateStatusUseCase(sl<UpdateStatusRepository>()),
    );
  }

  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<GetCategoriesUseCase>()) {
    sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(sl<CategoryRepository>()),
    );
  }

  if (!sl.isRegistered<AddCategoryUseCase>()) {
    sl.registerLazySingleton<AddCategoryUseCase>(
      () => AddCategoryUseCase(sl<AddCategoryRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteCategoryUseCase>()) {
    sl.registerLazySingleton<DeleteCategoryUseCase>(
      () => DeleteCategoryUseCase(sl<DeleteCategoryRepository>()),
    );
  }

  if (!sl.isRegistered<GetRestaurantProductsUseCase>()) {
    sl.registerLazySingleton<GetRestaurantProductsUseCase>(
      () => GetRestaurantProductsUseCase(sl<ProductRepository>()),
    );
  }

  if (!sl.isRegistered<AddProductUseCase>()) {
    sl.registerLazySingleton<AddProductUseCase>(
      () => AddProductUseCase(sl<AddProductRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateProductUseCase>()) {
    sl.registerLazySingleton<UpdateProductUseCase>(
      () => UpdateProductUseCase(sl<UpdateProductRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteProductUseCase>()) {
    sl.registerLazySingleton<DeleteProductUseCase>(
      () => DeleteProductUseCase(sl<DeleteProductRepository>()),
    );
  }

  if (!sl.isRegistered<GetDashboardUseCase>()) {
    sl.registerLazySingleton<GetDashboardUseCase>(
      () => GetDashboardUseCase(sl<DashboardRepository>()),
    );
  }

  if (!sl.isRegistered<GetBannersUseCase>()) {
    sl.registerLazySingleton<GetBannersUseCase>(
      () => GetBannersUseCase(sl<BannerRepository>()),
    );
  }

  if (!sl.isRegistered<GetProfileUseCase>()) {
    sl.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl<ProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateProfileUseCase>()) {
    sl.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl<ProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateSettingsUseCase>()) {
    sl.registerLazySingleton<UpdateSettingsUseCase>(
      () => UpdateSettingsUseCase(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateBankDetailsUseCase>()) {
    sl.registerLazySingleton<UpdateBankDetailsUseCase>(
      () => UpdateBankDetailsUseCase(sl<BankDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<GetSalesReportUseCase>()) {
    sl.registerLazySingleton<GetSalesReportUseCase>(
      () => GetSalesReportUseCase(sl<SalesReportRepository>()),
    );
  }

  if (!sl.isRegistered<GetFeedbacksUseCase>()) {
    sl.registerLazySingleton<GetFeedbacksUseCase>(
      () => GetFeedbacksUseCase(sl<FeedbackRepository>()),
    );
  }

  if (!sl.isRegistered<GetReviewsUseCase>()) {
    sl.registerLazySingleton<GetReviewsUseCase>(
      () => GetReviewsUseCase(sl<ReviewsRepository>()),
    );
  }

  if (!sl.isRegistered<ReplyReviewUseCase>()) {
    sl.registerLazySingleton<ReplyReviewUseCase>(
      () => ReplyReviewUseCase(sl<ReplyReviewRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitSupportUseCase>()) {
    sl.registerLazySingleton<SubmitSupportUseCase>(
      () => SubmitSupportUseCase(sl<SupportRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrdersUseCase>()) {
    sl.registerLazySingleton<GetOrdersUseCase>(
      () => GetOrdersUseCase(sl<OrderRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrderDetailsUseCase>()) {
    sl.registerLazySingleton<GetOrderDetailsUseCase>(
      () => GetOrderDetailsUseCase(sl<OrderDetailRepository>()),
    );
  }

  if (!sl.isRegistered<AcceptOrderUseCase>()) {
    sl.registerLazySingleton<AcceptOrderUseCase>(
      () => AcceptOrderUseCase(sl<AcceptOrderRepository>()),
    );
  }

  if (!sl.isRegistered<FoodReadyUseCase>()) {
    sl.registerLazySingleton<FoodReadyUseCase>(
      () => FoodReadyUseCase(sl<FoodReadyRepository>()),
    );
  }

  if (!sl.isRegistered<RejectOrderUseCase>()) {
    sl.registerLazySingleton<RejectOrderUseCase>(
      () => RejectOrderUseCase(sl<RejectOrderRepository>()),
    );
  }

  if (!sl.isRegistered<GetRecentOrdersUseCase>()) {
    sl.registerLazySingleton<GetRecentOrdersUseCase>(
      () => GetRecentOrdersUseCase(sl<RecentOrdersRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrderInvoiceUseCase>()) {
    sl.registerLazySingleton<GetOrderInvoiceUseCase>(
      () => GetOrderInvoiceUseCase(sl<OrderInvoiceRepository>()),
    );
  }

  if (!sl.isRegistered<GetDocumentsUseCase>()) {
    sl.registerLazySingleton<GetDocumentsUseCase>(
      () => GetDocumentsUseCase(sl<DocumentRepository>()),
    );
  }

  if (!sl.isRegistered<UploadDocumentUseCase>()) {
    sl.registerLazySingleton<UploadDocumentUseCase>(
      () => UploadDocumentUseCase(sl<DocumentRepository>()),
    );
  }
}