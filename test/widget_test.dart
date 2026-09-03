import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:playveuw_app/main.dart';
import 'package:playveuw_app/screens/login_screen.dart';
import 'package:playveuw_app/screens/otp_verification_screen.dart';
import 'package:playveuw_app/screens/splash_screen.dart';
import 'package:playveuw_app/screens/admin/admin_home_screen.dart';
import 'package:playveuw_app/screens/admin/admin_plans_list_screen.dart';
import 'package:playveuw_app/screens/admin/admin_plans_screen.dart';
import 'package:playveuw_app/screens/admin/admin_player_list_screen.dart';
import 'package:playveuw_app/screens/admin/admin_revenue_screen.dart';
import 'package:playveuw_app/screens/admin/admin_settings_screen.dart';
import 'package:playveuw_app/screens/player/booking_confirmation_screen.dart';
import 'package:playveuw_app/screens/player/booking_details_screen.dart';
import 'package:playveuw_app/screens/player/booking_history_screen.dart';
import 'package:playveuw_app/screens/player/create_match_screen.dart';
import 'package:playveuw_app/screens/player/create_tournament_screen.dart';
import 'package:playveuw_app/screens/player/credit_success_screen.dart';
import 'package:playveuw_app/screens/player/equipment_detail_screen.dart';
import 'package:playveuw_app/screens/player/equipment_history_screen.dart';
import 'package:playveuw_app/screens/player/equipment_screen.dart';
import 'package:playveuw_app/screens/player/home_screen.dart';
import 'package:playveuw_app/screens/player/match_registration_screen.dart';
import 'package:playveuw_app/screens/player/memberships_screen.dart';
import 'package:playveuw_app/screens/player/my_game_history_screen.dart';
import 'package:playveuw_app/screens/player/play_screen.dart';
import 'package:playveuw_app/screens/player/profile_screen.dart';
import 'package:playveuw_app/screens/player/select_slot_screen.dart';
import 'package:playveuw_app/screens/player/select_sport_screen.dart';
import 'package:playveuw_app/screens/player/venue_details_screen.dart';
import 'package:playveuw_app/screens/player/venues_screen.dart';
import 'package:playveuw_app/state/app_booking_state.dart';
import 'package:playveuw_app/state/app_catalogue_state.dart';
import 'package:playveuw_app/state/app_facility_state.dart';
import 'package:playveuw_app/state/app_membership_state.dart';
import 'package:playveuw_app/state/app_rental_state.dart';
import 'package:playveuw_app/state/app_session.dart';
import 'package:playveuw_app/state/prototype_state.dart';
import 'package:playveuw_app/theme/app_theme.dart';
import 'package:playveuw_app/widgets/filter_pill.dart';

void main() {
  setUp(() {
    AppCreditsState.current = 20;
    AppCreditsState.hasShownLowCreditDialog = false;
    AppPlayState.reset();
    PrototypeState.reset();
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

    await tester.enterText(find.byType(TextFormField), '7777777777');
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
    await tester.pumpAndSettle();

    expect(find.text('Rental Confirmed!'), findsOneWidget);
    expect(find.text('Paid online'), findsOneWidget);

    await tester.tap(find.text('DONE'));
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
    await tester.pumpAndSettle();
    expect(find.text('Rental Confirmed!'), findsOneWidget);
    expect(find.text('Paid online'), findsOneWidget);
    expect(find.text('Use Credits'), findsNothing);

    // Credits balance remains untouched
    expect(AppCreditsState.current, 50);
    expect(AppRentalState.rentals.value.first.name, 'Yonex Astrox Racket');
    expect(AppCatalogueState.byId('eq1')!.stockCount, 7);
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
    expect(AppRentalState.rentals.value.firstWhere((r) => r.id == 'r1').status, 'Returned');
    expect(AppCatalogueState.byId('eq1')!.stockCount, 9);

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

  testWidgets('admin phone OTP opens AdminHomeScreen', (tester) async {
    await tester.pumpWidget(const PlayVueApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField), AppSession.adminPhone);
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.byType(OtpVerificationScreen), findsOneWidget);

    final otpFields = find.descendant(
      of: find.byType(OtpVerificationScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(otpFields.at(0), '1');
    await tester.enterText(otpFields.at(1), '2');
    await tester.enterText(otpFields.at(2), '3');
    await tester.enterText(otpFields.at(3), '4');
    await tester.tap(find.text('Verify'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.byType(AdminHomeScreen), findsOneWidget);
    expect(find.text('Good Morning, Admin 👋'), findsOneWidget);
    expect(find.text('₹24,500'), findsOneWidget);
  });

  testWidgets('admin can publish a plan and player can subscribe', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final weekend = AppMembershipState.plans.value
        .firstWhere((p) => p.id == 'plan_weekend');
    weekend.published = true;
    AppMembershipState.upsert(weekend);

    await tester.pumpWidget(
      const MaterialApp(home: MembershipsScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Weekend Pass'), findsOneWidget);
    await tester.tap(find.text('Subscribe').last);
    await tester.pumpAndSettle();
    expect(AppMembershipState.activePlan.value?.id, 'plan_weekend');
    expect(AppCreditsState.current, 100);
  });

  testWidgets('admin facility status hides venue from players', (tester) async {
    final smash = AppFacilityState.byId('v3')!;
    smash['status'] = 'Hidden';
    AppFacilityState.upsert(smash);

    expect(
      VenuesScreen.venues.any((v) => v['id'] == 'v3'),
      isFalse,
    );

    await tester.pumpWidget(
      MaterialApp(home: VenueDetailsScreen(venue: smash)),
    );
    expect(find.textContaining('UNAVAILABLE'), findsOneWidget);
  });

  testWidgets('admin can override booking status and refund credits', (tester) async {
    AppCreditsState.current = 20;
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.tap(find.widgetWithText(NavigationDestination, 'Bookings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Smash Arena').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Cancelled'));
    await tester.pumpAndSettle();

    expect(
      AppBookingState.bookings.value.firstWhere((b) => b.id == '1').status,
      'Cancelled',
    );
    expect(AppCreditsState.current, 70);
  });

  testWidgets('admin can mark rental as Overdue or Damaged from Rental Record bottom sheet', (tester) async {
    AppRentalState.reset();
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.tap(find.text('Catalogue'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Rentals'));
    await tester.pumpAndSettle();

    expect(find.text('Yonex Astrox Racket'), findsWidgets);
    expect(find.textContaining('due 04 Sep 2026'), findsWidgets);

    // Tap rental card -> Rental Record bottom sheet
    await tester.tap(find.text('Yonex Astrox Racket').first);
    await tester.pumpAndSettle();

    expect(find.text('Rental Record'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Damage'), findsOneWidget);
    expect(find.text('Update rental'), findsNothing);

    // Tap Overdue
    await tester.tap(find.text('Overdue'));
    await tester.pumpAndSettle();

    expect(
      AppRentalState.rentals.value.firstWhere((r) => r.id == 'r1').status,
      'Overdue',
    );

    // Tap rental card again -> mark as Damaged
    await tester.tap(find.text('Yonex Astrox Racket').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Damage'));
    await tester.pumpAndSettle();

    expect(
      AppRentalState.rentals.value.firstWhere((r) => r.id == 'r1').status,
      'Damaged',
    );
  });

  testWidgets('admin catalogue includes shoes and player can filter', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EquipmentScreen())),
    );
    await tester.tap(find.widgetWithText(FilterPill, 'Shoes'));
    await tester.pumpAndSettle();
    expect(find.text('Yonex Power Cushion Shoes'), findsOneWidget);
    expect(find.text('Nivia Football Studs'), findsOneWidget);
    expect(find.text('Yonex Astrox Racket'), findsNothing);
  });

  testWidgets('facility credit mapping is used for Smash Arena badminton', (tester) async {
    final smash = VenuesScreen.venues.firstWhere((v) => v['name'] == 'Smash Arena');
    await tester.pumpWidget(MaterialApp(home: SelectSlotScreen(venue: smash)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Badminton'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('1 Hour'));
    await tester.tap(find.text('1 Hour'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('09:00 AM'));
    await tester.tap(find.text('09:00 AM'));
    await tester.pumpAndSettle();

    expect(find.text('₹450 / 45 Credits'), findsOneWidget);
  });

  testWidgets('AdminDrawer renders header and only 5 menu items (Home, Plans, Players, Revenue, Logout) and navigates correctly', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Verify AppBar Menu button exists
    expect(find.byTooltip('Menu'), findsOneWidget);

    // Open Drawer
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();

    // Verify Admin Header
    expect(find.text('PlayVue Admin'), findsOneWidget);
    expect(find.text('admin@example.com'), findsOneWidget);
    expect(find.text('A'), findsWidgets);

    // Verify only the 5 menu options are present in the drawer
    expect(find.descendant(of: find.byType(Drawer), matching: find.text('Home')), findsOneWidget);
    expect(find.descendant(of: find.byType(Drawer), matching: find.text('Plans')), findsOneWidget);
    expect(find.descendant(of: find.byType(Drawer), matching: find.text('Players')), findsOneWidget);
    expect(find.descendant(of: find.byType(Drawer), matching: find.text('Revenue')), findsOneWidget);
    expect(find.descendant(of: find.byType(Drawer), matching: find.text('Logout')), findsOneWidget);

    // Verify removed drawer options are NOT present
    expect(find.text('Settings'), findsNothing);

    // 1. Navigate to Plans via Drawer
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Plans')));
    await tester.pumpAndSettle();

    // Verify AdminPlansListScreen opened with 5 plans
    expect(find.byType(AdminPlansListScreen), findsOneWidget);
    expect(find.text('Basic Plan'), findsOneWidget);
    expect(find.text('Premium Plan'), findsOneWidget);
    expect(find.text('Pro Plan'), findsOneWidget);
    expect(find.text('Elite Plan'), findsOneWidget);
    expect(find.text('Ultimate Plan'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    // 2. Navigate to Players via Drawer
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Players')));
    await tester.pumpAndSettle();

    // Verify AdminPlayerListScreen opened
    expect(find.byType(AdminPlayerListScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    // 3. Navigate to Revenue via Drawer
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Revenue')));
    await tester.pumpAndSettle();

    // Verify AdminRevenueScreen opened
    expect(find.byType(AdminRevenueScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    // 4. Navigate to Home via Drawer
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Home')));
    await tester.pumpAndSettle();

    expect(find.text('Good Morning, Admin 👋'), findsOneWidget);

    // 5. Test Logout flow with confirmation dialog
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Logout')));
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Logout?'), findsOneWidget);
    expect(find.text('Are you sure you want to logout?'), findsOneWidget);

    // Cancel dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Logout?'), findsNothing);

    // Tap Logout again and confirm
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(Drawer), matching: find.text('Logout')));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Logout'));
    await tester.pumpAndSettle();

    // Verify navigated to LoginScreen and session reset
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(AppSession.phone, '');
    expect(AppSession.isAdmin, isFalse);
  });

  testWidgets('Admin Home displays AppBar unchanged and renders complete redesigned dashboard content', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // 1. Verify AppBar is completely unchanged
    expect(find.text('Add Plan'), findsOneWidget);
    final addPlanImages = find.descendant(
      of: find.widgetWithText(FilledButton, 'Add Plan'),
      matching: find.byType(Image),
    );
    expect(addPlanImages, findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);

    // 2. Verify Admin Home Header
    expect(find.text('Good Morning, Admin 👋'), findsOneWidget);

    // 3. Verify Unified KPI Dashboard Card (2x2 layout)
    expect(find.text("Today's Revenue"), findsOneWidget);
    expect(find.text('₹24,500'), findsOneWidget);
    expect(find.text("Today's Bookings"), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Players'), findsWidgets);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Courts'), findsOneWidget);
    expect(find.text('8 / 12'), findsOneWidget);

    // 4. Verify Quick Actions is completely removed
    expect(find.text('QUICK ACTIONS'), findsNothing);
    expect(find.text('+ Venue'), findsNothing);
    expect(find.text('+ Court'), findsNothing);
    expect(find.text('+ Item'), findsNothing);
    expect(find.text('+ Offer'), findsNothing);
    expect(find.text('+ Notice'), findsNothing);

    // 5. Verify Plans (clean cards without View All, plan name as regular heading, price, credits, duration)
    expect(find.text('PLANS'), findsOneWidget);
    expect(find.text('Basic Plan'), findsOneWidget);
    expect(find.text('Premium Plan'), findsOneWidget);
    expect(find.text('₹499 / 30 Days'), findsWidgets);
    expect(find.text('50 Credits'), findsOneWidget);
    expect(find.text('Duration: 30 Days'), findsWidgets);

    // 6. Verify Today's Bookings is removed completely
    expect(find.text("TODAY'S BOOKINGS"), findsNothing);
    expect(find.text('Badminton Court 1'), findsNothing);

    // 7. Verify Revenue Overview with View Detail action
    expect(find.text('REVENUE OVERVIEW'), findsOneWidget);
    expect(find.text('View Detail'), findsOneWidget);
    expect(find.text('Venue Booking'), findsOneWidget);
    expect(find.text('₹1,20,000'), findsOneWidget);
    expect(find.text('Membership'), findsOneWidget);
    expect(find.text('₹40,000'), findsOneWidget);
    expect(find.text('Equipment Rental'), findsOneWidget);
    expect(find.text('₹14,500'), findsOneWidget);

    // 8. Verify Court Utilisation
    expect(find.text('COURT UTILISATION'), findsOneWidget);
    expect(find.text('Badminton'), findsOneWidget);
    expect(find.text('90%'), findsOneWidget);
    expect(find.text('Football'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('Cricket'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);

    // 9. Verify Equipment Summary
    expect(find.text('EQUIPMENT'), findsOneWidget);
    expect(find.text('156'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('121'), findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);
    expect(find.text('Rented'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Damaged'), findsOneWidget);

    // 10. Verify Attention Required
    expect(find.text('ATTENTION REQUIRED'), findsOneWidget);
    expect(find.text('3 Overdue Rentals'), findsOneWidget);
    expect(find.text('2 Damaged Items'), findsOneWidget);
    expect(find.text('4 Pending Bookings'), findsOneWidget);

    // 11. Verify Recent Players
    expect(find.text('RECENT PLAYERS'), findsOneWidget);
    expect(find.text('Rahul Kumar'), findsOneWidget);
    expect(find.text('Arun Kumar'), findsOneWidget);
    expect(find.text('Vijay Kumar'), findsOneWidget);

    // 12. Test Revenue Overview -> View Detail navigates to AdminRevenueScreen
    await tester.tap(find.text('View Detail'));
    await tester.pumpAndSettle();

    expect(find.text('Revenue Breakdown'), findsOneWidget);
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('Venue Revenue'), findsWidgets);
    expect(find.text('Membership Revenue'), findsWidgets);
    expect(find.text('Rental Revenue'), findsWidgets);
    expect(find.text('₹1,75,000'), findsOneWidget);
    expect(find.text('August 2026'), findsOneWidget);

    // Pop back from Revenue Screen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 13. Test Recent Players -> View All navigates to AdminPlayerListScreen
    await tester.tap(find.text('View All').last);
    await tester.pumpAndSettle();

    expect(find.text('Registered Players'), findsOneWidget);
    expect(find.text('Rahul Kumar'), findsOneWidget);
    expect(find.text('Logesh K'), findsOneWidget);
    expect(find.text('Priya Sharma'), findsOneWidget);

    // Test player search
    await tester.enterText(find.byType(TextField), 'Logesh');
    await tester.pumpAndSettle();
    expect(find.text('Logesh K'), findsOneWidget);
    expect(find.text('Rahul Kumar'), findsNothing);

    // Pop back from Player List Screen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 14. Test Notification icon opens AdminNotificationScreen
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('New Booking'), findsOneWidget);
    expect(find.text('A new venue booking was created for Smash Arena.'), findsOneWidget);

    // Pop back to AdminHomeScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Good Morning, Admin 👋'), findsOneWidget);
    expect(find.text('Add Plan'), findsOneWidget);
  });

  testWidgets('Admin Facilities Screen displays Add Facility button and allows adding a new facility with Photo Upload', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Switch to Facilities Tab
    await tester.tap(find.widgetWithText(NavigationDestination, 'Facilities'));
    await tester.pumpAndSettle();

    // Verify AppBar shows Add Facility action
    expect(find.text('Add Facility'), findsOneWidget);
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);

    // Tap Add Facility
    await tester.tap(find.text('Add Facility'));
    await tester.pumpAndSettle();

    // Verify Add Facility Screen and Photo Upload Area
    expect(find.text('Add Facility'), findsWidgets);
    expect(find.text('FACILITY DETAILS'), findsOneWidget);
    expect(find.text('SUPPORTED SPORTS'), findsOneWidget);
    expect(find.text('RENTAL & BOOKING SETTINGS'), findsOneWidget);
    expect(find.text('Facility Photo'), findsOneWidget);
    expect(find.text('Upload Photo'), findsOneWidget);
    expect(find.text('JPG, PNG supported'), findsOneWidget);

    // Test Photo Upload picker sheet
    await tester.tap(find.text('Upload Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Select Facility Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);

    await tester.tap(find.text('Choose from Gallery'));
    await tester.pumpAndSettle();

    // Verify Photo Preview and Change Photo button appear
    expect(find.text('Change Photo'), findsOneWidget);

    // Attempt to add without name (validation check)
    await tester.tap(find.widgetWithText(FilledButton, 'Add Facility'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter a facility name.'), findsOneWidget);

    // Enter name and location
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'Skyline Badminton Hub'); // Name
    await tester.enterText(textFields.at(3), 'Koramangala, Bengaluru'); // Location
    await tester.enterText(textFields.at(4), 'State-of-the-art wooden courts.'); // Description

    // Tap Add Facility button
    await tester.tap(find.widgetWithText(FilledButton, 'Add Facility'));
    await tester.pumpAndSettle();

    // Verify back on Facilities Screen and new facility is immediately visible
    expect(find.text('Skyline Badminton Hub'), findsOneWidget);
    expect(find.text('PlayVue Sports Academy'), findsOneWidget);
  });

  testWidgets('Admin Catalogue filters: category and sport work together and display Unique Item IDs', (tester) async {
    AppCatalogueState.reset();
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Navigate to Catalogue tab (index 3)
    await tester.tap(find.text('Catalogue'));
    await tester.pumpAndSettle();

    // Verify Filters exist
    expect(find.text('CATEGORIES'), findsOneWidget);
    expect(find.text('SPORTS'), findsOneWidget);
    expect(find.text('Equipment'), findsWidgets);
    expect(find.text('Gear'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('Badminton'), findsWidgets);
    expect(find.text('Football'), findsWidgets);
    expect(find.text('Cricket'), findsWidgets);
    expect(find.text('TT'), findsOneWidget);
    expect(find.text('Carrom'), findsOneWidget);

    // Verify Unique Item ID on cards
    expect(find.text('Item ID: RACKET-BDM-001'), findsOneWidget);
    expect(find.text('Item ID: BALL-FB-001'), findsOneWidget);

    // Filter by Shoes
    await tester.tap(find.text('Shoes').first);
    await tester.pumpAndSettle();

    expect(find.text('Yonex Power Cushion Shoes'), findsOneWidget);
    expect(find.text('Nivia Football Studs'), findsOneWidget);
    expect(find.text('Yonex Astrox Racket'), findsNothing);

    // Filter by Shoes + Football -> only Nivia Football Studs
    await tester.tap(find.text('Football').first);
    await tester.pumpAndSettle();

    expect(find.text('Nivia Football Studs'), findsOneWidget);
    expect(find.text('Yonex Power Cushion Shoes'), findsNothing);

    // Reset filters to All + All
    await tester.tap(find.text('All').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('All').at(1));
    await tester.pumpAndSettle();

    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Football Size 5'), findsOneWidget);
  });

  testWidgets('Admin Return flow: checks unique ID, handles invalid, already returned, and successful return with availability update', (tester) async {
    AppCatalogueState.reset();
    AppRentalState.reset();

    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Navigate to Catalogue tab
    await tester.tap(find.text('Catalogue'));
    await tester.pumpAndSettle();

    // Switch to Rentals sub-tab
    await tester.tap(find.text('Rentals'));
    await tester.pumpAndSettle();

    expect(find.text('RETURN EQUIPMENT'), findsOneWidget);
    expect(find.text('Check Item'), findsOneWidget);

    // 1. Test Invalid ID
    await tester.enterText(find.byType(TextField).first, 'BAT-BDM-999');
    await tester.tap(find.text('Check Item'));
    await tester.pumpAndSettle();

    expect(find.text('Item Not Found'), findsOneWidget);
    expect(find.text('No catalogue item was found with ID:\nBAT-BDM-999'), findsOneWidget);
    await tester.tap(find.text('Okay'));
    await tester.pumpAndSettle();

    // 2. Test Already Returned ID (KIT-CRI-001 is seeded as Returned)
    await tester.enterText(find.byType(TextField).first, 'KIT-CRI-001');
    await tester.tap(find.text('Check Item'));
    await tester.pumpAndSettle();

    expect(find.text('Item Already Returned'), findsOneWidget);
    expect(find.text('KIT-CRI-001 is not currently rented.'), findsOneWidget);
    await tester.tap(find.text('Okay'));
    await tester.pumpAndSettle();

    // 3. Test Actively Rented ID (RACKET-BDM-001 is seeded as Rented)
    final initialStock = AppCatalogueState.byId('eq1')!.stockCount;
    await tester.enterText(find.byType(TextField).first, 'RACKET-BDM-001');
    await tester.tap(find.text('Check Item'));
    await tester.pumpAndSettle();

    // Bottom sheet appears with rental info
    expect(find.text('Item Found'), findsOneWidget);
    expect(find.text('Item: Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Item ID: RACKET-BDM-001'), findsWidgets);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Damage'), findsOneWidget);
    expect(find.text('Mark as Returned'), findsOneWidget);

    // Tap Mark as Returned -> Confirmation Dialog
    await tester.tap(find.text('Mark as Returned'));
    await tester.pumpAndSettle();

    expect(find.text('Return Equipment?'), findsOneWidget);
    expect(find.textContaining('Are you sure you want to mark RACKET-BDM-001 as returned?'), findsOneWidget);

    // Tap Returned in dialog
    await tester.tap(find.widgetWithText(FilledButton, 'Returned'));
    await tester.pumpAndSettle();

    // Verify status updated and stock increased
    final updatedRental = AppRentalState.findByUniqueId('RACKET-BDM-001');
    expect(updatedRental?.status, 'Returned');
    expect(AppCatalogueState.byId('eq1')!.stockCount, initialStock + 1);
  });

  testWidgets('Admin Bookings Screen renders header, date & name filters, summary count, full day, and empty state', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    AppBookingState.reset();
    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Switch to Bookings tab (index 2)
    await tester.tap(find.widgetWithText(NavigationDestination, 'Bookings'));
    await tester.pumpAndSettle();

    // 1. Verify AppBar title is Bookings and body subtitle is removed
    expect(find.widgetWithText(AppBar, 'Bookings'), findsOneWidget);
    expect(find.text('Manage and track all facility bookings'), findsNothing);

    // 2. Verify Filter section
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Select Date'), findsOneWidget);
    expect(find.text('Player Name'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('5 Bookings'), findsOneWidget);

    // 3. Verify cards content & Full Day
    expect(find.text('Rahul Kumar'), findsWidgets);
    expect(find.text('Arun Kumar'), findsOneWidget);
    expect(find.text('Duration: Full Day'), findsOneWidget);
    expect(find.text('06:00 AM - 10:00 PM'), findsOneWidget);

    // 4. Test Player Name filter
    await tester.enterText(find.byType(TextField).first, 'Rahul');
    await tester.pumpAndSettle();

    expect(find.text('2 Bookings Found'), findsOneWidget);
    expect(find.text('Rahul Kumar'), findsWidgets);
    expect(find.text('Arun Kumar'), findsNothing);
    expect(find.text('Clear Filters'), findsOneWidget);

    // 5. Test Clear Filters
    await tester.tap(find.text('Clear Filters'));
    await tester.pumpAndSettle();

    expect(find.text('5 Bookings'), findsOneWidget);
    expect(find.text('Arun Kumar'), findsOneWidget);

    // 6. Test No Bookings Found empty state
    await tester.enterText(find.byType(TextField).first, 'NonExistentPlayer');
    await tester.pumpAndSettle();

    expect(find.text('0 Bookings Found'), findsOneWidget);
    expect(find.text('No Bookings Found'), findsOneWidget);
    expect(find.text('No bookings match the selected filters.'), findsOneWidget);

    // Clear filters from empty state
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear Filters'));
    await tester.pumpAndSettle();

    expect(find.text('5 Bookings'), findsOneWidget);
    expect(find.text('Rahul Kumar'), findsWidgets);
  });

  testWidgets('Admin Profile Screen matches Player Profile layout with admin-specific options and navigation', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: AdminHomeScreen()));
    await tester.pumpAndSettle();

    // Switch to Profile tab (index 4)
    await tester.tap(find.widgetWithText(NavigationDestination, 'Profile'));
    await tester.pumpAndSettle();

    // 1. Verify Header layout (Avatar, Name, Role badge, Subtitle)
    expect(find.text('A'), findsWidgets);
    expect(find.text('PlayVue Admin'), findsOneWidget);
    expect(find.text('Admin'), findsWidgets);
    expect(find.text('admin@playveuw.com  ·  Bengaluru, Karnataka'), findsOneWidget);

    // 2. Verify Stats Card
    expect(find.text('8'), findsOneWidget);
    expect(find.text('Facilities'), findsWidgets);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Players'), findsWidgets);

    // 3. Verify Admin Sections & Options
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('Profile Information'), findsOneWidget);

    expect(find.text('MANAGEMENT'), findsNothing);

    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    expect(find.text('Logout'), findsNothing);

    // 4. Verify No Player-specific options
    expect(find.text('My Games'), findsNothing);
    expect(find.text('Credits available'), findsNothing);
    expect(find.text('Sports you play'), findsNothing);

    // 5. Test Profile Information bottom sheet
    await tester.tap(find.text('Profile Information'));
    await tester.pumpAndSettle();

    expect(find.text('Administrator'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    Navigator.of(tester.element(find.text('Administrator'))).pop();
    await tester.pumpAndSettle();

    // 6. Test Settings navigation
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(AdminSettingsScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets('admin and player equipment data, unique ID, and status are synchronized across catalogue, rentals, and My Equipments', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    AppCatalogueState.reset();
    AppRentalState.reset();

    // 1. Admin Catalogue displays the equipment with its unique ID
    final racket = AppCatalogueState.byId('eq1')!;
    expect(racket.name, 'Yonex Astrox Racket');
    expect(racket.sport, 'Badminton');
    expect(racket.physicalIds.contains('RACKET-BDM-001'), isTrue);
    expect(racket.physicalIds.contains('RACKET-BDM-002'), isTrue);

    // 2. Player opens My Equipments and sees the same RACKET-BDM-001 with matching data
    await tester.pumpWidget(
      const MaterialApp(home: EquipmentHistoryScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Badminton • Rackets & Bats'), findsOneWidget);
    expect(find.text('ID: RACKET-BDM-001'), findsWidgets);
    expect(find.text('Status: Rented'), findsWidgets);

    // 3. Admin overrides status to Overdue -> Player My Equipments reflects Overdue
    AppRentalState.overrideStatus('r1', 'Overdue');
    await tester.pumpAndSettle();

    expect(find.text('Status: Overdue'), findsOneWidget);

    // 4. Admin overrides status to Damaged -> Player My Equipments reflects Damaged
    AppRentalState.overrideStatus('r1', 'Damaged');
    await tester.pumpAndSettle();

    expect(find.text('Status: Damaged'), findsOneWidget);

    // 5. Admin marks RACKET-BDM-001 as Returned -> Player My Equipments reflects Returned
    AppRentalState.returnByUniqueId('RACKET-BDM-001');
    await tester.pumpAndSettle();

    expect(find.text('Status: Returned'), findsWidgets);
    expect(AppRentalState.isPhysicalIdRented('RACKET-BDM-001'), isFalse);

    // 6. Next rental of Yonex Astrox Racket gets the exact same RACKET-BDM-001 physical ID without regenerating
    final reRented = AppRentalState.rent(
      racket,
      playerName: 'Arun Kumar',
    );
    expect(reRented.uniqueItemId, 'RACKET-BDM-001');
    expect(reRented.playerName, 'Arun Kumar');
    expect(reRented.name, 'Yonex Astrox Racket');
  });

  testWidgets('Player Equipment Details Screen matches shared equipment record, displays Unique ID, and syncs status with Admin and My Equipments', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    AppCatalogueState.reset();
    AppRentalState.reset();

    // 1. Open My Equipments
    await tester.pumpWidget(
      const MaterialApp(home: EquipmentHistoryScreen()),
    );
    await tester.pumpAndSettle();

    // 2. Tap on Yonex Astrox Racket card to open EquipmentDetailScreen
    await tester.tap(find.text('Yonex Astrox Racket'));
    await tester.pumpAndSettle();

    expect(find.byType(EquipmentDetailScreen), findsOneWidget);

    // 3. Verify fields match shared equipment record
    expect(find.text('Yonex Astrox Racket'), findsOneWidget);
    expect(find.text('Rackets & Bats'), findsWidgets);
    expect(find.text('Badminton'), findsOneWidget);
    expect(find.text('Unique ID: RACKET-BDM-001'), findsOneWidget);
    expect(find.text('Rental Date'), findsOneWidget);
    expect(find.text('02 Sep 2026'), findsOneWidget);
    expect(find.text('Rental Duration'), findsOneWidget);
    expect(find.text('2 Days'), findsOneWidget);
    expect(find.text('Due Date'), findsOneWidget);
    expect(find.text('04 Sep 2026'), findsOneWidget);
    expect(find.text('Rental Price'), findsOneWidget);
    expect(find.text('₹200'), findsOneWidget);
    expect(find.text('Status: Rented'), findsWidgets);
    expect(find.text('Return Equipment'), findsOneWidget);

    // 4. Admin marks as Overdue -> Equipment Details updates dynamically
    AppRentalState.overrideStatus('r1', 'Overdue');
    await tester.pumpAndSettle();

    expect(find.text('Status: Overdue'), findsWidgets);

    // 5. Admin marks as Damaged -> Equipment Details updates dynamically
    AppRentalState.overrideStatus('r1', 'Damaged');
    await tester.pumpAndSettle();

    expect(find.text('Status: Damaged'), findsWidgets);

    // 6. Reset back to Rented and test Return flow from EquipmentDetailScreen
    AppRentalState.overrideStatus('r1', 'Rented');
    await tester.pumpAndSettle();
    expect(find.text('Return Equipment'), findsOneWidget);

    await tester.tap(find.text('Return Equipment'));
    await tester.pumpAndSettle();

    expect(find.text('Return Equipment?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to return RACKET-BDM-001 (Yonex Astrox Racket)?'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Return'));
    await tester.pumpAndSettle();

    expect(find.text('Status: Returned'), findsWidgets);
    expect(AppRentalState.findByUniqueId('RACKET-BDM-001')?.status, 'Returned');
  });

  testWidgets('AdminPlanEditorScreen keeps only Discount and removes subsidy, PlayVue/Venue, and credit mapping options', (tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(home: AdminPlanEditorScreen()),
    );
    await tester.pumpAndSettle();

    // 1. Verify Plan fields
    expect(find.text('New plan'), findsOneWidget);
    expect(find.text('PLAN'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Price ₹'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Credits'), findsOneWidget);

    // 2. Verify Discount field is present
    expect(find.text('DISCOUNT'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Discount %'), findsOneWidget);

    // 3. Verify Subsidy and PlayVue / Venue options are completely removed
    expect(find.text('Subsidy'), findsNothing);
    expect(find.text('Subsidy cr'), findsNothing);
    expect(find.text('PlayVue'), findsNothing);
    expect(find.text('Venue'), findsNothing);
    expect(find.text('Discount & subsidy'), findsNothing);

    // 4. Verify Credit mapping options are completely removed
    expect(find.text('Credit mapping'), findsNothing);
    expect(find.text('Add mapping'), findsNothing);
    expect(find.text('Uses facility rates if empty.'), findsNothing);

    // 5. Fill in plan details and save
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Pro Annual Plan');
    await tester.enterText(find.widgetWithText(TextField, 'Price ₹'), '1999');
    await tester.enterText(find.widgetWithText(TextField, 'Credits'), '500');
    await tester.enterText(find.widgetWithText(TextField, 'Discount %'), '15');
    await tester.tap(find.text('Yearly'));
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save plan'));
    await tester.pumpAndSettle();

    final saved = AppMembershipState.plans.value.firstWhere(
      (p) => p.name == 'Pro Annual Plan',
    );
    expect(saved.priceInr, 1999);
    expect(saved.creditsGranted, 500);
    expect(saved.discountPercent, 15);
    expect(saved.duration, 'Yearly');
    expect(saved.published, isTrue);
    expect(saved.subsidyCredits, 0);
  });
}





