import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:playveuw_app/main.dart';
import 'package:playveuw_app/screens/booking_confirmation_screen.dart';
import 'package:playveuw_app/screens/booking_details_screen.dart';
import 'package:playveuw_app/screens/booking_history_screen.dart';
import 'package:playveuw_app/screens/create_match_screen.dart';
import 'package:playveuw_app/screens/create_tournament_screen.dart';
import 'package:playveuw_app/screens/credit_success_screen.dart';
import 'package:playveuw_app/screens/equipment_detail_screen.dart';
import 'package:playveuw_app/screens/equipment_history_screen.dart';
import 'package:playveuw_app/screens/equipment_screen.dart';
import 'package:playveuw_app/screens/home_screen.dart';
import 'package:playveuw_app/screens/login_screen.dart';
import 'package:playveuw_app/screens/match_registration_screen.dart';
import 'package:playveuw_app/screens/my_game_history_screen.dart';
import 'package:playveuw_app/screens/otp_verification_screen.dart';
import 'package:playveuw_app/screens/play_screen.dart';
import 'package:playveuw_app/screens/profile_screen.dart';
import 'package:playveuw_app/screens/select_slot_screen.dart';
import 'package:playveuw_app/screens/select_sport_screen.dart';
import 'package:playveuw_app/screens/splash_screen.dart';
import 'package:playveuw_app/screens/venue_details_screen.dart';
import 'package:playveuw_app/screens/venues_screen.dart';
import 'package:playveuw_app/theme/app_theme.dart';

void main() {
  setUp(() {
    AppCreditsState.current = 20;
    AppCreditsState.hasShownLowCreditDialog = false;
    AppPlayState.reset();
  });

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
    expect(find.text('50 Credits'), findsWidgets);
  });

  testWidgets('equipment item tap navigates to EquipmentDetailScreen with item data', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: EquipmentScreen()),
      ),
    );

    // Verify equipment list items are visible
    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Football Size 5'), findsOneWidget);
    expect(find.text('Cricket Kit'), findsOneWidget);

    // Tap Yonex Astrox Racket
    await tester.tap(find.text('Yonex Astrox Racket'));
    await tester.pumpAndSettle();

    // Verify EquipmentDetailScreen is opened with Yonex details
    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Rackets & Bats'), findsOneWidget);
    expect(find.text('₹50 / hour'), findsOneWidget);
    expect(find.text('In Stock (8 Available)'), findsOneWidget);
    expect(find.text('₹200 (Refundable)'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Features & Inclusions'), findsOneWidget);
    expect(find.text('High-modulus graphite shaft'), findsOneWidget);
    expect(find.text('Pay Online'), findsOneWidget);
    expect(find.text('Use Credits'), findsNothing); // Credits removed

    // Tap Pay Online button
    await tester.tap(find.text('Pay Online'));
    await tester.pump();

    // Verify confirmation snackbar appears
    expect(find.text('Online payment is coming soon.'), findsOneWidget);

    // Pop back using the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Tap Football Size 5
    await tester.tap(find.text('Football Size 5'));
    await tester.pumpAndSettle();

    // Verify Football details are displayed dynamically
    expect(find.text('Football Size 5'), findsOneWidget);
    expect(find.text('Balls & Inflatables'), findsOneWidget);
    expect(find.text('₹30 / hour'), findsOneWidget);
    expect(find.text('In Stock (12 Available)'), findsOneWidget);
    expect(find.text('Official match size 5 specification'), findsOneWidget);
  });

  testWidgets('Buy Credit button in HomeScreen AppBar navigates to CreditsScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify Buy Credit button is present in AppBar
    expect(find.text('Buy Credit'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // Tap Buy Credit button
    await tester.tap(find.text('Buy Credit'));
    await tester.pumpAndSettle();

    // Verify CreditsScreen is opened
    expect(find.text('Available balance'), findsOneWidget);
    expect(find.text('Choose a pack'), findsOneWidget);
    expect(find.text('₹100'), findsOneWidget);
  });

  testWidgets('HomeScreen displays My Equipments, My Venues, and Live Matches row below Profile Card and switches tabs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify the 3 quick action containers are visible with plural labels
    expect(find.text('My Equipments'), findsOneWidget);
    expect(find.text('My Venues'), findsOneWidget);
    expect(find.text('Live Matches'), findsOneWidget);

    // Tap My Equipments container -> navigates to EquipmentHistoryScreen
    await tester.tap(find.text('My Equipments'));
    await tester.pumpAndSettle();

    // Verify EquipmentHistoryScreen is active
    expect(find.byType(EquipmentHistoryScreen), findsOneWidget);
    expect(find.text('Yonex Astrox Racket'), findsOneWidget);

    // Pop back to Home
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Tap My Venues container -> navigates to BookingHistoryScreen
    await tester.tap(find.text('My Venues'));
    await tester.pumpAndSettle();

    // Verify BookingHistoryScreen is active
    expect(find.byType(BookingHistoryScreen), findsOneWidget);
    expect(find.text('Smash Arena'), findsOneWidget);

    // Pop back to Home
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    // Tap Live Matches container
    await tester.tap(find.text('Live Matches'));
    await tester.pumpAndSettle();

    // Verify PlayScreen is active
    expect(find.text('Badminton Doubles'), findsOneWidget);

    // Test Drawer navigation for My Equipments, My Venues, Live Matches
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'My Equipments'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'My Venues'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Live Matches'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'My Venues'));
    await tester.pumpAndSettle();
    expect(find.byType(BookingHistoryScreen), findsOneWidget);
    expect(find.text('Smash Arena'), findsOneWidget);
  });

  testWidgets('bottom action buttons in detail screens render properly with safe area', (tester) async {
    final venue = VenuesScreen.venues.first;

    // Test VenueDetailsScreen
    await tester.pumpWidget(
      MaterialApp(
        home: VenueDetailsScreen(venue: venue),
      ),
    );
    expect(find.text('BOOK NOW'), findsOneWidget);

    // Test SelectSlotScreen
    await tester.pumpWidget(
      MaterialApp(
        home: SelectSlotScreen(venue: venue),
      ),
    );
    expect(find.text('CONFIRM BOOKING'), findsOneWidget);

    // Test BookingDetailsScreen (Credits only, no Pay Online)
    await tester.pumpWidget(
      MaterialApp(
        home: BookingDetailsScreen(
          bookingData: {
            'venue': venue,
            'game': 'Badminton',
            'date': '02 September 2026',
            'startTime': '09:00 AM',
            'endTime': '10:00 AM',
            'duration': '1 Hour',
            'amount': 500,
            'credits': 50,
          },
        ),
      ),
    );
    expect(find.text('Use Credits'), findsOneWidget);
    expect(find.text('Pay Online'), findsNothing);

    // Test CreditSuccessScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: CreditSuccessScreen(creditsAdded: 30, newBalance: 50),
      ),
    );
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('Venue Booking Flow with Credits Only and Insufficient Credits Dialog', (tester) async {
    final venue = VenuesScreen.venues.first;
    AppCreditsState.current = 100;

    // 1. Test SelectSlotScreen price & credits update
    await tester.pumpWidget(
      MaterialApp(
        home: SelectSlotScreen(venue: venue),
      ),
    );

    // Select Game
    await tester.tap(find.text('Badminton'));
    await tester.pumpAndSettle();

    // Select Duration: 1 Hour (₹500 / 50 Credits)
    await tester.ensureVisible(find.text('1 Hour'));
    await tester.tap(find.text('1 Hour'));
    await tester.pumpAndSettle();

    // Select Time Slot
    await tester.ensureVisible(find.text('09:00 AM'));
    await tester.tap(find.text('09:00 AM'));
    await tester.pumpAndSettle();

    // Verify summary shows price and credits
    await tester.ensureVisible(find.text('₹500 / 50 Credits'));
    expect(find.text('₹500 / 50 Credits'), findsOneWidget);

    // 2. Test BookingDetailsScreen
    await tester.pumpWidget(
      MaterialApp(
        home: BookingDetailsScreen(
          bookingData: {
            'venue': venue,
            'game': 'Badminton',
            'date': '05 September 2026',
            'startTime': '09:00 AM',
            'endTime': '10:00 AM',
            'duration': '1 Hour',
            'amount': 500,
            'credits': 50,
          },
        ),
      ),
    );

    // Verify Payment Summary
    expect(find.text('Booking Amount'), findsOneWidget);
    expect(find.text('Credits Required'), findsOneWidget);
    expect(find.text('50 Credits'), findsWidgets);
    expect(find.text('Payable'), findsOneWidget);
    expect(find.text('₹500 / 50 Credits'), findsOneWidget);

    // Verify only Use Credits button exists (no Pay Online)
    expect(find.text('Use Credits'), findsOneWidget);
    expect(find.text('Pay Online'), findsNothing);

    // Test Insufficient Credits Dialog
    AppCreditsState.current = 20;
    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();

    // Verify Insufficient Credits Dialog content
    expect(find.text('Not Enough Credits'), findsOneWidget);
    expect(find.text('You don\'t have enough credits to complete this booking.'), findsOneWidget);
    expect(find.text('Required:'), findsOneWidget);
    expect(find.text('50 Credits'), findsWidgets);
    expect(find.text('Available:'), findsOneWidget);
    expect(find.text('20 Credits'), findsWidgets);
    expect(find.text('Okay'), findsOneWidget);

    // Tap Okay -> closes dialog and stays on BookingDetailsScreen
    await tester.tap(find.text('Okay'));
    await tester.pumpAndSettle();
    expect(find.text('Not Enough Credits'), findsNothing);
    expect(AppCreditsState.current, 20); // No deduction

    // Test Buy Credit button inside Insufficient Credits Dialog
    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();
    expect(find.text('Not Enough Credits'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Buy Credit'));
    await tester.pumpAndSettle();
    expect(find.text('Not Enough Credits'), findsNothing);
    expect(find.text('Available balance'), findsOneWidget); // CreditsScreen opened

    // 3. Test Sufficient Credits & Confirmation Dialog
    AppCreditsState.current = 100;
    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        home: BookingDetailsScreen(
          bookingData: {
            'venue': venue,
            'game': 'Badminton',
            'date': '05 September 2026',
            'startTime': '09:00 AM',
            'endTime': '10:00 AM',
            'duration': '1 Hour',
            'amount': 500,
            'credits': 50,
          },
        ),
      ),
    );

    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();

    // Verify Dialog content
    expect(find.text('Confirm Booking'), findsOneWidget);
    expect(find.text(venue['name']), findsWidgets);
    expect(find.text('100'), findsOneWidget); // Current Credits
    expect(find.text('50'), findsWidgets); // Credits Required and Remaining Credits

    // Test Dialog Close X button
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Booking'), findsNothing);
    expect(AppCreditsState.current, 100); // No deduction on cancel

    // Tap Use Credits again and Confirm
    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Verify BookingConfirmationScreen
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    expect(find.text('Your slot has been reserved successfully.'), findsOneWidget);
    expect(find.text('50 Credits'), findsWidgets);
    expect(AppCreditsState.current, 50); // Deducted from 100 to 50

    // Test DONE button
    expect(find.text('DONE'), findsOneWidget);
  });

  testWidgets('Equipment Rental Flow is Online Payment Only and does not affect credits', (tester) async {
    final item = EquipmentScreen.items.first; // Yonex Astrox Racket: ₹50 / hour
    AppCreditsState.current = 50;

    await tester.pumpWidget(
      MaterialApp(
        home: EquipmentDetailScreen(item: item),
      ),
    );

    // Verify rate display is in rupees only
    expect(find.text('₹50 / hour'), findsOneWidget);
    expect(find.text('Pay Online'), findsOneWidget);
    expect(find.text('Use Credits'), findsNothing);

    // Test Pay Online
    await tester.tap(find.text('Pay Online'));
    await tester.pump();
    expect(find.text('Online payment is coming soon.'), findsOneWidget);

    // Credits balance remains untouched
    expect(AppCreditsState.current, 50);
  });

  testWidgets('Low Credit Warning Dialog triggers when credits < 10 once per session', (tester) async {
    // 1. When credits >= 10, dialog does not show
    AppCreditsState.current = 20;
    AppCreditsState.hasShownLowCreditDialog = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(key: UniqueKey()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Only few credits left!'), findsNothing);

    // 2. When credits < 10 on new session (e.g. 7 credits), dialog is shown
    AppCreditsState.current = 7;
    AppCreditsState.hasShownLowCreditDialog = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(key: UniqueKey()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.text('Only few credits left!'), findsOneWidget);
    expect(find.text('Buy Credit to recharge your balance and continue booking.'), findsOneWidget);
    expect(find.text('Available Credits: '), findsOneWidget);
    expect(find.text('7'), findsWidgets);
    expect(find.text('Buy Credit'), findsWidgets);
    expect(AppCreditsState.hasShownLowCreditDialog, true);

    // 3. Test Close X button
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Only few credits left!'), findsNothing);

    // 4. In the same session, launching another screen/tab does not show dialog again
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(key: UniqueKey()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Only few credits left!'), findsNothing);

    // 5. When reset (simulating app relaunch) and tapping Buy Credit
    AppCreditsState.current = 5;
    AppCreditsState.hasShownLowCreditDialog = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(key: UniqueKey()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Only few credits left!'), findsOneWidget);
    expect(find.text('5'), findsWidgets);

    // Tap Buy Credit in dialog
    await tester.tap(find.widgetWithText(FilledButton, 'Buy Credit'));
    await tester.pumpAndSettle();

    // Verify CreditsScreen is opened
    expect(find.text('Only few credits left!'), findsNothing);
    expect(find.text('Available balance'), findsOneWidget);
    expect(find.text('Choose a pack'), findsOneWidget);
  });

  testWidgets('Low Credit Warning Dialog triggers after court booking when balance becomes < 10', (tester) async {
    final venue = VenuesScreen.venues.first;
    AppCreditsState.current = 55; // 55 - 50 = 5 credits remaining
    AppCreditsState.hasShownLowCreditDialog = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BookingDetailsScreen(
          bookingData: {
            'venue': venue,
            'game': 'Badminton',
            'date': '05 September 2026',
            'startTime': '09:00 AM',
            'endTime': '10:00 AM',
            'duration': '1 Hour',
            'amount': 500,
            'credits': 50,
          },
        ),
      ),
    );

    // Tap Use Credits and Confirm booking
    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Verify BookingConfirmationScreen is shown AND Low Credit Dialog is triggered
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    expect(find.text('Only few credits left!'), findsOneWidget);
    expect(find.text('5'), findsWidgets); // Remaining balance
    expect(AppCreditsState.current, 5);

    // Dismiss dialog using X
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Only few credits left!'), findsNothing);

    // Tap DONE to go back
    expect(find.text('DONE'), findsOneWidget);
  });

  testWidgets('SelectSlotScreen - Flexible Duration adjustment (Hours/Minutes stepper, dynamic pricing, and slot generation)', (tester) async {
    final venue = VenuesScreen.venues.first; // PlayVue Sports Academy: 6:00 AM - 10:00 PM, 30m: 300, 1h: 500, 2h: 900

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSlotScreen(venue: venue),
      ),
    );

    // Initial state: 1 Hour default
    expect(find.text('Custom Duration'), findsOneWidget);
    expect(find.text('Full Day'), findsOneWidget);
    expect(find.text('1 Hour'), findsWidgets);
    expect(find.text('1'), findsOneWidget); // Hours value
    expect(find.text('00'), findsOneWidget); // Minutes value

    // 1. Increment Hours: 1 Hour -> 2 Hours
    await tester.ensureVisible(find.byIcon(Icons.add_rounded));
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2 Hours'), findsWidgets);
    expect(find.text('2'), findsOneWidget);

    // 2. Select a valid start time for 2 Hours (e.g. 06:00 AM)
    await tester.ensureVisible(find.text('06:00 AM'));
    expect(find.text('06:00 AM'), findsOneWidget);
    expect(find.text('08:00 AM'), findsOneWidget);
    await tester.tap(find.text('06:00 AM'));
    await tester.pumpAndSettle();

    // Summary for 2 Hours: ₹900 / 90 Credits, 06:00 AM - 08:00 AM
    await tester.ensureVisible(find.text('₹900 / 90 Credits'));
    expect(find.text('₹900 / 90 Credits'), findsOneWidget);
    expect(find.text('06:00 AM - 08:00 AM'), findsOneWidget);

    // 3. Decrement Hours: 2 Hours -> 1 Hour
    await tester.ensureVisible(find.byIcon(Icons.remove_rounded));
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(find.text('1 Hour'), findsWidgets);

    // 4. Decrement again: 1 Hour -> 30 Minutes (0 Hours 30 Minutes)
    await tester.ensureVisible(find.byIcon(Icons.remove_rounded));
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(find.text('30 Minutes'), findsWidgets);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);

    // Start time 06:00 AM summary for 30 mins: ₹300 / 30 Credits, 06:00 AM - 06:30 AM
    await tester.ensureVisible(find.text('06:00 AM'));
    await tester.tap(find.text('06:00 AM'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('₹300 / 30 Credits'));
    expect(find.text('₹300 / 30 Credits'), findsOneWidget);
    expect(find.text('06:00 AM - 06:30 AM'), findsOneWidget);
  });

  testWidgets('SelectSlotScreen - Full Day toggle sets operating hours and disables custom time selection', (tester) async {
    final venue = VenuesScreen.venues.first;

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSlotScreen(venue: venue),
      ),
    );

    // Switch to Full Day
    await tester.ensureVisible(find.text('Full Day').first);
    await tester.tap(find.text('Full Day').first);
    await tester.pumpAndSettle();

    // Verify Full Day UI
    expect(find.text('Full Day Booking'), findsOneWidget);
    expect(find.text('06:00 AM → 10:00 PM'), findsOneWidget);
    expect(find.text('Entire venue operating hours'), findsOneWidget);
    expect(find.text('Available Time'), findsNothing); // Custom time selector hidden

    // Verify Summary
    expect(find.text('Full Day'), findsWidgets);
    expect(find.text('06:00 AM - 10:00 PM'), findsOneWidget);

    // Switch back to Custom Duration
    await tester.ensureVisible(find.text('Custom Duration'));
    await tester.tap(find.text('Custom Duration'));
    await tester.pumpAndSettle();

    expect(find.text('Adjust Hours & Minutes'), findsOneWidget);
    expect(find.text('Available Time'), findsOneWidget);
  });

  testWidgets('SelectSlotScreen court selection validation, selection UI, and carrying court to BookingDetails and BookingConfirmation', (tester) async {
    final venue = VenuesScreen.venues.first;
    AppCreditsState.current = 100;

    await tester.pumpWidget(
      MaterialApp(
        home: SelectSlotScreen(venue: venue),
      ),
    );

    // Verify Available Courts section
    expect(find.text('Available Courts'), findsOneWidget);
    expect(find.text('Court 1'), findsOneWidget);
    expect(find.text('Court 2'), findsOneWidget);

    // Select Time Slot without selecting court
    await tester.ensureVisible(find.text('06:00 AM'));
    await tester.tap(find.text('06:00 AM'));
    await tester.pumpAndSettle();

    // Tap CONFIRM BOOKING without court selected -> shows validation message
    await tester.ensureVisible(find.text('CONFIRM BOOKING'));
    await tester.tap(find.text('CONFIRM BOOKING'));
    await tester.pumpAndSettle();

    expect(find.text('Please select a court to continue.'), findsOneWidget);
    expect(find.byType(BookingDetailsScreen), findsNothing);

    // Select Court 2
    await tester.ensureVisible(find.text('Court 2'));
    await tester.tap(find.text('Court 2'));
    await tester.pumpAndSettle();

    // Now tap CONFIRM BOOKING -> navigates to BookingDetailsScreen
    await tester.ensureVisible(find.text('CONFIRM BOOKING'));
    await tester.tap(find.text('CONFIRM BOOKING'));
    await tester.pumpAndSettle();

    // Verify BookingDetailsScreen displays Court
    expect(find.byType(BookingDetailsScreen), findsOneWidget);
    expect(find.text('Court'), findsOneWidget);
    expect(find.text('Court 2'), findsOneWidget);

    // Tap Use Credits -> opens confirmation dialog showing Court 2
    await tester.tap(find.text('Use Credits'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Booking'), findsOneWidget);
    expect(find.text('Court'), findsWidgets);
    expect(find.text('Court 2'), findsWidgets);

    // Confirm booking -> opens BookingConfirmationScreen showing Court 2
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.byType(BookingConfirmationScreen), findsOneWidget);
    expect(find.text('Booking Confirmed!'), findsOneWidget);
    expect(find.text('Court: '), findsOneWidget);
    expect(find.text('Court 2'), findsWidgets);
  });

  testWidgets('EquipmentHistoryScreen displays rental history cards and processes return confirmation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EquipmentHistoryScreen(),
      ),
    );

    // Verify screen title
    expect(find.text('My Equipments'), findsOneWidget);

    // Verify visible items
    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Football Size 5'), findsOneWidget);

    // Verify initial active rental status & Return button
    expect(find.text('Status: Rented'), findsWidgets);
    expect(find.widgetWithText(FilledButton, 'Return'), findsWidgets);

    // Tap Return button on first active rental (Yonex Astrox Racket)
    await tester.tap(find.widgetWithText(FilledButton, 'Return').first);
    await tester.pumpAndSettle();

    // Verify confirmation dialog appears
    expect(find.text('Return Equipment?'), findsOneWidget);
    expect(find.text('Are you sure you want to return this equipment?'), findsOneWidget);

    // Test Cancel button dismisses dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Return Equipment?'), findsNothing);

    // Tap Return button again and Confirm
    await tester.tap(find.widgetWithText(FilledButton, 'Return').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Return').last); // Tap Return in dialog
    await tester.pumpAndSettle();

    // Verify dialog is closed and status changed to Returned
    expect(find.text('Status: Returned'), findsWidgets);
    expect(find.text('Yonex Astrox Racket has been returned successfully.'), findsOneWidget);

    // Scroll to see returned history items
    await tester.scrollUntilVisible(find.text('Cricket Kit'), 200);
    expect(find.text('Cricket Kit'), findsOneWidget);
  });

  testWidgets('ProfileScreen Bookings action opens BookingHistoryScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('View history'), findsWidgets);

    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();

    expect(find.byType(BookingHistoryScreen), findsOneWidget);
    expect(find.text('Booking History'), findsOneWidget);
    expect(find.text('Smash Arena'), findsOneWidget);
  });

  testWidgets('BookingHistoryScreen displays venue bookings with full-day and handles empty state', (tester) async {
    // 1. Test standard bookings list
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingHistoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify screen title
    expect(find.text('Booking History'), findsOneWidget);

    // Verify first booking (Smash Arena - Confirmed, 1 Hour)
    expect(find.text('Smash Arena'), findsOneWidget);
    expect(find.text('Badminton'), findsOneWidget);
    expect(find.text('Court 2'), findsOneWidget);
    expect(find.text('06:00 PM - 07:00 PM'), findsOneWidget);
    expect(find.text('1 Hour'), findsOneWidget);
    expect(find.text('50 Credits'), findsOneWidget);
    expect(find.text('Status: Confirmed'), findsWidgets);

    // Scroll to verify Full Day booking (PlayVue Sports Academy)
    await tester.scrollUntilVisible(find.text('PlayVue Sports Academy'), 200);
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);
    expect(find.text('Football'), findsOneWidget);
    expect(find.text('Main Turf Pitch'), findsOneWidget);
    expect(find.text('06:00 AM - 10:00 PM'), findsOneWidget);
    expect(find.text('Full Day'), findsOneWidget);
    expect(find.text('560 Credits'), findsOneWidget);

    // 2. Test Empty State
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingHistoryScreen(initialBookings: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Bookings Yet'), findsOneWidget);
    expect(find.text('You haven\'t made any venue bookings yet.'), findsOneWidget);
    expect(find.text('Explore Venues'), findsOneWidget);
  });

  testWidgets('Games By SPORTS sport tap opens VenuesScreen with filter applied', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify Games By SPORTS section is present
    expect(find.text('GAMES BY SPORTS'), findsOneWidget);
    expect(find.text('Box Cricket'), findsOneWidget);

    // Tap Box Cricket
    await tester.tap(find.text('Box Cricket'));
    await tester.pumpAndSettle();

    // Verify VenuesScreen is opened with Box Cricket filter
    expect(find.byType(VenuesScreen), findsOneWidget);
    expect(find.text('Showing venues for'), findsOneWidget);
    expect(find.text('Box Cricket'), findsWidgets);

    // Verify cricket venues are shown
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);
    expect(find.text('Champions Sports Club'), findsOneWidget);
    // Non-cricket venues should NOT be shown
    expect(find.text('Smash Arena'), findsNothing);

    // Tap Clear button
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    // Now all venues should be shown
    expect(find.text('Showing venues for'), findsNothing);
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);
    expect(find.text('Elite Sports Arena'), findsOneWidget);
  });

  testWidgets('VenuesScreen empty state for sports with no venues and View All Venues action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VenuesScreen(selectedSport: 'Pickleball'),
      ),
    );
    await tester.pumpAndSettle();

    // Verify empty state
    expect(find.text('No Pickleball Venues'), findsOneWidget);
    expect(find.text('There are currently no venues available\nfor Pickleball.'), findsOneWidget);
    expect(find.text('View All Venues'), findsOneWidget);

    // Tap View All Venues
    await tester.tap(find.text('View All Venues'));
    await tester.pumpAndSettle();

    // All venues shown
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);
    expect(find.text('Elite Sports Arena'), findsOneWidget);
  });

  testWidgets('PlayScreen - Host a Game -> Select Sport -> Create Match (Public and Private)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PlayScreen()),
      ),
    );

    // Verify Host a Game button
    expect(find.text('Host a Game +'), findsOneWidget);

    // 1. Create a Public Match
    await tester.tap(find.text('Host a Game +'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectSportScreen), findsOneWidget);
    expect(find.text('Select Sport'), findsOneWidget);

    // Tap Badminton
    await tester.tap(find.text('Badminton'));
    await tester.pumpAndSettle();

    expect(find.text('Create Match'), findsOneWidget);
    await tester.tap(find.text('Create Match'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateMatchScreen), findsOneWidget);
    expect(find.text('Visibility'), findsOneWidget);
    expect(find.text('Public'), findsWidgets);
    expect(find.text('Private'), findsOneWidget);

    // Tap CREATE MATCH (Public)
    await tester.ensureVisible(find.text('CREATE MATCH'));
    await tester.tap(find.text('CREATE MATCH'));
    await tester.pumpAndSettle();

    // Verify Match Created dialog with Visibility
    expect(find.text('Match Created! 🎉'), findsOneWidget);
    expect(find.text('Your Badminton match has been published to open matches.'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Returned to PlayScreen - Verify new public match is listed in Open Matches
    expect(find.byType(PlayScreen), findsOneWidget);
    expect(find.text('Weekend Badminton Match'), findsWidgets);

    // 2. Create a Private Match
    await tester.tap(find.text('Host a Game +'));
    await tester.pumpAndSettle();

    // Select Cricket which is readily visible at top of grid
    await tester.tap(find.text('Cricket'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Match'));
    await tester.pumpAndSettle();

    // Select Private visibility
    await tester.ensureVisible(find.text('Private'));
    await tester.tap(find.text('Private'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('CREATE MATCH'));
    await tester.tap(find.text('CREATE MATCH'));
    await tester.pumpAndSettle();

    expect(find.text('Your private Cricket match has been created and saved in My Games.'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Private match should NOT be in Open Matches
    expect(find.text('Weekend Cricket Match'), findsNothing);
  });

  testWidgets('PlayScreen - Host a Game -> Select Sport -> Create Tournament workflow', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PlayScreen()),
      ),
    );

    // Tap Host a Game +
    await tester.tap(find.text('Host a Game +'));
    await tester.pumpAndSettle();

    // Tap Cricket card
    await tester.tap(find.text('Cricket'));
    await tester.pumpAndSettle();

    // Choose Create Tournament
    await tester.tap(find.text('Create Tournament'));
    await tester.pumpAndSettle();

    // Verify CreateTournamentScreen with preset sport and visibility
    expect(find.byType(CreateTournamentScreen), findsOneWidget);
    expect(find.text('Create Tournament'), findsOneWidget);
    expect(find.text('Cricket'), findsWidgets);
    expect(find.text('Visibility'), findsOneWidget);

    // Tap CREATE TOURNAMENT button
    await tester.ensureVisible(find.text('CREATE TOURNAMENT'));
    await tester.tap(find.text('CREATE TOURNAMENT'));
    await tester.pumpAndSettle();

    // Verify Tournament Created dialog
    expect(find.text('Tournament Created! 🏆'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Tap Done
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Returned to PlayScreen
    expect(find.byType(PlayScreen), findsOneWidget);
  });

  testWidgets('PlayScreen - Open Matches Join Request -> Requested state -> Organizer Acceptance -> Joined state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PlayScreen()),
      ),
    );

    // Verify Open Matches list
    expect(find.text('Open Matches'), findsOneWidget);
    expect(find.text('Badminton Doubles'), findsOneWidget);

    // 1. Tap Join on first match
    await tester.tap(find.text('Join').first);
    await tester.pumpAndSettle();

    // Verify MatchRegistrationScreen
    expect(find.byType(MatchRegistrationScreen), findsOneWidget);
    expect(find.text('Join Match'), findsOneWidget);
    expect(find.text('Your Details'), findsOneWidget);
    expect(find.text('Logesh K'), findsOneWidget);
    expect(find.text('+91 9999999999'), findsOneWidget);
    expect(find.text('SUBMIT REQUEST'), findsOneWidget);

    // Tap SUBMIT REQUEST button
    await tester.ensureVisible(find.text('SUBMIT REQUEST'));
    await tester.tap(find.text('SUBMIT REQUEST'));
    await tester.pumpAndSettle();

    // Verify Request Sent confirmation dialog (NOT immediately joined)
    expect(find.text('Request Sent ✓'), findsOneWidget);
    expect(find.text('Your request to join this match\nhas been sent to the match organizer.\n\nYou will be able to join once\nthe organizer accepts your request.'), findsOneWidget);

    // Tap Done
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Back on PlayScreen - button now displays Requested
    expect(find.byType(PlayScreen), findsOneWidget);
    expect(find.text('Requested'), findsWidgets);

    // 2. Tap Requested button -> simulate acceptance
    await tester.tap(find.widgetWithText(FilledButton, 'Requested').first);
    await tester.pumpAndSettle();

    expect(find.text('Join Request Pending'), findsOneWidget);
    expect(find.text('Simulate Organizer Acceptance (Demo)'), findsOneWidget);

    await tester.tap(find.text('Simulate Organizer Acceptance (Demo)'));
    await tester.pumpAndSettle();

    // Now button should show Joined
    expect(find.text('Joined'), findsWidgets);

    // 3. Test Full match - scroll down to m5
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Full (0 spots left)'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, 'Full').first);
    await tester.pumpAndSettle();

    expect(find.text('Match Full'), findsOneWidget);
    expect(find.text('This match has reached the maximum number of players.'), findsOneWidget);

    await tester.tap(find.text('Okay'));
    await tester.pumpAndSettle();
    expect(find.text('Match Full'), findsNothing);
  });

  testWidgets('MyGameHistoryScreen - Host Controls (Start Match) and Visibility Badges', (tester) async {
    // 1. Test Drawer Navigation to My Games
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Open Drawer
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();

    expect(find.text('My Games'), findsOneWidget);

    // Tap My Games
    await tester.tap(find.text('My Games'));
    await tester.pumpAndSettle();

    // Verify MyGameHistoryScreen
    expect(find.byType(MyGameHistoryScreen), findsOneWidget);
    expect(find.text('Sunday Badminton Match'), findsOneWidget);
    expect(find.text('Weekend Football 5v5'), findsOneWidget);
    expect(find.text('Public'), findsWidgets);
    expect(find.text('Host'), findsWidgets);

    // Test Host three-dot menu on creator match (Weekend Football 5v5)
    expect(find.byIcon(Icons.more_vert_rounded), findsWidgets);
    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Start Match'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);

    // Tap Start Match
    await tester.tap(find.text('Start Match'));
    await tester.pumpAndSettle();

    // Verify Start Match? confirmation dialog
    expect(find.text('Start Match?'), findsOneWidget);
    expect(find.text('Are you sure you want to start this match?\n\nOnce started, the match status will change to Ongoing.'), findsOneWidget);

    // Confirm Start Match
    await tester.tap(find.widgetWithText(FilledButton, 'Start Match'));
    await tester.pumpAndSettle();

    // Verify status changed to Ongoing
    expect(find.text('Ongoing'), findsWidgets);

    // 2. Test Empty State
    await tester.pumpWidget(
      const MaterialApp(
        key: Key('empty_games_app'),
        home: MyGameHistoryScreen(initialGames: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Games Yet'), findsOneWidget);
    expect(find.text('You haven\'t joined or played any\ngames yet.'), findsOneWidget);
    expect(find.text('Explore Open Matches'), findsOneWidget);
  });

  testWidgets('MyGameHistoryScreen - Responsive layout on narrow screen and no Accept Request button', (tester) async {
    // Set small screen size (320x568 - iPhone SE / compact Android)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final longGames = [
      {
        'id': 'lg1',
        'sport': 'Badminton',
        'name': 'Weekend Badminton Championship Tournament Extra Long Title',
        'type': 'Tournament',
        'venue': 'Super Ultra Mega Sports Arena Bangalore',
        'location': 'Near IT Park, Outer Ring Road, Mahadevapura, Bangalore',
        'date': '10 Sep 2026',
        'startTime': '09:00 AM',
        'endTime': '06:00 PM',
        'duration': 'Full Day',
        'teams': 16,
        'status': 'Requested',
        'visibility': 'Public',
        'isHost': true,
        'prize': 'Trophy + 1000 Cash Prize + Credits',
      },
      {
        'id': 'lg2',
        'sport': 'Cricket',
        'name': 'Premier League Season 5 Knockout Match',
        'type': 'Match',
        'venue': 'Champions Sports Academy & Complex',
        'location': 'Sector 4, HSR Layout, Bangalore',
        'date': '12 Sep 2026',
        'startTime': '05:00 PM',
        'endTime': '08:00 PM',
        'duration': '3 Hours',
        'players': 22,
        'status': 'Joined',
        'visibility': 'Private',
        'isHost': false,
      },
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MyGameHistoryScreen(initialGames: longGames),
      ),
    );
    await tester.pumpAndSettle();

    // Verify first card renders without any RenderFlex overflow
    expect(find.text('Weekend Badminton Championship Tournament Extra Long Title'), findsOneWidget);

    // Scroll down to verify second card
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Premier League Season 5 Knockout Match'), findsOneWidget);

    // Verify NO 'Accept Request' button appears anywhere
    expect(find.text('Accept Request'), findsNothing);
    expect(find.textContaining('Accept Request'), findsNothing);
  });
}





