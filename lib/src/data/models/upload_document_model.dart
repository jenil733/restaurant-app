import 'dart:io';
import 'package:dio/dio.dart';

class UploadDocumentRequestModel {
  final String? gstFilePath;
  final String? fssaiFilePath;
  final String? panFilePath;
  final String? aadharFilePath;
  final String? documentType;
  final String? documentNumber;
  final String? customFilePath;
  final String? customFileKey;
  final String? fssaiNumber;
  final String? aadhaarNumber;
  final String? panNumber;
  final String? gstNumber;

  UploadDocumentRequestModel({
    this.gstFilePath,
    this.fssaiFilePath,
    this.panFilePath,
    this.aadharFilePath,
    this.documentType,
    this.documentNumber,
    this.customFilePath,
    this.customFileKey,
    this.fssaiNumber,
    this.aadhaarNumber,
    this.panNumber,
    this.gstNumber,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {};

    if (documentType != null && documentType!.isNotEmpty) {
      map['document_type'] = documentType;
      map['doc_type'] = documentType;
      map['type'] = documentType;
    }
    if (documentNumber != null && documentNumber!.isNotEmpty) {
      map['document_number'] = documentNumber;
      map['doc_number'] = documentNumber;
      map['number'] = documentNumber;
    }

    if (fssaiNumber != null && fssaiNumber!.isNotEmpty) {
      map['license_no'] = fssaiNumber;
      map['fssai_number'] = fssaiNumber;
      map['fssai_no'] = fssaiNumber;
    }
    if (aadhaarNumber != null && aadhaarNumber!.isNotEmpty) {
      map['aadhar'] = aadhaarNumber;
      map['aadhaar'] = aadhaarNumber;
      map['aadhar_number'] = aadhaarNumber;
      map['aadhaar_number'] = aadhaarNumber;
    }
    if (panNumber != null && panNumber!.isNotEmpty) {
      map['pan_no'] = panNumber;
      map['pan_number'] = panNumber;
      map['pan'] = panNumber;
    }
    if (gstNumber != null && gstNumber!.isNotEmpty) {
      map['gstin'] = gstNumber;
      map['gst_number'] = gstNumber;
      map['gst'] = gstNumber;
    }

    Future<void> attachFileWithAliases(List<String> keys, String? path, [String? docType]) async {
      if (path != null && path.trim().isNotEmpty) {
        final file = File(path.trim());
        if (file.existsSync()) {
          final filename = path.split(RegExp(r'[/\\]')).last;
          for (final key in keys) {
            map[key] = await MultipartFile.fromFile(
              file.path,
              filename: filename,
            );
          }
          if (docType != null && !map.containsKey('document_type')) {
            map['document_type'] = docType;
            map['doc_type'] = docType;
            map['type'] = docType;
          }
        }
      }
    }

    final hasSingleFile = ((aadharFilePath != null && aadharFilePath!.isNotEmpty) ? 1 : 0) +
            ((fssaiFilePath != null && fssaiFilePath!.isNotEmpty) ? 1 : 0) +
            ((panFilePath != null && panFilePath!.isNotEmpty) ? 1 : 0) +
            ((gstFilePath != null && gstFilePath!.isNotEmpty) ? 1 : 0) +
            ((customFilePath != null && customFilePath!.isNotEmpty) ? 1 : 0) == 1;

    // Attach Aadhaar with all possible spellings & aliases
    await attachFileWithAliases(
      [
        'aadhar_file',
        'aadhaar_file',
        'aadhar',
        'aadhaar',
        'aadhar_card',
        'aadhaar_card',
        'aadhar_image',
        'aadhaar_image',
        if (hasSingleFile) ...['file', 'document', 'document_file', 'doc_file'],
      ],
      aadharFilePath,
      'aadhaar',
    );

    // Attach FSSAI with all possible aliases
    await attachFileWithAliases(
      [
        'fssai_file',
        'fssai',
        'fssai_cert',
        'fssai_certificate',
        'fssai_image',
        'license_file',
        'license_image',
        'license',
        if (hasSingleFile) ...['file', 'document', 'document_file', 'doc_file'],
      ],
      fssaiFilePath,
      'fssai',
    );

    // Attach PAN with all possible aliases
    await attachFileWithAliases(
      [
        'pan_file',
        'pan',
        'pan_card',
        'pan_image',
        if (hasSingleFile) ...['file', 'document', 'document_file', 'doc_file'],
      ],
      panFilePath,
      'pan',
    );

    // Attach GST with all possible aliases
    await attachFileWithAliases(
      [
        'gst_file',
        'gst',
        'gst_cert',
        'gst_certificate',
        'gstin_file',
        'gst_image',
        'gstin',
        if (hasSingleFile) ...['file', 'document', 'document_file', 'doc_file'],
      ],
      gstFilePath,
      'gst',
    );

    if (customFileKey != null && customFilePath != null) {
      await attachFileWithAliases(
        [
          customFileKey!,
          if (hasSingleFile) ...['file', 'document', 'document_file'],
        ],
        customFilePath,
      );
    }

    return FormData.fromMap(map);
  }
}

class UploadDocumentResponseModel {
  final bool success;
  final String message;
  final String? fileUrl;
  final Map<String, dynamic>? data;
  final int? code;

  UploadDocumentResponseModel({
    required this.success,
    required this.message,
    this.fileUrl,
    this.data,
    this.code,
  });

  factory UploadDocumentResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    final statusVal = json['status'];
    final successVal = json['success'];
    final codeVal = json['code'] is int
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');

    if (statusVal is bool) {
      isSuccess = statusVal;
    } else if (statusVal is num) {
      isSuccess = statusVal == 1 || statusVal == 200 || statusVal == 201;
    } else if (statusVal is String) {
      final s = statusVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == '200' || s == 'ok';
    } else if (successVal is bool) {
      isSuccess = successVal;
    } else if (successVal is num) {
      isSuccess = successVal == 1 || successVal == 200 || successVal == 201;
    } else if (successVal is String) {
      final s = successVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == 'ok';
    } else if (codeVal == 200 || codeVal == 201) {
      isSuccess = true;
    }

    String? fileUrl;
    Map<String, dynamic>? dataMap;

    if (json['data'] is Map) {
      dataMap = Map<String, dynamic>.from(json['data'] as Map);
      fileUrl = dataMap['file_url']?.toString() ??
          dataMap['url']?.toString() ??
          dataMap['file']?.toString() ??
          dataMap['image']?.toString();
    } else if (json['url'] != null || json['file_url'] != null) {
      fileUrl = (json['file_url'] ?? json['url'])?.toString();
    }

    return UploadDocumentResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? (isSuccess ? 'Document uploaded successfully' : ''),
      fileUrl: fileUrl,
      data: dataMap,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (fileUrl != null) 'file_url': fileUrl,
      if (data != null) 'data': data,
      if (code != null) 'code': code,
    };
  }
}
