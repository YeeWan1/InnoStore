abstract class Voucher {
  final String category;
  final String discount;
  final String expiryDate;
  final bool isExpiringSoon;
  final String description;
  final String terms;

  Voucher({
    required this.category,
    required this.discount,
    required this.expiryDate,
    required this.isExpiringSoon,
    required this.description,
    required this.terms,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'discount': discount,
      'expiryDate': expiryDate,
      'isExpiringSoon': isExpiringSoon,
      'description': description,
      'terms': terms,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    switch (map['category']) {
      case 'Make Up Discount':
        return FemaleVoucher.fromMap(map);
      case 'Student Special Offer':
        return StudentVoucher.fromMap(map);
      case 'Brand Coupon':
        return SeniorCitizenVoucher.fromMap(map);
      default:
        return BasicVoucher.fromMap(map);
    }
  }
}

class BasicVoucher extends Voucher {
  BasicVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  factory BasicVoucher.fromMap(Map<String, dynamic> map) {
    return BasicVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: map['expiryDate'],
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}

class FemaleVoucher extends Voucher {
  FemaleVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  factory FemaleVoucher.fromMap(Map<String, dynamic> map) {
    return FemaleVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: map['expiryDate'],
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}

class SeniorCitizenVoucher extends Voucher {
  SeniorCitizenVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  factory SeniorCitizenVoucher.fromMap(Map<String, dynamic> map) {
    return SeniorCitizenVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: map['expiryDate'],
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}

class StudentVoucher extends Voucher {
  StudentVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  factory StudentVoucher.fromMap(Map<String, dynamic> map) {
    return StudentVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: map['expiryDate'],
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}
