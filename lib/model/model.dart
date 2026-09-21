class UserModel {
  final int? id;
  final String phone;
  final String name;
  final String pin;
  final int isPremium; // 0 = Free, 1 = Premium
  final String? expiryDate;
  final String updatedAt;

  UserModel({
    this.id,
    required this.phone,
    required this.name,
    required this.pin,
    this.isPremium = 0,
    this.expiryDate,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'pin': pin,
      'is_premium': isPremium,
      'expiry_date': expiryDate,
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      phone: map['phone'],
      name: map['name'],
      pin: map['pin'],
      isPremium: map['is_premium'] ?? 0,
      expiryDate: map['expiry_date'],
      updatedAt: map['updated_at'],
    );
  }
}

class BorrowerModel {
  final int? id;
  final String userPhone;
  final String name;
  final String phone;
  final String? address;
  final String createdAt;

  BorrowerModel({
    this.id,
    required this.userPhone,
    required this.name,
    required this.phone,
    this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_phone': userPhone,
      'name': name,
      'phone': phone,
      'address': address,
      'created_at': createdAt,
    };
  }

  factory BorrowerModel.fromMap(Map<String, dynamic> map) {
    return BorrowerModel(
      id: map['id'],
      userPhone: map['user_phone'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      createdAt: map['created_at'],
    );
  }
}

class LoanModel {
  final int? id;
  final String userPhone;
  final int borrowerId;
  final double amount;
  final double interestRate;
  final int termMonths;
  final String startDate;
  final String status; // Active, Completed

  LoanModel({
    this.id,
    required this.userPhone,
    required this.borrowerId,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
    required this.startDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_phone': userPhone,
      'borrower_id': borrowerId,
      'amount': amount,
      'interest_rate': interestRate,
      'term_months': termMonths,
      'start_date': startDate,
      'status': status,
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'],
      userPhone: map['user_phone'],
      borrowerId: map['borrower_id'],
      amount: (map['amount'] as num).toDouble(),
      interestRate: (map['interest_rate'] as num).toDouble(),
      termMonths: map['term_months'],
      startDate: map['start_date'],
      status: map['status'],
    );
  }
}

class RepaymentModel {
  final int? id;
  final String userPhone;
  final int loanId;
  final double paidAmount;
  final String paidDate;
  final String? note;

  RepaymentModel({
    this.id,
    required this.userPhone,
    required this.loanId,
    required this.paidAmount,
    required this.paidDate,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_phone': userPhone,
      'loan_id': loanId,
      'paid_amount': paidAmount,
      'paid_date': paidDate,
      'note': note,
    };
  }

  factory RepaymentModel.fromMap(Map<String, dynamic> map) {
    return RepaymentModel(
      id: map['id'],
      userPhone: map['user_phone'],
      loanId: map['loan_id'],
      paidAmount: (map['paid_amount'] as num).toDouble(),
      paidDate: map['paid_date'],
      note: map['note'],
    );
  }
}
