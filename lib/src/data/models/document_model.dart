export 'upload_document_model.dart';

class DocumentItemModel {
  final dynamic id;
  final String? name;
  final String? type;
  final String? documentNumber;
  final String? fileUrl;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;

  DocumentItemModel({
    this.id,
    this.name,
    this.type,
    this.documentNumber,
    this.fileUrl,
    this.status,
    this.rejectionReason,
    this.createdAt,
  });

  factory DocumentItemModel.fromJson(Map<String, dynamic> json) {
    return DocumentItemModel(
      id: json['id'],
      name:
          json['name']?.toString() ??
          json['document_name']?.toString() ??
          json['title']?.toString(),
      type:
          json['type']?.toString() ??
          json['document_type']?.toString() ??
          json['doc_type']?.toString(),
      documentNumber:
          json['document_number']?.toString() ??
          json['doc_number']?.toString() ??
          json['number']?.toString(),
      fileUrl:
          json['file_url']?.toString() ??
          json['document_url']?.toString() ??
          json['url']?.toString() ??
          json['file']?.toString() ??
          json['image']?.toString() ??
          json['path']?.toString(),
      status: json['status']?.toString(),
      rejectionReason:
          json['rejection_reason']?.toString() ??
          json['reason']?.toString() ??
          json['reject_reason']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (documentNumber != null) 'document_number': documentNumber,
      if (fileUrl != null) 'file_url': fileUrl,
      if (status != null) 'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}

class RestaurantDocumentsModel {
  final dynamic id;
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

  RestaurantDocumentsModel({
    this.id,
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
    List<DocumentItemModel> itemsList = [];

    if (json['documents'] is List) {
      for (var item in (json['documents'] as List)) {
        if (item is Map) {
          itemsList.add(
            DocumentItemModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    } else if (json['items'] is List) {
      for (var item in (json['items'] as List)) {
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

    final fssai = getVal([
      'fssai',
      'fssai_cert',
      'fssai_image',
      'fssai_file',
      'license_image',
    ]);
    final fssaiNum = getVal([
      'fssai_number',
      'fssai_no',
      'license_no',
      'licenseNo',
    ]);
    final gst = getVal([
      'gst',
      'gst_cert',
      'gst_image',
      'gst_file',
      'gstin_image',
    ]);
    final gstNum = getVal(['gst_number', 'gstin', 'gst_no', 'gstNo']);
    final pan = getVal([
      'pan',
      'pan_card',
      'pan_image',
      'pan_file',
      'pan_no_image',
    ]);
    final panNum = getVal(['pan_number', 'pan_no', 'panNo', 'pan']);
    final aadhaar = getVal([
      'aadhaar',
      'aadhar',
      'aadhaar_card',
      'aadhar_card',
      'aadhaar_image',
      'aadhar_image',
      'aadhar_file',
    ]);
    final aadhaarNum = getVal([
      'aadhaar_number',
      'aadhar_number',
      'aadhaar_no',
      'aadhar_no',
      'aadhar',
    ]);
    final tradeLicense = getVal(['trade_license', 'trade_cert', 'license']);
    final bankPassbook = getVal([
      'bank_passbook',
      'passbook',
      'cheque',
      'bank_statement',
    ]);
    final docStatus = getVal([
      'status',
      'verification_status',
      'document_status',
    ]);
    final reason = getVal(['rejection_reason', 'reason', 'reject_reason']);

    final fssaiStatus =
        getVal(['fssai_status', 'fssai_verification_status']) ?? docStatus;
    final fssaiReason =
        getVal(['fssai_reason', 'fssai_rejection_reason']) ?? reason;

    final gstStatus =
        getVal(['gst_status', 'gst_verification_status', 'gstin_status']) ??
        docStatus;
    final gstReason =
        getVal(['gst_reason', 'gst_rejection_reason', 'gstin_reason']) ??
        reason;

    final panStatus =
        getVal(['pan_status', 'pan_verification_status', 'pan_card_status']) ??
        docStatus;
    final panReason =
        getVal(['pan_reason', 'pan_rejection_reason', 'pan_card_reason']) ??
        reason;

    final aadhaarStatus =
        getVal([
          'aadhaar_status',
          'aadhar_status',
          'aadhaar_verification_status',
        ]) ??
        docStatus;
    final aadhaarReason =
        getVal([
          'aadhaar_reason',
          'aadhar_reason',
          'aadhaar_rejection_reason',
        ]) ??
        reason;

    // If items list was not directly provided, build items from known fields
    if (itemsList.isEmpty) {
      if (fssai != null || fssaiNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'FSSAI Certificate',
            type: 'fssai',
            documentNumber: fssaiNum,
            fileUrl: fssai,
            status: fssaiStatus,
            rejectionReason: fssaiReason,
          ),
        );
      }
      if (gst != null || gstNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'GST Certificate',
            type: 'gst',
            documentNumber: gstNum,
            fileUrl: gst,
            status: gstStatus,
            rejectionReason: gstReason,
          ),
        );
      }
      if (pan != null || panNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'PAN Card',
            type: 'pan',
            documentNumber: panNum,
            fileUrl: pan,
            status: panStatus,
            rejectionReason: panReason,
          ),
        );
      }
      if (aadhaar != null || aadhaarNum != null) {
        itemsList.add(
          DocumentItemModel(
            name: 'Aadhaar Card',
            type: 'aadhaar',
            documentNumber: aadhaarNum,
            fileUrl: aadhaar,
            status: aadhaarStatus,
            rejectionReason: aadhaarReason,
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
        json['gst'] != null) {
      docData = RestaurantDocumentsModel.fromJson(json);
      docList = docData.items;
      isSuccess = true;
    }

    return GetDocumentsResponseModel(
      success: isSuccess,
      message:
          json['message']?.toString() ??
          (isSuccess ? 'Documents fetched successfully' : ''),
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
