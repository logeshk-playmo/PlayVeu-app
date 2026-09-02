enum UserRole { player, admin }

abstract final class AppSession {
  static const playerPhone = '9999999999';
  static const adminPhone = '8888888888';
  static const prototypeOtp = '1234';

  static UserRole role = UserRole.player;
  static String phone = '';

  static bool get isAdmin => role == UserRole.admin;
  static bool get isPlayer => role == UserRole.player;

  static bool isPrototypePhone(String phone) =>
      phone == playerPhone || phone == adminPhone;

  static UserRole roleForPhone(String phone) =>
      phone == adminPhone ? UserRole.admin : UserRole.player;

  static void signIn(String phoneNumber) {
    phone = phoneNumber;
    role = roleForPhone(phoneNumber);
  }

  static void reset() {
    role = UserRole.player;
    phone = '';
  }
}
