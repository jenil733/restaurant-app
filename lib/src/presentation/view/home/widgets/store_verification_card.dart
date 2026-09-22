import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/view/auth/sign_in/sign_in_screen.dart';

String formatRejectedDocTitle({
  List<String>? docNames,
  String? docName,
  String? reason,
}) {
  final Set<String> titles = {};

  void checkString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('pan')) {
      titles.add('PAN Card');
    }
    if (lower.contains('gst')) {
      titles.add('GST Certificate');
    }
    if (lower.contains('fssai') || lower.contains('license')) {
      titles.add('FSSAI Certificate');
    }
    if (lower.contains('aadhar') || lower.contains('aadhaar')) {
      titles.add('Aadhaar Card');
    }
  }

  if (docNames != null) {
    for (var d in docNames) {
      checkString(d);
    }
  }
  if (docName != null && docName.trim().isNotEmpty) {
    checkString(docName);
  }
  if (titles.isEmpty && reason != null && reason.trim().isNotEmpty) {
    checkString(reason);
  }

  if (titles.isEmpty) {
    return (docName != null && docName.trim().isNotEmpty) ? docName.trim() : 'Document';
  }

  final list = titles.toList();
  if (list.length == 1) return list.first;
  if (list.length == 2) return '${list[0]} & ${list[1]}';
  return '${list.sublist(0, list.length - 1).join(', ')} & ${list.last}';
}

class StoreVerificationCard extends StatelessWidget {
  const StoreVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

    return Obx(() {
      final isRejected = homeCtrl?.isRejected.value == true;
      final rejDoc = homeCtrl?.rejectedDocument.value;
      final rejDocs = homeCtrl?.rejectedDocuments;
      final rejReason = homeCtrl?.rejectionReason.value;

      final rejTitle = formatRejectedDocTitle(
        docNames: rejDocs,
        docName: rejDoc,
        reason: rejReason,
      );

      return GestureDetector(
        onTap: () {
          Get.to(
            () => SignInScreen(
              initialStep: 1,
              isReuploadMode: true,
              rejectedDocName: isRejected ? rejTitle : null,
              rejectedDocNames: isRejected ? (rejDocs?.isNotEmpty == true ? rejDocs : (rejDoc != null ? [rejDoc] : null)) : null,
              rejectionReason: isRejected ? rejReason : null,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      homeStoreImg,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                storeIcon,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Store Verification\nin Progress',
                                style: TextHelper.heading2.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textprimary,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your restaurant has been submitted successfully. We will be reviewing your documents and details.',
                          style: TextHelper.heading2.copyWith(
                            fontSize: 11,
                            color: AppColors.textprimary.withValues(alpha: 0.7),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: AppColors.textprimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Estimated Approval',
                          style: TextHelper.heading2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textprimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text.rich(
                      TextSpan(
                        text: 'Within ',
                        style: TextHelper.heading2.copyWith(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                        children: [
                          TextSpan(
                            text: '24',
                            style: TextHelper.heading2.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' Hours',
                            style: TextHelper.heading2.copyWith(
                              fontSize: 14,
                              color: AppColors.primary,
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
      );
    });
  }
}

class RejectionNoteCard extends StatelessWidget {
  final String reason;
  final String? docName;
  final List<String>? docNames;
  final VoidCallback? onTap;

  const RejectionNoteCard({
    super.key,
    required this.reason,
    this.docName,
    this.docNames,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final allDocNames = docNames ?? homeCtrl?.rejectedDocuments;
    final allDocSingle = docName ?? homeCtrl?.rejectedDocument.value;
    final allReason = reason.isNotEmpty ? reason : (homeCtrl?.rejectionReason.value ?? '');

    final rejectedTitle = formatRejectedDocTitle(
      docNames: allDocNames,
      docName: allDocSingle,
      reason: allReason,
    );

    final isPlural = rejectedTitle.contains('&') || rejectedTitle.contains(',');
    final headerVerb = isPlural ? 'Have' : 'Has';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ??
            () => Get.to(
                  () => SignInScreen(
                    initialStep: 1,
                    isReuploadMode: true,
                    rejectedDocName: allDocSingle,
                    rejectedDocNames: allDocNames?.isNotEmpty == true ? allDocNames : (allDocSingle != null ? [allDocSingle] : null),
                    rejectionReason: allReason,
                  ),
                ),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6EB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                spreadRadius: 0.5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Note:',
                style: TextHelper.heading2.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '⚠️ Your $rejectedTitle $headerVerb Been Rejected By Admin.',
                style: TextHelper.heading2.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textprimary,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: 'Reason: ',
                  style: TextHelper.heading2.copyWith(
                    fontSize: 11.5,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: allReason.isNotEmpty ? allReason : 'The Uploaded Document is Incorrect.',
                      style: TextHelper.heading2.copyWith(
                        fontSize: 11.5,
                        color: AppColors.textprimary,
                        fontWeight: FontWeight.normal,
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
}
