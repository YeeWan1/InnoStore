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

  static Voucher fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'BasicVoucher':
        return BasicVoucher.fromMap(map);
      case 'FemaleVoucher':
        return FemaleVoucher.fromMap(map);
      case 'SeniorCitizenVoucher':
        return SeniorCitizenVoucher.fromMap(map);
      case 'StudentVoucher':
        return StudentVoucher.fromMap(map);
      case 'NewUserVoucher':
        return NewUserVoucher.fromMap(map);
      default:
        throw Exception('Unknown voucher type');
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
          expiryDate: 'Expires on 1 Dec 2024',
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['type'] = 'BasicVoucher';
    return map;
  }

  factory BasicVoucher.fromMap(Map<String, dynamic> map) {
    return BasicVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: 'Expires on 1 Dec 2024',
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
          expiryDate: 'Expires on 1 Dec 2024',
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['type'] = 'FemaleVoucher';
    return map;
  }

  factory FemaleVoucher.fromMap(Map<String, dynamic> map) {
    return FemaleVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: 'Expires on 1 Dec 2024',
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
          expiryDate: 'Expires on 1 Dec 2024',
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['type'] = 'SeniorCitizenVoucher';
    return map;
  }

  factory SeniorCitizenVoucher.fromMap(Map<String, dynamic> map) {
    return SeniorCitizenVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: 'Expires on 1 Dec 2024',
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
          expiryDate: 'Expires on 1 Dec 2024',
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['type'] = 'StudentVoucher';
    return map;
  }

  factory StudentVoucher.fromMap(Map<String, dynamic> map) {
    return StudentVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: 'Expires on 1 Dec 2024',
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}

class NewUserVoucher extends Voucher {
  NewUserVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: 'Expires on 1 Dec 2024',
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['type'] = 'NewUserVoucher';
    return map;
  }

  factory NewUserVoucher.fromMap(Map<String, dynamic> map) {
    return NewUserVoucher(
      category: map['category'],
      discount: map['discount'],
      expiryDate: 'Expires on 1 Dec 2024',
      isExpiringSoon: map['isExpiringSoon'],
      description: map['description'],
      terms: map['terms'],
    );
  }
}
