export 'upload_document_model.dart';

class IdentityDetailsModel {
  final String? licenseNo;
  final String? aadhar;
  final String? panNo;
  final String? gstin;

  IdentityDetailsModel({
    this.licenseNo,
    this.aadhar,
    this.panNo,
    this.gstin,
  });

  factory IdentityDetailsModel.fromJson(Map<String, dynamic> json) {
    return IdentityDetailsModel(
      licenseNo: json['license_no']?.toString() ??
          json['fssai_no']?.toString() ??
          json['fssai_number']?.toString() ??
          json['license']?.toString(),
      aadhar: json['aadhar']?.toString() ??
          json['aadhaar']?.toString() ??
          json['aadhar_number']?.toString() ??
          json['aadhaar_number']?.toString() ??
          json['aadhar_no']?.toString(),
      panNo: json['pan_no']?.toString() ??
          json['pan']?.toString() ??
          json['pan_number']?.toString() ??
          json['pan_card']?.toString(),
      gstin: json['gstin']?.toString() ??
          json['gst_no']?.toString() ??
          json['gst_number']?.toString() ??
          json['gst']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (licenseNo != null) 'license_no': licenseNo,
      if (aadhar != null) 'aadhar': aadhar,
      if (panNo != null) 'pan_no': panNo,
      if (gstin != null) 'gstin': gstin,
    };
  }
}

class DocumentItemModel {
  final dynamic id;
  final int? documentTypeId;
  final String? name;
  final String? type;
  final String? documentNumber;
  final String? filePath;
  final String? fileUrl;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? uploadedAt;

  DocumentItemModel({
    this.id,
    this.documentTypeId,
    this.name,
    this.type,
    this.documentNumber,
    this.filePath,
    this.fileUrl,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.uploadedAt,
  });

  factory DocumentItemModel.fromJson(Map<String, dynamic> json) {
    final docType = json['document_type']?.toString() ??
        json['type']?.toString() ??
        json['doc_type']?.toString();

    String? displayName = json['name']?.toString() ??
        json['document_name']?.toString() ??
        json['title']?.toString();

    if (displayName == null || displayName.trim().isEmpty) {
      if (docType != null) {
        final lower = docType.toLowerCase();
        if (lower.contains('fssai') || lower.contains('license')) {
          displayName = 'FSSAI Certificate';
        } else if (lower.contains('aadhar') || lower.contains('aadhaar')) {
          displayName = 'Aadhaar Card';
        } else if (lower.contains('pan')) {
          displayName = 'PAN Card';
        } else if (lower.contains('gst')) {
          displayName = 'GST Certificate';
        } else {
          displayName = docType
              .replaceAll('_', ' ')
              .split(' ')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
              .join(' ');
        }
      }
    }

    final docTypeId = json['document_type_id'] is int
        ? json['document_type_id'] as int
        : int.tryParse(json['document_type_id']?.toString() ?? '');

    final uploadedAtStr = json['uploaded_at']?.toString() ?? json['created_at']?.toString();

    return DocumentItemModel(
      id: json['document_id'] ?? json['id'],
      documentTypeId: docTypeId,
      name: displayName,
      type: docType,
      documentNumber: json['document_number']?.toString() ??
          json['doc_number']?.toString() ??
          json['number']?.toString(),
      filePath: json['file_path']?.toString(),
      fileUrl: json['file_url']?.toString() ??
          json['document_url']?.toString() ??
          json['url']?.toString() ??
          json['file']?.toString() ??
          json['image']?.toString() ??
          json['path']?.toString(),
      status: json['status']?.toString(),
      rejectionReason: json['rejection_reason']?.toString() ??
          json['reason']?.toString() ??
          json['reject_reason']?.toString(),
      createdAt: json['created_at']?.toString() ?? uploadedAtStr,
      uploadedAt: uploadedAtStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'document_id': id,
      if (id != null) 'id': id,
      if (documentTypeId != null) 'document_type_id': documentTypeId,
      if (name != null) 'name': name,
      if (type != null) 'document_type': type,
      if (documentNumber != null) 'document_number': documentNumber,
      if (filePath != null) 'file_path': filePath,
      if (fileUrl != null) 'file_url': fileUrl,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (createdAt != null) 'created_at': createdAt,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
    };
  }
}

class RestaurantDocumentsModel {
  final dynamic id;
  final IdentityDetailsModel? identityDetails;
  final String? fssai;
  final String? fssaiNumber;
  final String? gst;
  final String? gstNumber;
  final String? pan;
  final String? panNumber;
  final String? aadhaar;
  final String? aadhaarNumber;
  final String? tradeLicense;
  final String? bankPassbook;
  final String? status;
  final String? rejectionReason;
  final List<DocumentItemModel> items;

  List<DocumentItemModel> get uploadedDocuments => items;

  RestaurantDocumentsModel({
    this.id,
    this.identityDetails,
    this.fssai,
    this.fssaiNumber,
    this.gst,
    this.gstNumber,
    this.pan,
    this.panNumber,
    this.aadhaar,
    this.aadhaarNumber,
    this.tradeLicense,
    this.bankPassbook,
    this.status,
    this.rejectionReason,
    this.items = const [],
  });

  factory RestaurantDocumentsModel.fromJson(Map<String, dynamic> json) {
    IdentityDetailsModel? identityDetails;
    if (json['identity_details'] is Map) {
      identityDetails = IdentityDetailsModel.fromJson(
        Map<String, dynamic>.from(json['identity_details']),
      );
    }

    List<DocumentItemModel> itemsList = [];
    final rawDocs = json['uploaded_documents'] ?? json['documents'] ?? json['items'];

    if (rawDocs is List) {
      for (var item in rawDocs) {
        if (item is Map) {
          itemsList.add(
            DocumentItemModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    String? getVal(List<String> keys) {
      for (final key in keys) {
        if (json[key] != null && json[key].toString().trim().isNotEmpty) {
          return json[key].toString();
        }
      }
      return null;
    }

    String? fssai = getVal([
      'fssai',
      'fssai_cert',
      'fssai_image',
      'fssai_file',
      'license_image',
    ]);
    String? fssaiNum = identityDetails?.licenseNo ??
        getVal([
          'fssai_number',
          'fssai_no',
          'license_no',
          'licenseNo',
        ]);
    String? gst = getVal([
      'gst',
      'gst_cert',
      'gst_image',
      'gst_file',
      'gstin_image',
    ]);
    String? gstNum = identityDetails?.gstin ??
        getVal(['gst_number', 'gstin', 'gst_no', 'gstNo']);
    String? pan = getVal([
      'pan',
      'pan_card',
      'pan_image',
      'pan_file',
      'pan_no_image',
    ]);
    String? panNum = identityDetails?.panNo ??
        getVal(['pan_number', 'pan_no', 'panNo', 'pan']);
    String? aadhaar = getVal([
      'aadhaar',
      'aadhar',
      'aadhaar_card',
      'aadhar_card',
      'aadhaar_image',
      'aadhar_image',
      'aadhar_file',
    ]);
    String? aadhaarNum = identityDetails?.aadhar ??
        getVal([
          'aadhaar_number',
          'aadhar_number',
          'aadhaar_no',
          'aadhar_no',
          'aadhar',
        ]);
    String? tradeLicense = getVal(['trade_license', 'trade_cert', 'license']);
    String? bankPassbook = getVal([
      'bank_passbook',
      'passbook',
      'cheque',
      'bank_statement',
    ]);
    String? docStatus = getVal([
      'status',
      'verification_status',
      'document_status',
    ]);
    String? reason = getVal(['rejection_reason', 'reason', 'reject_reason']);

    String? fssaiStatus =
        getVal(['fssai_status', 'fssai_verification_status']) ?? docStatus;
    String? fssaiReason =
        getVal(['fssai_reason', 'fssai_rejection_reason']) ?? reason;

    String? gstStatus =
        getVal(['gst_status', 'gst_verification_status', 'gstin_status']) ??
        docStatus;
    String? gstReason =
        getVal(['gst_reason', 'gst_rejection_reason', 'gstin_reason']) ??
        reason;

    String? panStatus =
        getVal(['pan_status', 'pan_verification_status', 'pan_card_status']) ??
        docStatus;
    String? panReason =
        getVal(['pan_reason', 'pan_rejection_reason', 'pan_card_reason']) ??
        reason;

    String? aadhaarStatus =
        getVal([
          'aadhaar_status',
          'aadhar_status',
          'aadhaar_verification_status',
        ]) ??
        docStatus;
    String? aadhaarReason =
        getVal([
          'aadhaar_reason',
          'aadhar_reason',
          'aadhaar_rejection_reason',
        ]) ??
        reason;

    // Link URLs, statuses, and document numbers from itemsList
    if (itemsList.isNotEmpty) {
      final updatedItems = <DocumentItemModel>[];
      for (final doc in itemsList) {
        final t = (doc.type ?? doc.name ?? '').toLowerCase();
        String? docNum = doc.documentNumber;

        if (t.contains('fssai') || t.contains('license') || doc.documentTypeId == 1) {
          fssai ??= doc.fileUrl;
          fssaiStatus = doc.status ?? fssaiStatus;
          fssaiReason = doc.rejectionReason ?? fssaiReason;
          docNum ??= fssaiNum;
        } else if (t.contains('aadhar') || t.contains('aadhaar') || doc.documentTypeId == 2) {
          aadhaar ??= doc.fileUrl;
          aadhaarStatus = doc.status ?? aadhaarStatus;
          aadhaarReason = doc.rejectionReason ?? aadhaarReason;
          docNum ??= aadhaarNum;
        } else if (t.contains('pan') || doc.documentTypeId == 3) {
          pan ??= doc.fileUrl;
          panStatus = doc.status ?? panStatus;
          panReason = doc.rejectionReason ?? panReason;
          docNum ??= panNum;
        } else if (t.contains('gst') || doc.documentTypeId == 4) {
          gst ??= doc.fileUrl;
          gstStatus = doc.status ?? gstStatus;
          gstReason = doc.rejectionReason ?? gstReason;
          docNum ??= gstNum;
        }

        updatedItems.add(
          DocumentItemModel(
            id: doc.id,
            documentTypeId: doc.documentTypeId,
            name: doc.name,
            type: doc.type,
            documentNumber: docNum,
            filePath: doc.filePath,
            fileUrl: doc.fileUrl,
            status: doc.status,
            rejectionReason: doc.rejectionReason,
            createdAt: doc.createdAt,
            uploadedAt: doc.uploadedAt,
          ),
        );
      }
      itemsList = updatedItems;
    }

    // If items list was not directly provided, build items from known fields
    if (itemsList.isEmpty) {
      if (fssai != null || fssaiNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'FSSAI Certificate',
            type: 'fssai_file',
            documentTypeId: 1,
            documentNumber: fssaiNum,
            fileUrl: fssai,
            status: fssaiStatus,
            rejectionReason: fssaiReason,
          ),
        );
      }
      if (aadhaar != null || aadhaarNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'Aadhaar Card',
            type: 'aadhar_file',
            documentTypeId: 2,
            documentNumber: aadhaarNum,
            fileUrl: aadhaar,
            status: aadhaarStatus,
            rejectionReason: aadhaarReason,
          ),
        );
      }
      if (pan != null || panNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'PAN Card',
            type: 'pan_file',
            documentTypeId: 3,
            documentNumber: panNum,
            fileUrl: pan,
            status: panStatus,
            rejectionReason: panReason,
          ),
        );
      }
      if (gst != null || gstNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'GST Certificate',
            type: 'gst_file',
            documentTypeId: 4,
            documentNumber: gstNum,
            fileUrl: gst,
            status: gstStatus,
            rejectionReason: gstReason,
          ),
        );
      }
      if (tradeLicense != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'Trade License',
            type: 'trade_license',
            fileUrl: tradeLicense,
            status: docStatus,
          ),
        );
      }
      if (bankPassbook != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'Bank Passbook / Cheque',
            type: 'bank_passbook',
            fileUrl: bankPassbook,
            status: docStatus,
          ),
        );
      }
    }

    return RestaurantDocumentsModel(
      id: json['id'] ?? json['restaurant_id'],
      identityDetails: identityDetails,
      fssai: fssai,
      fssaiNumber: fssaiNum,
      gst: gst,
      gstNumber: gstNum,
      pan: pan,
      panNumber: panNum,
      aadhaar: aadhaar,
      aadhaarNumber: aadhaarNum,
      tradeLicense: tradeLicense,
      bankPassbook: bankPassbook,
      status: docStatus,
      rejectionReason: reason,
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (identityDetails != null) 'identity_details': identityDetails!.toJson(),
      if (fssai != null) 'fssai': fssai,
      if (fssaiNumber != null) 'fssai_number': fssaiNumber,
      if (gst != null) 'gst': gst,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (pan != null) 'pan': pan,
      if (panNumber != null) 'pan_number': panNumber,
      if (aadhaar != null) 'aadhaar': aadhaar,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (tradeLicense != null) 'trade_license': tradeLicense,
      if (bankPassbook != null) 'bank_passbook': bankPassbook,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      'uploaded_documents': items.map((e) => e.toJson()).toList(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class GetDocumentsResponseModel {
  final bool success;
  final String message;
  final RestaurantDocumentsModel? data;
  final List<DocumentItemModel> documents;
  final int? code;

  GetDocumentsResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.documents = const [],
    this.code,
  });

  factory GetDocumentsResponseModel.fromJson(Map<String, dynamic> json) {
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
      isSuccess =
          s == 'success' || s == 'true' || s == '1' || s == '200' || s == 'ok';
    } else if (successVal is bool) {
      isSuccess = successVal;
    } else if (successVal is num) {
      isSuccess = successVal == 1 || successVal == 200 || successVal == 201;
    } else if (successVal is String) {
      final s = successVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == 'ok';
    } else if (codeVal == 200) {
      isSuccess = true;
    }

    RestaurantDocumentsModel? docData;
    List<DocumentItemModel> docList = [];

    dynamic rawData = json['data'] ?? json['documents'] ?? json['result'];

    if (rawData is Map) {
      docData = RestaurantDocumentsModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );
      docList = docData.items;
      isSuccess = true;
    } else if (rawData is List) {
      for (var item in rawData) {
        if (item is Map) {
          docList.add(
            DocumentItemModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
      docData = RestaurantDocumentsModel(items: docList);
      isSuccess = true;
    } else if (json['fssai'] != null ||
        json['aadhaar'] != null ||
        json['pan'] != null ||
        json['gst'] != null ||
        json['uploaded_documents'] != null ||
        json['identity_details'] != null) {
      docData = RestaurantDocumentsModel.fromJson(json);
      docList = docData.items;
      isSuccess = true;
    }

    return GetDocumentsResponseModel(
      success: isSuccess,
      message:
          json['message']?.toString() ??
          (isSuccess ? 'Documents fetched successfully.' : ''),
      data: docData,
      documents: docList,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      'documents': documents.map((e) => e.toJson()).toList(),
      if (code != null) 'code': code,
    };
  }
}
