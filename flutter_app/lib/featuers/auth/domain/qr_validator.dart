// lib/features/auth/domain/qr_validator.dart

class QRValidator {
  // 기본 형식: PLANT-숫자
  static final RegExp _defaultPattern = RegExp(r"^PLANT-\d+$");

  /// QR 값이 유효한 형식인지 검사
  static bool isValid(String qrValue) {
    return _defaultPattern.hasMatch(qrValue);
  }
}
