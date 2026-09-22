import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../core/services/local_storage_services.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/update_status_model.dart';
import '../../data/repository/banner_repository_impl.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../data/repository/recent_orders_repository_impl.dart';
import '../../data/repository/status_repository_impl.dart';
import '../../domain/usecase/get_banners_usecase.dart';
import '../../domain/usecase/get_dashboard_usecase.dart';
import '../../domain/usecase/get_recent_orders_usecase.dart';
import '../../domain/usecase/update_status_usecase.dart';
import '../../data/repository/document_repository_impl.dart';
import '../../domain/usecase/get_documents_usecase.dart';
import '../controller/profile_controller.dart';
import '../widgets/app_notification.dart';

class HomeController extends GetxController {
  HomeController({
    GetDashboardUseCase? getDashboardUseCase,
    GetBannersUseCase? getBannersUseCase,
    UpdateStatusUseCase? updateStatusUseCase,
    GetRecentOrdersUseCase? getRecentOrdersUseCase,
    GetDocumentsUseCase? getDocumentsUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase ??
            (sl.isRegistered<GetDashboardUseCase>()
                ? sl<GetDashboardUseCase>()
                : GetDashboardUseCase(
                    DashboardRepositoryImpl(
                      sl.isRegistered<ApiService>()
                          ? sl<ApiService>()
                          : ApiService(),
                    ),
                  )),
        _getBannersUseCase = getBannersUseCase ??
            (sl.isRegistered<GetBannersUseCase>()
                ? sl<GetBannersUseCase>()
                : GetBannersUseCase(
                    BannerRepositoryImpl(
                      sl.isRegistered<ApiService>()
                          ? sl<ApiService>()
                          : ApiService(),
                    ),
                  )),
        _updateStatusUseCase = updateStatusUseCase ??
            (sl.isRegistered<UpdateStatusUseCase>()
                ? sl<UpdateStatusUseCase>()
                : UpdateStatusUseCase(
                    StatusRepositoryImpl(
                      sl.isRegistered<ApiService>()
                          ? sl<ApiService>()
                          : ApiService(),
                    ),
                  )),
        _getRecentOrdersUseCase = getRecentOrdersUseCase ??
            (sl.isRegistered<GetRecentOrdersUseCase>()
                ? sl<GetRecentOrdersUseCase>()
                : GetRecentOrdersUseCase(
                    RecentOrdersRepositoryImpl(
                      sl.isRegistered<ApiService>()
                          ? sl<ApiService>()
                          : ApiService(),
                    ),
                  )),
        _getDocumentsUseCase = getDocumentsUseCase ??
            (sl.isRegistered<GetDocumentsUseCase>()
                ? sl<GetDocumentsUseCase>()
                : GetDocumentsUseCase(
                    DocumentRepositoryImpl(
                      sl.isRegistered<ApiService>()
                          ? sl<ApiService>()
                          : ApiService(),
                    ),
                  ));

  final GetDashboardUseCase _getDashboardUseCase;
  final GetBannersUseCase _getBannersUseCase;
  final UpdateStatusUseCase _updateStatusUseCase;
  final GetRecentOrdersUseCase _getRecentOrdersUseCase;
  final GetDocumentsUseCase _getDocumentsUseCase;

  final currentIndex = 0.obs;
  final pageController = PageController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Online / Offline restaurant status
  final isOnline = true.obs;
  final isUpdatingStatus = false.obs;

  // Verification state (defaults to pending verification if not yet approved by admin)
  final isApproved = false.obs;
  final isRejected = false.obs;
  final rejectionReason = 'The Uploaded Document is Incorrect.'.obs;
  final rejectedDocument = RxnString();
  final rejectedDocuments = <String>[].obs;

  // Live Dashboard State
  final isLoadingDashboard = true.obs;
  final hasLoadedDashboard = false.obs;
  final Rx<DashboardResponseModel?> dashboardData = Rx<DashboardResponseModel?>(null);
  final totalOrders = 0.obs;
  final totalProducts = 0.obs;
  final recentOrders = <DashboardOrderModel>[].obs;

  // Live Banners State
  final isLoadingBanners = false.obs;
  final banners = <BannerModel>[].obs;

  final hasReuploaded = false.obs;

  void clearRejectionState() {
    isRejected.value = false;
    rejectedDocument.value = null;
    rejectedDocuments.clear();
    rejectionReason.value = '';
    hasReuploaded.value = true;
    LocalStorageService().saveBool('has_reuploaded_documents', true);
  }

  @override
  void onInit() {
    super.onInit();
    final reuploaded = LocalStorageService().getBool('has_reuploaded_documents');
    if (reuploaded == true) {
      hasReuploaded.value = true;
      isRejected.value = false;
    }
    refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    try {
      await Future.wait([
        fetchDashboard(),
        fetchBanners(),
        fetchRecentOrders(),
        if (Get.isRegistered<ProfileController>())
          Get.find<ProfileController>().fetchProfile(isRefresh: true),
      ]);
    } catch (e) {
      debugPrint('Dashboard refresh error: $e');
    }
  }

  Future<void> fetchDashboard() async {
    try {
      isLoadingDashboard.value = true;
      final response = await _getDashboardUseCase();
      dashboardData.value = response;

      if (response.data != null) {
        final data = response.data!;
        totalOrders.value = data.totalOrders;
        totalProducts.value = data.totalProducts;

        if (data.isApproved != null) {
          isApproved.value = data.isApproved!;
          if (data.isApproved == true) {
            isRejected.value = false;
            hasReuploaded.value = false;
            LocalStorageService().saveBool('has_reuploaded_documents', false);
            if (Get.isRegistered<ProfileController>()) {
              final profileCtrl = Get.find<ProfileController>();
              profileCtrl.isActive.value = true;
              profileCtrl.businessStatus.value = "Approved";
            }
          }
        }
        if (data.isRejected != null && !isApproved.value && !hasReuploaded.value) {
          isRejected.value = data.isRejected!;
        }
        if (data.rejectionReason != null && data.rejectionReason!.isNotEmpty && !hasReuploaded.value) {
          rejectionReason.value = data.rejectionReason!;
        }
        if (data.rejectedDocuments.isNotEmpty && !hasReuploaded.value) {
          rejectedDocuments.assignAll(data.rejectedDocuments);
          rejectedDocument.value = data.rejectedDocuments.join(', ');
        } else if (data.rejectedDocument != null && data.rejectedDocument!.isNotEmpty && !hasReuploaded.value) {
          rejectedDocument.value = data.rejectedDocument!;
          rejectedDocuments.assignAll([data.rejectedDocument!]);
        }
        if (data.recentOrders.isNotEmpty) {
          recentOrders.assignAll(data.recentOrders);
        }
      }
      _syncWithProfile();

      // If not approved and not yet reuploaded, check documents API to verify if any document has been rejected by admin
      if (!isApproved.value && !hasReuploaded.value) {
        try {
          final docsResp = await _getDocumentsUseCase();
          final List<String> foundRejected = [];
          final List<String> reasons = [];

          for (final doc in docsResp.documents) {
            final st = doc.status?.toLowerCase().trim();
            final isDocRej = st == 'rejected' ||
                st == '2' ||
                st == 'declined' ||
                (doc.rejectionReason != null && doc.rejectionReason!.trim().isNotEmpty);

            if (isDocRej) {
              final name = doc.name ?? doc.type;
              if (name != null && name.trim().isNotEmpty && !foundRejected.contains(name.trim())) {
                foundRejected.add(name.trim());
              }
              if (doc.rejectionReason != null && doc.rejectionReason!.trim().isNotEmpty) {
                final r = doc.rejectionReason!.trim();
                if (!reasons.contains(r)) {
                  reasons.add(r);
                }
              }
            }
          }

          if (foundRejected.isNotEmpty || reasons.isNotEmpty) {
            isRejected.value = true;
            isApproved.value = false;
            if (foundRejected.isNotEmpty) {
              rejectedDocuments.assignAll(foundRejected);
              rejectedDocument.value = foundRejected.join(', ');
            }
            if (reasons.isNotEmpty) {
              rejectionReason.value = reasons.join(' • ');
            }
          }
        } catch (e) {
          debugPrint('Error fetching docs for rejection in HomeController: $e');
        }
      }
    } catch (e) {
      debugPrint('Dashboard fetch error: $e');
      _syncWithProfile();
    } finally {
      isLoadingDashboard.value = false;
      hasLoadedDashboard.value = true;
    }
  }

  void _syncWithProfile() {
    if (isApproved.value) {
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.isActive.value = true;
        if (profileCtrl.businessStatus.value.isEmpty ||
            profileCtrl.businessStatus.value.toLowerCase() == 'rejected' ||
            profileCtrl.businessStatus.value.toLowerCase() == 'pending') {
          profileCtrl.businessStatus.value = "Approved";
        }
      }
      return;
    }

    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      final p = profileCtrl.profile.value;
      if (p != null) {
        final st = (p.status ?? p.businessStatus)?.toString().toLowerCase().trim();
        if (st == 'approved' || st == '1' || st == 'active' || st == 'true') {
          isApproved.value = true;
          isRejected.value = false;
        } else if (st == 'rejected' || st == '2') {
          isApproved.value = false;
          isRejected.value = true;
        } else if (st == 'pending' || st == '0' || st == 'in_progress') {
          isApproved.value = false;
          isRejected.value = false;
        }
      }
    }
  }

  Future<void> fetchRecentOrders() async {
    try {
      final response = await _getRecentOrdersUseCase();
      if (response.data.isNotEmpty) {
        recentOrders.assignAll(
          response.data.map(
            (o) => DashboardOrderModel(
              id: o.id,
              orderId: o.orderId,
              productName: o.productName,
              quantity: o.quantity,
              status: o.status,
              totalAmount: o.amount.toDouble(),
              createdAt: o.date,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Recent orders fetch error: $e');
    }
  }

  Future<void> fetchBanners() async {
    try {
      isLoadingBanners.value = true;
      final response = await _getBannersUseCase();
      if (response.data.isNotEmpty) {
        banners.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('Banners fetch error: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  Future<bool> toggleOnlineStatus([bool? targetStatus]) async {
    if (isUpdatingStatus.value) return isOnline.value;

    final newStatus = targetStatus ?? !isOnline.value;
    final previousStatus = isOnline.value;

    try {
      isUpdatingStatus.value = true;
      // Optimistically update
      isOnline.value = newStatus;

      final response = await _updateStatusUseCase(
        UpdateStatusRequestModel(isOnline: newStatus),
      );

      if (response.success) {
        if (response.data != null) {
          isOnline.value = response.data!.isOnline;
        }
        AppNotification.showSuccess(
          title: isOnline.value ? 'Store is Online' : 'Store is Offline',
          message: response.message ??
              (isOnline.value
                  ? 'Your store is now accepting orders.'
                  : 'Your store is now offline.'),
        );
        return isOnline.value;
      } else {
        // Revert on failure
        isOnline.value = previousStatus;
        AppNotification.showError(
          title: 'Status Update Failed',
          message: response.message ?? 'Unable to update store status.',
        );
        return isOnline.value;
      }
    } catch (e) {
      isOnline.value = previousStatus;
      debugPrint('Status update error: $e');
      AppNotification.showError(
        title: 'Error',
        message: e.toString().replaceAll('Exception:', '').trim(),
      );
      return isOnline.value;
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> changeTab(int index) async {
    if (index < 0 || index > 3 || index == currentIndex.value) {
      return;
    }

    currentIndex.value = index;
    if (!pageController.hasClients) {
      return;
    }

    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

