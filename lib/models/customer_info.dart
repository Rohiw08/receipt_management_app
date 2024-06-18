// ignore_for_file: public_member_api_docs, sort_constructors_first

class CustomerInformation {
  final String uid;
  final String contactNumber;
  final String vehicleNumber;
  final double vehicleRunning;
  final double vehicleNextRunning;
  final String receiptUrl;
  final double totalAmount;
  final String day;
  final String month;
  final String year;

  CustomerInformation({
    required this.uid,
    required this.contactNumber,
    required this.vehicleNumber,
    required this.vehicleRunning,
    required this.vehicleNextRunning,
    required this.receiptUrl,
    required this.totalAmount,
    required this.day,
    required this.month,
    required this.year,
  });

  CustomerInformation copyWith({
    String? uid,
    String? contactNumber,
    String? vehicleNumber,
    double? vehicleRunning,
    double? vehicleNextRunning,
    String? receiptUrl,
    double? totalAmount,
    String? day,
    String? month,
    String? year,
  }) {
    return CustomerInformation(
      uid: uid ?? this.uid,
      contactNumber: contactNumber ?? this.contactNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleRunning: vehicleRunning ?? this.vehicleRunning,
      vehicleNextRunning: vehicleNextRunning ?? this.vehicleNextRunning,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      totalAmount: totalAmount ?? this.totalAmount,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'contactNumber': contactNumber,
      'vehicleNumber': vehicleNumber,
      'vehicleRunning': vehicleRunning,
      'vehicleNextRunning': vehicleNextRunning,
      'receiptUrl': receiptUrl,
      'totalAmount': totalAmount,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory CustomerInformation.fromMap(Map<String, dynamic> map) {
    return CustomerInformation(
      uid: map['uid'] as String,
      contactNumber: map['contactNumber'] as String,
      vehicleNumber: map['vehicleNumber'] as String,
      vehicleRunning: map['vehicleRunning'] as double,
      vehicleNextRunning: map['vehicleNextRunning'] as double,
      receiptUrl: map['receiptUrl'] as String,
      totalAmount: map['totalAmount'] as double,
      day: map['day'] as String,
      month: map['month'] as String,
      year: map['year'] as String,
    );
  }

  @override
  String toString() {
    return 'CustomerInformation(uid: $uid, contactNumber: $contactNumber, vehicleNumber: $vehicleNumber, vehicleRunning: $vehicleRunning, vehicleNextRunning: $vehicleNextRunning, receiptUrl: $receiptUrl, totalAmount: $totalAmount, day: $day, month: $month, year: $year)';
  }

  @override
  bool operator ==(covariant CustomerInformation other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.contactNumber == contactNumber &&
        other.vehicleNumber == vehicleNumber &&
        other.vehicleRunning == vehicleRunning &&
        other.vehicleNextRunning == vehicleNextRunning &&
        other.receiptUrl == receiptUrl &&
        other.totalAmount == totalAmount &&
        other.day == day &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        contactNumber.hashCode ^
        vehicleNumber.hashCode ^
        vehicleRunning.hashCode ^
        vehicleNextRunning.hashCode ^
        receiptUrl.hashCode ^
        totalAmount.hashCode ^
        day.hashCode ^
        month.hashCode ^
        year.hashCode;
  }
}
