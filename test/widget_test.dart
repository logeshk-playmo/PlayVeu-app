import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:playveuw_app/main.dart';
import 'package:playveuw_app/screens/home_screen.dart';
import 'package:playveuw_app/screens/login_screen.dart';
import 'package:playveuw_app/screens/otp_verification_screen.dart';
import 'package:playveuw_app/screens/splash_screen.dart';

void main() {
  testWidgets('splash navigates to login after 3 seconds', (tester) async {
    await tester.pumpWidget(const PlayVueApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });

  testWidgets('login validates phone then OTP 1234 opens home', (tester) async {
    await tester.pumpWidget(const PlayVueApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(find.text('Enter your 10-digit mobile number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '12345');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(
      find.text('Enter a valid 10-digit Indian mobile number'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField), '8888888888');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '9999999999');
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    expect(find.textContaining('+91 99999 99999'), findsOneWidget);

    await tester.tap(find.text('Verify'));
    await tester.pump();
    expect(find.text('Enter the 4-digit OTP'), findsOneWidget);

    final otpFields = find.descendant(
      of: find.byType(OtpVerificationScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(otpFields.at(0), '0');
    await tester.enterText(otpFields.at(1), '0');
    await tester.enterText(otpFields.at(2), '0');
    await tester.enterText(otpFields.at(3), '0');
    await tester.tap(find.text('Verify'));
    await tester.pump();
    expect(find.text('Incorrect OTP. Please try again.'), findsOneWidget);

    await tester.enterText(otpFields.at(0), '1');
    await tester.enterText(otpFields.at(1), '2');
    await tester.enterText(otpFields.at(2), '3');
    await tester.enterText(otpFields.at(3), '4');
    await tester.tap(find.text('Verify'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Logesh'), findsOneWidget);
    expect(find.text('+91 9999999999'), findsOneWidget);
    expect(find.text('20 Credits'), findsWidgets);
    expect(find.text('GAMES BY SPORTS'), findsOneWidget);
    expect(find.text('Box Cricket'), findsOneWidget);
    expect(find.text('Pickleball'), findsOneWidget);
    expect(find.text('Swimming'), findsOneWidget);
    expect(find.text('Table Tennis'), findsOneWidget);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Settings'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Logout'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Equipment'), findsWidgets);
    expect(find.text('Venue'), findsWidgets);
    expect(find.text('Play'), findsWidgets);
    expect(find.text('Leaderboard'), findsWidgets);

    await tester.tap(find.text('20 Credits').first);
    await tester.pumpAndSettle();
    expect(find.text('Available balance'), findsOneWidget);
    expect(find.text('Choose a pack'), findsOneWidget);
    expect(find.text('₹100'), findsOneWidget);
    expect(find.text('₹250'), findsOneWidget);
    expect(find.text('₹1,000'), findsOneWidget);
    expect(find.text('Pay ₹250'), findsOneWidget);

    await tester.tap(find.text('Pay ₹250'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(find.text('Payment successful'), findsOneWidget);
    expect(find.text('+30 credits added to your wallet'), findsOneWidget);
    expect(find.text('50'), findsWidgets);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('50 Credits'), findsWidgets);
  });
}
