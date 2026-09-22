class ProfileModel {
  final dynamic id;
  final String? restaurantName;
  final String? ownerName;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? street;
  final String? pincode;
  final String? landmark;
  final String? startTime;
  final String? endTime;
  final String? foodType;
  final String? image;
  final dynamic status;
  final bool isActive;
  final bool isOnline;
  final String? licenseNo;
  final String? gstin;
  final String? panNo;
  final String? aadhar;
  final String? businessStatus;
  final String? accountHolder;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branch;
  final String? upiId;

  ProfileModel({
    this.id,
    this.restaurantName,
    this.ownerName,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.street,
    this.pincode,
    this.landmark,
    this.startTime,
    this.endTime,
    this.foodType,
    this.image,
    this.status,
    this.isActive = true,
    this.isOnline = false,
    this.licenseNo,
    this.gstin,
    this.panNo,
    this.aadhar,
    this.businessStatus,
    this.accountHolder,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.upiId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> raw) {
    Map<String, dynamic>? profileMap;
    Map<String, dynamic>? businessMap;
    Map<String, dynamic>? bankMap;

    if (raw['profile'] is Map) {
      profileMap = Map<String, dynamic>.from(raw['profile'] as Map);
    }
    if (raw['business'] is Map) {
      businessMap = Map<String, dynamic>.from(raw['business'] as Map);
    }
    if (raw['bank_details'] is Map) {
      bankMap = Map<String, dynamic>.from(raw['bank_details'] as Map);
    }

    dynamic getVal(List<String> keys) {
      for (final key in keys) {
        if (profileMap != null &&
            profileMap[key] != null &&
            profileMap[key].toString().trim().isNotEmpty) {
          return profileMap[key];
        }
        if (businessMap != null &&
            businessMap[key] != null &&
            businessMap[key].toString().trim().isNotEmpty) {
          return businessMap[key];
        }
        if (bankMap != null &&
            bankMap[key] != null &&
            bankMap[key].toString().trim().isNotEmpty) {
          return bankMap[key];
        }
        if (raw[key] != null && raw[key].toString().trim().isNotEmpty) {
          return raw[key];
        }
      }
      return null;
    }

    bool isLikelyFilePath(String str) {
      final s = str.toLowerCase().trim();
      return s.startsWith('http://') ||
          s.startsWith('https://') ||
          s.startsWith('data:image') ||
          s.startsWith('storage/') ||
          s.startsWith('/storage/') ||
          s.contains('/uploads/') ||
          s.endsWith('.jpg') ||
          s.endsWith('.jpeg') ||
          s.endsWith('.png') ||
          s.endsWith('.webp') ||
          s.endsWith('.pdf');
    }

    String? getNumberVal(List<String> keys) {
      final val = getVal(keys)?.toString();
      if (val != null && val.trim().isNotEmpty && !isLikelyFilePath(val)) {
        return val.trim();
      }
      return null;
    }

    bool active = true;
    final statusVal = getVal([
      'Restaurant_status',
      'restaurant_status',
      'status',
      'verification_status',
      'business_status',
      'is_active',
      'online_status',
      'is_online',
    ]);
    if (statusVal != null) {
      if (statusVal is bool) {
        active = statusVal;
      } else if (statusVal is num) {
        active = statusVal == 1 || statusVal == 200;
      } else if (statusVal is String) {
        final s = statusVal.toLowerCase().trim();
        active =
            s == '1' ||
            s == 'active' ||
            s == 'true' ||
            s == 'online' ||
            s == 'enable' ||
            s == 'approved';
      }
    }

    bool isOnline = false;
    final onlineVal = businessMap?['is_online'] ?? raw['is_online'];
    if (onlineVal is bool) {
      isOnline = onlineVal;
    } else if (onlineVal is num) {
      isOnline = onlineVal == 1;
    } else if (onlineVal is String) {
      isOnline =
          onlineVal.toLowerCase().trim() == 'true' || onlineVal.trim() == '1';
    }

    return ProfileModel(
      id: getVal(['id', 'restaurant_id', 'user_id']),
      restaurantName: getVal([
        'restaurant_name',
        'name',
        'business_name',
        'title',
      ])?.toString(),
      ownerName: getVal([
        'owner_name',
        'owner',
        'user_name',
        'contact_person',
      ])?.toString(),
      phone: getVal([
        'phone',
        'mobile',
        'phone_number',
        'contact_number',
      ])?.toString(),
      email: getVal(['email', 'email_address'])?.toString(),
      address: getVal([
        'address',
        'restaurant_address',
        'location',
      ])?.toString(),
      city: getVal(['city'])?.toString(),
      street: getVal(['street', 'street_name'])?.toString(),
      pincode: getVal(['pincode', 'pin', 'postal_code'])?.toString(),
      landmark: getVal(['landmark'])?.toString(),
      startTime: getVal([
        'start_time',
        'opening_time',
        'open_time',
      ])?.toString(),
      endTime: getVal(['end_time', 'closing_time', 'close_time'])?.toString(),
      foodType: getVal(['food_type', 'restaurant_type', 'type'])?.toString(),
      image: getVal(['image', 'profile_image', 'logo', 'photo'])?.toString(),
      status: getVal([
        'Restaurant_status',
        'restaurant_status',
        'status',
        'verification_status',
        'business_status',
      ]),
      isActive: active,
      isOnline: isOnline,
      licenseNo: getNumberVal([
        'license_no',
        'license',
        'license_number',
        'licenseNo',
        'fssai_number',
        'fssai_no',
        'fssai_licence_no',
        'fssai_license_no',
      ]),
      gstin: getNumberVal([
        'gstin',
        'gst',
        'gst_number',
        'gst_no',
        'gstNo',
        'gstin_no',
        'gstin_number',
      ]),
      panNo: getNumberVal([
        'pan_no',
        'pan',
        'pan_number',
        'panNo',
        'pan_card_no',
        'pan_card_number',
      ]),
      aadhar: getNumberVal([
        'aadhar',
        'aadhaar',
        'aadhar_no',
        'aadhaar_no',
        'aadhar_number',
        'aadhaar_number',
        'aadhaar_card_no',
        'aadhar_card_no',
      ]),
      businessStatus:
          businessMap?['Restaurant_status']?.toString() ??
          businessMap?['restaurant_status']?.toString() ??
          businessMap?['status']?.toString() ??
          getVal([
            'Restaurant_status',
            'restaurant_status',
            'business_status',
            'verification_status',
            'status',
          ])?.toString(),
      accountHolder:
          bankMap?['account_holder']?.toString() ??
          getVal(['account_holder'])?.toString(),
      bankName:
          bankMap?['bank_name']?.toString() ??
          getVal(['bank_name'])?.toString(),
      accountNumber:
          bankMap?['account_number']?.toString() ??
          getVal(['account_number'])?.toString(),
      ifsc: bankMap?['ifsc']?.toString() ?? getVal(['ifsc'])?.toString(),
      branch: bankMap?['branch']?.toString() ?? getVal(['branch'])?.toString(),
      upiId: bankMap?['upi_id']?.toString() ?? getVal(['upi_id'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (restaurantName != null) 'restaurant_name': restaurantName,
      if (ownerName != null) 'owner_name': ownerName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (street != null) 'street': street,
      if (pincode != null) 'pincode': pincode,
      if (landmark != null) 'landmark': landmark,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (foodType != null) 'food_type': foodType,
      if (image != null) 'image': image,
      if (status != null) 'status': status,
      'is_active': isActive,
      'is_online': isOnline,
      if (licenseNo != null) 'license_no': licenseNo,
      if (gstin != null) 'gstin': gstin,
      if (panNo != null) 'pan_no': panNo,
      if (aadhar != null) 'aadhar': aadhar,
      if (businessStatus != null) 'business_status': businessStatus,
      if (accountHolder != null) 'account_holder': accountHolder,
      if (bankName != null) 'bank_name': bankName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (ifsc != null) 'ifsc': ifsc,
      if (branch != null) 'branch': branch,
      if (upiId != null) 'upi_id': upiId,
    };
  }
}

class ProfileResponseModel {
  final bool success;
  final String message;
  final ProfileModel? profile;
  final int? code;

  ProfileResponseModel({
    required this.success,
    required this.message,
    this.profile,
    this.code,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
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
    } else if (codeVal == 200 || codeVal == 201) {
      isSuccess = true;
    }

    ProfileModel? profile;
    dynamic rawData =
        json['data'] ?? json['profile'] ?? json['restaurant'] ?? json['user'];

    if (rawData is Map) {
      profile = ProfileModel.fromJson(Map<String, dynamic>.from(rawData));
    } else if (json.containsKey('restaurant_name') ||
        json.containsKey('name') ||
        json.containsKey('owner_name') ||
        json.containsKey('data')) {
      profile = ProfileModel.fromJson(json);
    }

    if (profile != null) {
      isSuccess = true;
    }

    return ProfileResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      profile: profile,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (profile != null) 'data': profile!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
