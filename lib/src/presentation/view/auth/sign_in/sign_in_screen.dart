import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/data/repository/document_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/get_documents_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_back_button.dart';
import 'package:restaurant_app/src/presentation/widgets/app_button.dart';
import 'package:restaurant_app/src/presentation/widgets/app_dashed_border.dart';
import 'package:restaurant_app/src/presentation/widgets/app_form_field.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_profile_image.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/store_verification_card.dart';

class SignInScreen extends StatefulWidget {
  final int initialStep;
  final bool isReuploadMode;
  final String? rejectionReason;
  final String? rejectedDocName;
  final List<String>? rejectedDocNames;

  const SignInScreen({
    super.key,
    this.initialStep = 0,
    this.isReuploadMode = false,
    this.rejectionReason,
    this.rejectedDocName,
    this.rejectedDocNames,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final SignInController controller;

  static const List<String> _titles = [
    'Register',
    'Document Details',
    'Bank Details',
    'Legal Information',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SignInController>()
        ? Get.find<SignInController>()
        : Get.put(SignInController());

    if (widget.initialStep != 0) {
      controller.currentStep.value = widget.initialStep;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.pageController.hasClients) {
          controller.pageController.jumpToPage(widget.initialStep);
        }
      });
    }

    if (widget.isReuploadMode) {
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        if (profileCtrl.licenseNo.value.isNotEmpty &&
            controller.fssaiController.text.isEmpty) {
          controller.fssaiController.text = profileCtrl.licenseNo.value;
        }
        if (profileCtrl.gstin.value.isNotEmpty &&
            controller.gstController.text.isEmpty) {
          controller.gstController.text = profileCtrl.gstin.value;
        }
        if (profileCtrl.panNo.value.isNotEmpty &&
            controller.panController.text.isEmpty) {
          controller.panController.text = profileCtrl.panNo.value;
        }
        if (profileCtrl.aadhar.value.isNotEmpty &&
            controller.aadhaarController.text.isEmpty) {
          controller.aadhaarController.text = profileCtrl.aadhar.value;
        }
      }

      _fetchDocumentNumbers();
    }
  }

  Future<void> _fetchDocumentNumbers() async {
    try {
      final getDocsUseCase = sl.isRegistered<GetDocumentsUseCase>()
          ? sl<GetDocumentsUseCase>()
          : GetDocumentsUseCase(
              DocumentRepositoryImpl(
                sl.isRegistered<ApiService>() ? sl<ApiService>() : ApiService(),
              ),
            );

      final resp = await getDocsUseCase();
      if (!mounted) return;

      final data = resp.data;
      if (data != null) {
        if (data.fssaiNumber != null &&
            data.fssaiNumber!.isNotEmpty &&
            controller.fssaiController.text.isEmpty) {
          controller.fssaiController.text = data.fssaiNumber!;
        }
        if (data.panNumber != null &&
            data.panNumber!.isNotEmpty &&
            controller.panController.text.isEmpty) {
          controller.panController.text = data.panNumber!;
        }
        if (data.aadhaarNumber != null &&
            data.aadhaarNumber!.isNotEmpty &&
            controller.aadhaarController.text.isEmpty) {
          controller.aadhaarController.text = data.aadhaarNumber!;
        }
        if (data.gstNumber != null &&
            data.gstNumber!.isNotEmpty &&
            controller.gstController.text.isEmpty) {
          controller.gstController.text = data.gstNumber!;
        }
      }

      for (final doc in resp.documents) {
        final type = (doc.type ?? doc.name ?? '').toLowerCase().trim();
        final num = doc.documentNumber;
        if (num != null && num.isNotEmpty) {
          if ((type.contains('fssai') || type.contains('license')) &&
              controller.fssaiController.text.isEmpty) {
            controller.fssaiController.text = num;
          } else if (type.contains('pan') &&
              controller.panController.text.isEmpty) {
            controller.panController.text = num;
          } else if ((type.contains('aadhar') || type.contains('aadhaar')) &&
              controller.aadhaarController.text.isEmpty) {
            controller.aadhaarController.text = num;
          } else if (type.contains('gst') &&
              controller.gstController.text.isEmpty) {
            controller.gstController.text = num;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching document numbers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            children: [
              Obx(
                () => _StepHeader(
                  title: _titles[controller.currentStep.value],
                  onBack: widget.isReuploadMode
                      ? () => Get.back()
                      : controller.previousStep,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _RegisterStep(controller: controller),
                    _DocumentDetailsStep(
                      controller: controller,
                      isReuploadMode: widget.isReuploadMode,
                      rejectionReason: widget.rejectionReason,
                      rejectedDocName: widget.rejectedDocName,
                      rejectedDocNames: widget.rejectedDocNames,
                    ),
                    _BankDetailsStep(controller: controller),
                    _LegalInformationStep(controller: controller),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => AppButton(
                  text: widget.isReuploadMode
                      ? 'Submit'
                      : (controller.currentStep.value ==
                                SignInController.stepCount - 1
                            ? 'Submit'
                            : 'Continue'),
                  width: double.infinity,
                  style: TextHelper.button,
                  isLoading: controller.isLoading.value,
                  onPressed: widget.isReuploadMode
                      ? controller.submitReuploadDocuments
                      : controller.nextStep,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBackButton(onPressed: onBack),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextHelper.login,
          ),
        ),
      ],
    );
  }
}

class _StepForm extends StatelessWidget {
  const _StepForm({required this.formKey, required this.children});

  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _RegisterStep extends StatelessWidget {
  const _RegisterStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return _StepForm(
      formKey: controller.formKeys[0],
      children: [
        Center(
          child: Semantics(
            button: true,
            label: 'Add restaurant profile photo',
            child: GestureDetector(
              onTap: () => _showImageSourceSheet(
                context,
                onSelect: (source) => controller.pickProfileImage(source),
              ),
              child: SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final imagePath = controller.profileImagePath.value;
                      if (imagePath != null && imagePath.isNotEmpty) {
                        return Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.12),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.file(File(imagePath), fit: BoxFit.cover),
                        );
                      }
                      return const AppProfileImage(size: 110);
                    }),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textprimary.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(camera, width: 30, height: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        AppFormField(
          label: 'Restaurant Name',
          controller: controller.restaurantNameController,
          isRequired: true,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Owner Name',
          controller: controller.ownerNameController,
          isRequired: true,
          validator: controller.requiredValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Phone No',
          controller: controller.phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          hintText: '0000 000 000',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+91', style: TextHelper.heading2.copyWith(fontSize: 12)),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: AppColors.textprimary.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 16,
                  color: AppColors.textprimary.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: controller.phoneValidator,
        ),
        const SizedBox(height: 12),
        _RestaurantTypeField(controller: controller),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Email',
          controller: controller.emailController,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          validator: controller.emailValidator,
        ),
        const SizedBox(height: 12),
        AppFormField(label: 'City', controller: controller.cityController),
        const SizedBox(height: 12),
        AppFormField(label: 'Street', controller: controller.streetController),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Address',
          controller: controller.addressController,
        ),
        const SizedBox(height: 12),
        AppFormField(
          label: 'Pincode',
          controller: controller.pincodeController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: controller.pincodeValidator,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppFormField(
                label: 'Start Time',
                controller: controller.startTimeController,
                hintText: '--/--',
                readOnly: true,
                onTap: () => _pickTime(context, controller.startTimeController),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: AppColors.textprimary.withValues(alpha: 0.4),
                  ),
                  onPressed: () =>
                      _pickTime(context, controller.startTimeController),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppFormField(
                label: 'End Time',
                controller: controller.endTimeController,
                hintText: '--/--',
                readOnly: true,
                onTap: () => _pickTime(context, controller.endTimeController),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: AppColors.textprimary.withValues(alpha: 0.4),
                  ),
                  onPressed: () =>
                      _pickTime(context, controller.endTimeController),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    TextEditingController textController,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      textController.text = picked.format(context);
    }
  }
}

class _RestaurantTypeField extends StatefulWidget {
  const _RestaurantTypeField({required this.controller});

  final SignInController controller;

  @override
  State<_RestaurantTypeField> createState() => _RestaurantTypeFieldState();
}

class _RestaurantTypeFieldState extends State<_RestaurantTypeField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.controller.restaurantType.value != null &&
        widget.controller.restaurantTypeController.text.isEmpty) {
      widget.controller.restaurantTypeController.text =
          widget.controller.restaurantType.value!;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildTypeBadge(String type) {
    Color color;
    IconData icon;
    final lower = type.toLowerCase();
    if (lower.contains('non')) {
      color = const Color(0xFFD32F2F);
      icon = Icons.stop_circle_rounded;
    } else if (lower.contains('both')) {
      color = AppColors.primary;
      icon = Icons.restaurant_menu_rounded;
    } else {
      color = const Color(0xFF388E3C);
      icon = Icons.eco_rounded;
    }
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 12, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Restaurant Type',
            style: TextHelper.heading2,
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.heading2.copyWith(
                  color: AppColors.red,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return RawAutocomplete<String>(
              textEditingController: widget.controller.restaurantTypeController,
              focusNode: _focusNode,
              optionsBuilder: (TextEditingValue textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                final types = SignInController.availableRestaurantTypes;
                if (query.isEmpty) {
                  return types;
                }
                final filtered = types.where((type) {
                  final t = type.toLowerCase();
                  return t.contains(query) ||
                      (query.startsWith('veg') && t == 'veg') ||
                      (query.startsWith('non') && t == 'non-veg') ||
                      (query.startsWith('b') && t == 'both');
                }).toList();
                return filtered.isNotEmpty ? filtered : types;
              },
              onSelected: (String selection) {
                widget.controller.setRestaurantType(selection);
                _focusNode.unfocus();
              },
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: TextHelper.heading2.copyWith(fontSize: 12),
                      onChanged: (val) {
                        widget.controller.restaurantType.value =
                            val.trim().isEmpty ? null : val.trim();
                      },
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Restaurant type is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter type (Veg, Non-Veg, Both)',
                        hintStyle: TextHelper.heading2.copyWith(
                          color: AppColors.textprimary.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textprimary.withValues(alpha: 0.5),
                            size: 20,
                          ),
                          onPressed: () {
                            if (focusNode.hasFocus) {
                              focusNode.unfocus();
                            } else {
                              focusNode.requestFocus();
                            }
                          },
                        ),
                        enabledBorder: _fieldBorder(
                          AppColors.primary.withValues(alpha: 0.2),
                        ),
                        focusedBorder: _fieldBorder(AppColors.primary),
                        errorBorder: _fieldBorder(AppColors.red),
                        focusedErrorBorder: _fieldBorder(AppColors.red),
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                    shadowColor: AppColors.textprimary.withValues(alpha: 0.2),
                    child: Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: AppColors.textprimary.withValues(alpha: 0.08),
                        ),
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  _buildTypeBadge(option),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextHelper.heading2.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textprimary,
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   'Select',
                                  //   style: TextHelper.heading2.copyWith(
                                  //     fontSize: 11,
                                  //     color: AppColors.primary,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 4),
                                  // Icon(
                                  //   Icons.arrow_forward_ios_rounded,
                                  //   size: 10,
                                  //   color: AppColors.primary,
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _DocumentDetailsStep extends StatelessWidget {
  const _DocumentDetailsStep({
    required this.controller,
    this.isReuploadMode = false,
    this.rejectionReason,
    this.rejectedDocName,
    this.rejectedDocNames,
  });

  final SignInController controller;
  final bool isReuploadMode;
  final String? rejectionReason;
  final String? rejectedDocName;
  final List<String>? rejectedDocNames;

  List<String> get _effectiveRejectedDocs {
    final List<String> list = [];
    if (rejectedDocNames != null && rejectedDocNames!.isNotEmpty) {
      list.addAll(rejectedDocNames!);
    }
    if (rejectedDocName != null && rejectedDocName!.trim().isNotEmpty) {
      list.add(rejectedDocName!.trim());
    }
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      list.addAll(homeCtrl.rejectedDocuments);
      if (homeCtrl.rejectedDocument.value != null &&
          homeCtrl.rejectedDocument.value!.isNotEmpty) {
        list.add(homeCtrl.rejectedDocument.value!);
      }
    }
    return list;
  }

  String? get _effectiveRejectionReason {
    if (rejectionReason != null && rejectionReason!.trim().isNotEmpty) {
      return rejectionReason!.trim();
    }
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>().rejectionReason.value;
    }
    return null;
  }

  bool _isDocRejected(String label) {
    if (!isReuploadMode) return false;
    final docs = _effectiveRejectedDocs;
    final reason = (_effectiveRejectionReason ?? '').toLowerCase().trim();

    bool matches(String text, String key) {
      final t = text.toLowerCase();
      if (key == 'fssai') {
        return t.contains('fssai') || t.contains('license');
      }
      if (key == 'gst') {
        return t.contains('gst');
      }
      if (key == 'pan') {
        return t.contains('pan');
      }
      if (key == 'aadhaar') {
        return t.contains('aadhar') || t.contains('aadhaar');
      }
      return false;
    }

    String docKey = '';
    if (label == 'FSSAI Certificate') docKey = 'fssai';
    if (label == 'GST Certificate') docKey = 'gst';
    if (label == 'PAN Card') docKey = 'pan';
    if (label == 'Aadhaar Card') docKey = 'aadhaar';

    for (final doc in docs) {
      if (matches(doc, docKey)) return true;
    }

    if (docs.isEmpty && matches(reason, docKey)) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isFssaiRej = _isDocRejected('FSSAI Certificate');
    final isAadhaarRej = _isDocRejected('Aadhaar Card');
    final isPanRej = _isDocRejected('PAN Card');
    final isGstRej = _isDocRejected('GST Certificate');

    final reason = _effectiveRejectionReason;
    final docTitle = formatRejectedDocTitle(
      docNames: _effectiveRejectedDocs,
      docName: rejectedDocName,
      reason: reason,
    );

    final isPlural = docTitle.contains('&') || docTitle.contains(',');
    final headerVerb = isPlural ? 'Have' : 'Has';

    return _StepForm(
      formKey: controller.formKeys[1],
      children: [
        if (reason != null && reason.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6EB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE0B2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ Your $docTitle $headerVerb Been Rejected By Admin.',
                  style: TextHelper.heading2.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
                        text: reason,
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
        ],
        AppFormField(
          label: 'FSSAI License Number',
          isRequired: !isReuploadMode || isFssaiRej,
          controller: controller.fssaiController,
          hintText: '14-digit FSSAI number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14),
          ],
          validator: isReuploadMode
              ? (val) {
                  if (val == null || val.trim().isEmpty) return null;
                  return controller.fssaiValidator(val);
                }
              : controller.fssaiValidator,
        ),
        const SizedBox(height: 8),
        _DocumentUploadTile(
          label: 'FSSAI Certificate',
          isRequired: !isReuploadMode || isFssaiRej,
          controller: controller,
          isReuploadMode: isReuploadMode,
          isRejected: isFssaiRej,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Aadhaar Number',
          isRequired: !isReuploadMode || isAadhaarRej,
          controller: controller.aadhaarController,
          hintText: '12-digit Aadhaar number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          validator: isReuploadMode
              ? (val) {
                  if (val == null || val.trim().isEmpty) return null;
                  return controller.aadhaarValidator(val);
                }
              : controller.aadhaarValidator,
        ),
        const SizedBox(height: 8),
        _DocumentUploadTile(
          label: 'Aadhaar Card',
          isRequired: !isReuploadMode || isAadhaarRej,
          controller: controller,
          isReuploadMode: isReuploadMode,
          isRejected: isAadhaarRej,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'PAN Number',
          isRequired: !isReuploadMode || isPanRej,
          controller: controller.panController,
          hintText: 'ABCDE1234F',
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          validator: isReuploadMode
              ? (val) {
                  if (val == null || val.trim().isEmpty) return null;
                  return controller.panValidator(val);
                }
              : controller.panValidator,
        ),
        const SizedBox(height: 8),
        _DocumentUploadTile(
          label: 'PAN Card',
          isRequired: !isReuploadMode || isPanRej,
          controller: controller,
          isReuploadMode: isReuploadMode,
          isRejected: isPanRej,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'GSTIN (Optional)',
          isRequired: false,
          controller: controller.gstController,
          hintText: '15-character GSTIN',
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(15)],
          validator: isReuploadMode && !isGstRej
              ? null
              : controller.gstinValidator,
        ),
        const SizedBox(height: 8),
        _DocumentUploadTile(
          label: 'GST Certificate',
          isRequired: false,
          controller: controller,
          isReuploadMode: isReuploadMode,
          isRejected: isGstRej,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _BankDetailsStep extends StatelessWidget {
  const _BankDetailsStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return _StepForm(
      formKey: controller.formKeys[2],
      children: [
        AppFormField(
          label: 'Account Holder Name',
          isRequired: true,
          controller: controller.accountHolderController,
          hintText: 'e.g. John Doe',
          textCapitalization: TextCapitalization.words,
          validator: controller.accountHolderValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Bank Name',
          isRequired: true,
          controller: controller.bankNameController,
          hintText: 'e.g. State Bank of India',
          textCapitalization: TextCapitalization.words,
          validator: controller.bankNameValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Account Number',
          isRequired: true,
          controller: controller.accountNumberController,
          hintText: '9 to 18 digits account number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          validator: controller.accountNumberValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'IFSC Code',
          isRequired: true,
          controller: controller.ifscController,
          hintText: 'e.g. SBIN0001234',
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(11)],
          validator: controller.ifscValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'Branch Name',
          isRequired: true,
          controller: controller.branchNameController,
          hintText: 'e.g. Anna Nagar Branch',
          textCapitalization: TextCapitalization.words,
          validator: controller.branchNameValidator,
        ),
        const SizedBox(height: 16),
        AppFormField(
          label: 'UPI ID (Optional)',
          controller: controller.upiController,
          hintText: 'e.g. restaurant@okhdfcbank',
          validator: controller.upiValidator,
        ),
      ],
    );
  }
}

class _DocumentUploadTile extends StatelessWidget {
  const _DocumentUploadTile({
    required this.label,
    required this.controller,
    this.isRequired = true,
    this.isReuploadMode = false,
    this.isRejected = false,
  });

  final String label;
  final SignInController controller;
  final bool isRequired;
  final bool isReuploadMode;
  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: 'Upload $label',
                style: TextHelper.heading2,
                children: [
                  if (isRequired && (!isReuploadMode || isRejected))
                    TextSpan(
                      text: ' *',
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.red,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            if (isReuploadMode && !isRejected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 12, color: Colors.green.shade700),
                    const SizedBox(width: 3),
                    Text(
                      'Uploaded',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              )
            else if (isReuploadMode && isRejected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Rejected (Re-upload)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Obx(() {
          final isSelected = controller.selectedDocuments.contains(label);
          String? filePath;
          if (label == 'FSSAI Certificate')
            filePath = controller.fssaiFilePath.value;
          if (label == 'Aadhaar Card')
            filePath = controller.aadharFilePath.value;
          if (label == 'PAN Card') filePath = controller.panFilePath.value;
          if (label == 'GST Certificate')
            filePath = controller.gstFilePath.value;

          // In reupload mode, non-rejected documents show as uploaded by default
          final isAlreadyUploaded =
              isReuploadMode && !isRejected && !isSelected;
          final isDone = isSelected || isAlreadyUploaded;

          return InkWell(
            onTap: () => _showImageSourceSheet(
              context,
              onSelect: (source) => controller.pickDocument(label, source),
            ),
            borderRadius: BorderRadius.circular(6),
            child: AppDashedBorder(
              color: isDone
                  ? AppColors.green
                  : (isRejected
                        ? AppColors.red
                        : AppColors.red.withValues(alpha: 0.24)),
              borderRadius: 6,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isDone
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.green,
                            size: 20,
                          )
                        : SvgPicture.asset(uploadIcon, width: 18, height: 21),
                    const SizedBox(height: 4),
                    Text(
                      isSelected
                          ? (filePath != null
                                ? filePath.split(Platform.pathSeparator).last
                                : 'Selected')
                          : (isAlreadyUploaded
                                ? 'Uploaded'
                                : 'Click To Upload'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextHelper.heading2.copyWith(
                        color: isDone ? AppColors.green : AppColors.textprimary,
                        fontSize: 9,
                      ),
                    ),
                    if (!isDone)
                      Text(
                        isRejected
                            ? '(Tap to re-upload certificate)'
                            : '(Max file size: 5 MB, jpg only)',
                        style: TextHelper.heading2.copyWith(
                          color: isRejected
                              ? AppColors.red
                              : AppColors.textprimary.withValues(alpha: 0.35),
                          fontSize: 7,
                          fontWeight: isRejected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      )
                    else if (isAlreadyUploaded)
                      Text(
                        '(Tap to replace if needed)',
                        style: TextHelper.heading2.copyWith(
                          color: AppColors.textprimary.withValues(alpha: 0.35),
                          fontSize: 7,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _LegalInformationStep extends StatelessWidget {
  const _LegalInformationStep({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegalTextArea(
            label: 'Terms & condition',
            controller: controller.termsController,
            validator: controller.requiredValidator,
          ),
          const SizedBox(height: 10),
          _LegalTextArea(
            label: 'Privacy & Policy',
            controller: controller.privacyController,
            validator: controller.requiredValidator,
          ),
          const Spacer(),
          _AcceptanceRow(controller: controller),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _LegalTextArea extends StatelessWidget {
  const _LegalTextArea({
    required this.label,
    required this.controller,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextHelper.heading2),
        const SizedBox(height: 7),
        AppDashedBorder(
          color: AppColors.red.withValues(alpha: 0.22),
          borderRadius: 5,
          child: SizedBox(
            height: 100,
            child: TextFormField(
              controller: controller,
              validator: validator,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: TextHelper.heading2.copyWith(fontSize: 10),
              decoration: InputDecoration(
                hintText: 'Enter',
                hintStyle: TextHelper.heading2.copyWith(
                  color: AppColors.textprimary.withValues(alpha: 0.25),
                ),
                contentPadding: const EdgeInsets.fromLTRB(11, 9, 11, 7),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AcceptanceRow extends StatelessWidget {
  const _AcceptanceRow({required this.controller});

  final SignInController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            checked: controller.acceptedTerms.value,
            label: 'Accept Terms of Service and Privacy Policy',
            child: InkWell(
              onTap: controller.acceptedTerms.toggle,
              borderRadius: BorderRadius.circular(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: controller.acceptedTerms.value
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: controller.acceptedTerms.value
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 11,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Registration implies acceptance of the ',
                style: TextHelper.heading2.copyWith(
                  color: AppColors.textprimary.withValues(alpha: 0.55),
                  fontSize: 10,
                ),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextHelper.heading2.copyWith(
                      color: AppColors.primary,
                      fontSize: 8,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy.',
                    style: TextHelper.heading2.copyWith(
                      color: AppColors.primary,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: color),
  );
}

void _showImageSourceSheet(
  BuildContext context, {
  required ValueChanged<ImageSource> onSelect,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Source',
              style: TextHelper.login.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(ctx);
                    onSelect(ImageSource.camera);
                  },
                ),
                _SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(ctx);
                    onSelect(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextHelper.heading2),
          ],
        ),
      ),
    );
  }
}
