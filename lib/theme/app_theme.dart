import 'package:flutter/material.dart';

/// Light-blue palette sampled from the PlayVue splash logo and app icon.
abstract final class AppColors {
  static const primary = Color(0xFF1E9BE8);
  static const primaryDark = Color(0xFF0B6CB3);
  static const primarySoft = Color(0xFF5EC8F8);
  static const accent = Color(0xFF2ECC71);
  static const navy = Color(0xFF0A2A4A);
  static const textSecondary = Color(0xFF5A7A94);
  static const backgroundTop = Color(0xFFEAF6FF);
  static const backgroundBottom = Color(0xFFF8FCFF);
  static const fieldFill = Color(0xFFFFFFFF);
  static const fieldBorder = Color(0xFFD3E8F6);
}

abstract final class AppSurfaces {
  static const radius = 12.0;

  static BoxDecoration card({Color? border, Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border ?? AppColors.fieldBorder),
    );
  }

  static const bar = BoxDecoration(
    color: Colors.white,
    border: Border(top: BorderSide(color: AppColors.fieldBorder)),
  );
}

abstract final class AppCreditsState {
  static final ValueNotifier<int> balance = ValueNotifier<int>(20);
  static bool hasShownLowCreditDialog = false;

  static int get current => balance.value;
  static set current(int val) {
    balance.value = val;
    if (val >= 10) {
      hasShownLowCreditDialog = false;
    }
  }

  static void add(int amount) {
    balance.value += amount;
    if (balance.value >= 10) {
      hasShownLowCreditDialog = false;
    }
  }

  static bool deduct(int amount) {
    if (balance.value >= amount) {
      balance.value -= amount;
      return true;
    }
    return false;
  }
}

abstract final class AppPlayState {
  static final ValueNotifier<List<Map<String, dynamic>>> openMatches =
      ValueNotifier<List<Map<String, dynamic>>>(List<Map<String, dynamic>>.from(_initialOpenMatches));

  static final ValueNotifier<List<Map<String, dynamic>>> myGames =
      ValueNotifier<List<Map<String, dynamic>>>(List<Map<String, dynamic>>.from(_initialMyGames));

  static const List<Map<String, dynamic>> _initialOpenMatches = [
    {
      'id': 'm1',
      'sport': 'Badminton',
      'game': 'Badminton Doubles',
      'venue': 'Smash Arena',
      'date': 'Today',
      'time': '06:00 PM - 08:00 PM',
      'duration': '2 Hours',
      'spots': '1 spot left',
      'playersCount': '7 / 8 Players',
      'players': 7,
      'totalPlayers': 8,
      'isFull': false,
      'visibility': 'Public',
      'userStatus': 'none',
      'isHost': false,
    },
    {
      'id': 'm2',
      'sport': 'Football',
      'game': 'Football 5v5',
      'venue': 'Champions Sports Club',
      'date': 'Tomorrow',
      'time': '07:30 AM - 09:00 AM',
      'duration': '1.5 Hours',
      'spots': '3 spots left',
      'playersCount': '7 / 10 Players',
      'players': 7,
      'totalPlayers': 10,
      'isFull': false,
      'visibility': 'Public',
      'userStatus': 'none',
      'isHost': false,
    },
    {
      'id': 'm3',
      'sport': 'Cricket',
      'game': 'Box Cricket',
      'venue': 'PlayVue Sports Academy',
      'date': 'Sat, 05 Sep',
      'time': '05:00 PM - 08:00 PM',
      'duration': '3 Hours',
      'spots': '4 spots left',
      'playersCount': '8 / 12 Players',
      'players': 8,
      'totalPlayers': 12,
      'isFull': false,
      'visibility': 'Public',
      'userStatus': 'none',
      'isHost': false,
    },
    {
      'id': 'm4',
      'sport': 'Table Tennis',
      'game': 'Table Tennis Singles',
      'venue': 'Elite Sports Arena',
      'date': 'Sun, 06 Sep',
      'time': '11:00 AM - 12:30 PM',
      'duration': '1.5 Hours',
      'spots': '2 spots left',
      'playersCount': '2 / 4 Players',
      'players': 2,
      'totalPlayers': 4,
      'isFull': false,
      'visibility': 'Public',
      'userStatus': 'none',
      'isHost': false,
    },
    {
      'id': 'm5',
      'sport': 'Pickleball',
      'game': 'Pickleball Weekend Blast',
      'venue': 'Smash Arena',
      'date': 'Sun, 06 Sep',
      'time': '04:00 PM - 06:00 PM',
      'duration': '2 Hours',
      'spots': 'Full (0 spots left)',
      'playersCount': '8 / 8 Players',
      'players': 8,
      'totalPlayers': 8,
      'isFull': true,
      'visibility': 'Public',
      'userStatus': 'none',
      'isHost': false,
    },
  ];

  static const List<Map<String, dynamic>> _initialMyGames = [
    {
      'id': 'g1',
      'sport': 'Badminton',
      'name': 'Sunday Badminton Match',
      'type': 'Match',
      'venue': 'Smash Arena',
      'location': 'Indiranagar, Bangalore',
      'date': '06 Sep 2026',
      'startTime': '06:00 PM',
      'endTime': '08:00 PM',
      'duration': '2 Hours',
      'players': 8,
      'status': 'Completed',
      'visibility': 'Public',
      'isHost': false,
    },
    {
      'id': 'g2',
      'sport': 'Football',
      'name': 'Weekend Football 5v5',
      'type': 'Match',
      'venue': 'PlayVue Sports Academy',
      'location': 'Koramangala, Bangalore',
      'date': '07 Sep 2026',
      'startTime': '07:00 PM',
      'endTime': '09:00 PM',
      'duration': '2 Hours',
      'players': 10,
      'status': 'Upcoming',
      'visibility': 'Public',
      'isHost': true,
    },
    {
      'id': 'g3',
      'sport': 'Cricket',
      'name': 'Box Cricket Premier',
      'type': 'Match',
      'venue': 'Champions Sports Club',
      'location': 'HSR Layout, Bangalore',
      'date': '08 Sep 2026',
      'startTime': '05:00 PM',
      'endTime': '08:00 PM',
      'duration': '3 Hours',
      'players': 12,
      'status': 'Ongoing',
      'visibility': 'Public',
      'isHost': false,
    },
    {
      'id': 'g4',
      'sport': 'Pickleball',
      'name': 'Pickleball Doubles Night',
      'type': 'Match',
      'venue': 'Smash Arena',
      'location': 'Indiranagar, Bangalore',
      'date': '09 Sep 2026',
      'startTime': '07:00 PM',
      'endTime': '08:30 PM',
      'duration': '1.5 Hours',
      'players': 4,
      'status': 'Registered',
      'visibility': 'Public',
      'isHost': false,
    },
    {
      'id': 'g5',
      'sport': 'Cricket',
      'name': 'Weekend Cricket Cup',
      'type': 'Tournament',
      'venue': 'Sports Arena',
      'location': 'Whitefield, Bangalore',
      'date': '10 Sep 2026',
      'startTime': '09:00 AM',
      'endTime': '06:00 PM',
      'duration': 'Full Day',
      'teams': 8,
      'status': 'Upcoming',
      'prize': 'Trophy & 500 Credits',
      'visibility': 'Public',
      'isHost': true,
    },
  ];

  static void reset() {
    openMatches.value = List<Map<String, dynamic>>.from(
      _initialOpenMatches.map((m) => Map<String, dynamic>.from(m)),
    );
    myGames.value = List<Map<String, dynamic>>.from(
      _initialMyGames.map((g) => Map<String, dynamic>.from(g)),
    );
  }

  static void addMatch({
    required String sport,
    required String title,
    required String venue,
    required String date,
    required String time,
    required int maxPlayers,
    required String skillLevel,
    required String matchType,
    required String visibility,
  }) {
    final newId = 'match_${DateTime.now().millisecondsSinceEpoch}';

    if (visibility == 'Public') {
      final newOpenMatch = <String, dynamic>{
        'id': newId,
        'sport': sport,
        'game': title,
        'venue': venue,
        'date': date,
        'time': time,
        'duration': '2 Hours',
        'spots': '$maxPlayers spots left',
        'playersCount': '0 / $maxPlayers Players',
        'players': 0,
        'totalPlayers': maxPlayers,
        'isFull': false,
        'visibility': 'Public',
        'userStatus': 'none',
        'isHost': true,
      };
      openMatches.value = [newOpenMatch, ...openMatches.value];
    }

    final newMyGame = <String, dynamic>{
      'id': newId,
      'sport': sport,
      'name': title,
      'type': 'Match',
      'venue': venue,
      'location': 'Bengaluru',
      'date': date,
      'startTime': time.split(' - ').first,
      'endTime': time.split(' - ').length > 1 ? time.split(' - ')[1] : time,
      'duration': '2 Hours',
      'players': maxPlayers,
      'status': 'Upcoming',
      'visibility': visibility,
      'isHost': true,
    };
    myGames.value = [newMyGame, ...myGames.value];
  }

  static void addTournament({
    required String sport,
    required String title,
    required String venue,
    required String date,
    required String time,
    required String format,
    required String maxTeams,
    required String entryFee,
    required String prize,
    required String visibility,
  }) {
    final newId = 'tourn_${DateTime.now().millisecondsSinceEpoch}';
    final parsedTeams = int.tryParse(maxTeams.replaceAll(RegExp(r'[^0-9]'), '')) ?? 8;

    if (visibility == 'Public') {
      final newOpenTournament = <String, dynamic>{
        'id': newId,
        'sport': sport,
        'game': title,
        'venue': venue,
        'date': date,
        'time': time,
        'duration': 'Full Day',
        'spots': '$maxTeams available',
        'playersCount': '0 / $maxTeams',
        'players': 0,
        'totalPlayers': parsedTeams,
        'isFull': false,
        'visibility': 'Public',
        'userStatus': 'none',
        'isHost': true,
      };
      openMatches.value = [newOpenTournament, ...openMatches.value];
    }

    final newMyGame = <String, dynamic>{
      'id': newId,
      'sport': sport,
      'name': title,
      'type': 'Tournament',
      'venue': venue,
      'location': 'Bengaluru',
      'date': date,
      'startTime': time.split(' - ').first,
      'endTime': time.split(' - ').length > 1 ? time.split(' - ')[1] : time,
      'duration': 'Full Day',
      'teams': parsedTeams,
      'status': 'Upcoming',
      'prize': prize,
      'visibility': visibility,
      'isHost': true,
    };
    myGames.value = [newMyGame, ...myGames.value];
  }

  static void requestJoinMatch(String matchId) {
    final updatedMatches = List<Map<String, dynamic>>.from(
      openMatches.value.map((m) {
        if (m['id'] == matchId) {
          final copy = Map<String, dynamic>.from(m);
          copy['userStatus'] = 'Requested';
          return copy;
        }
        return m;
      }),
    );
    openMatches.value = updatedMatches;

    final target = openMatches.value.firstWhere(
      (m) => m['id'] == matchId,
      orElse: () => <String, dynamic>{},
    );

    if (target.isNotEmpty) {
      final exists = myGames.value.any((g) => g['id'] == matchId);
      if (exists) {
        myGames.value = List<Map<String, dynamic>>.from(
          myGames.value.map((g) {
            if (g['id'] == matchId) {
              final copy = Map<String, dynamic>.from(g);
              copy['status'] = 'Requested';
              return copy;
            }
            return g;
          }),
        );
      } else {
        final newGame = <String, dynamic>{
          'id': matchId,
          'sport': target['sport'] ?? 'Sport',
          'name': target['game'] ?? 'Match',
          'type': 'Match',
          'venue': target['venue'] ?? 'Venue',
          'location': 'Bengaluru',
          'date': target['date'] ?? 'Upcoming',
          'startTime': (target['time'] as String? ?? '').split(' - ').first,
          'endTime': (target['time'] as String? ?? '').split(' - ').length > 1
              ? (target['time'] as String).split(' - ')[1]
              : target['time'] ?? '',
          'duration': target['duration'] ?? '2 Hours',
          'players': target['totalPlayers'] ?? 8,
          'status': 'Requested',
          'visibility': 'Public',
          'isHost': false,
        };
        myGames.value = [newGame, ...myGames.value];
      }
    }
  }

  static void acceptJoinRequest(String matchId) {
    final updatedMatches = List<Map<String, dynamic>>.from(
      openMatches.value.map((m) {
        if (m['id'] == matchId) {
          final copy = Map<String, dynamic>.from(m);
          final currentPlayers = (copy['players'] as int? ?? 0) + 1;
          final total = copy['totalPlayers'] as int? ?? currentPlayers;
          copy['players'] = currentPlayers;
          copy['playersCount'] = '$currentPlayers / $total Players';
          final remaining = total - currentPlayers;
          if (remaining <= 0) {
            copy['isFull'] = true;
            copy['spots'] = 'Full (0 spots left)';
          } else {
            copy['spots'] = '$remaining spot${remaining == 1 ? '' : 's'} left';
          }
          copy['userStatus'] = 'Joined';
          return copy;
        }
        return m;
      }),
    );
    openMatches.value = updatedMatches;

    final updatedGames = List<Map<String, dynamic>>.from(
      myGames.value.map((g) {
        if (g['id'] == matchId) {
          final copy = Map<String, dynamic>.from(g);
          copy['status'] = 'Joined';
          return copy;
        }
        return g;
      }),
    );
    myGames.value = updatedGames;
  }

  static void startGame(String gameId) {
    final updatedGames = List<Map<String, dynamic>>.from(
      myGames.value.map((g) {
        if (g['id'] == gameId) {
          final copy = Map<String, dynamic>.from(g);
          copy['status'] = 'Ongoing';
          return copy;
        }
        return g;
      }),
    );
    myGames.value = updatedGames;
  }
}

abstract final class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.navy,
      error: Color(0xFFE53935),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundBottom,
      fontFamily: 'Roboto',
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundBottom,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.navy,
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 48,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        height: 64,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            size: 22,
          );
        }),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.fieldBorder),
          minimumSize: const Size(64, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
