import 'package:eagle_esports/feature/home/presentation/screens/home_screen.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/screens/organiser_leaderboard_screen.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/screens/user_leaderboard_screen.dart';
import 'package:eagle_esports/feature/merch/presentation/screens/merch_store_screen.dart';
import 'package:eagle_esports/feature/merch/presentation/screens/merch_item_detail_screen.dart';
import 'package:eagle_esports/feature/merch/presentation/screens/order_confirmation_screen.dart';
import 'package:eagle_esports/feature/merch/presentation/screens/my_orders_screen.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/screens/my_tournaments_screen.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/screens/create_tournament_screen.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/screens/organiser_dashboard_screen.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/screens/organizer_tournament_screen.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/screens/preview_tournament_screen.dart';
import 'package:eagle_esports/feature/wallet/presentation/screens/add_money_screen.dart';
import 'package:eagle_esports/feature/wallet/presentation/screens/wallet_screen.dart';
import 'package:eagle_esports/feature/organiser_tournaments/presentation/screens/organiser_tournaments_screen.dart';
import 'package:eagle_esports/feature/stats/presentation/screens/organiser_stats_screen.dart';
import 'package:eagle_esports/feature/profile/presentation/screens/edit_profile_screen.dart';
import 'package:eagle_esports/feature/profile/presentation/screens/organiser_profile_screen.dart';
import 'package:eagle_esports/feature/profile/presentation/screens/user_profile_screen.dart';
import 'package:eagle_esports/feature/team/presentation/screens/create_room_screen.dart';
import 'package:eagle_esports/feature/team/presentation/screens/join_room_screen.dart';
import 'package:eagle_esports/feature/team/presentation/screens/room_screen.dart';
import 'package:eagle_esports/feature/team/presentation/screens/registered_teams_screen.dart';
import 'package:eagle_esports/feature/team/presentation/screens/team_room_screen.dart';
import 'package:eagle_esports/feature/tournament/presentation/screens/tournament_details_screen.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/organiser_scaffold_with_nav_bar.dart';
import 'package:eagle_esports/shared/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/routes/route_path.dart';
import 'package:eagle_esports/feature/splash/splash_screen.dart';
import 'package:eagle_esports/feature/auth/presentation/screens/login_screen.dart';
import 'package:eagle_esports/feature/auth/presentation/screens/signup_screen.dart';
import 'package:eagle_esports/feature/auth/presentation/screens/account_banned_screen.dart';

import 'package:eagle_esports/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:eagle_esports/feature/auth/presentation/screens/otp_screen.dart';

final List<RouteBase> appRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ScaffoldWithNavBar(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.myTournaments,
            name: RouteNames.myTournaments,
            builder: (context, state) => const MyTournamentsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.wallet,
            name: RouteNames.wallet,
            builder: (context, state) => const WalletScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.merch,
            name: RouteNames.merch,
            builder: (context, state) => const MerchStoreScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.userProfile,
            name: RouteNames.userProfile,
            builder: (context, state) => const UserProfileScreen(),
          ),
        ],
      ),
    ],
  ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return OrganiserScaffoldWithNavBar(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.organiserDashboard,
            name: RouteNames.organiserDashboard,
            builder: (context, state) => const OrganiserDashboardScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.organiserTournaments,
            name: RouteNames.organiserTournaments,
            builder: (context, state) => const OrganiserTournamentsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.organiserStats,
            name: RouteNames.organiserStats,
            builder: (context, state) => const OrganiserStatsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: RoutePath.organiserProfile,
            name: RouteNames.organiserProfile,
            builder: (context, state) => const OrganiserProfileScreen(),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    name: RouteNames.splash,
    path: RoutePath.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: RouteNames.login,
    path: RoutePath.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RouteNames.signup,
    path: RoutePath.signup,
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    name: RouteNames.otp,
    path: RoutePath.otp,
    builder: (context, state) {
      final email = state.uri.queryParameters['email'] ?? '';
      return OtpScreen(email: email);
    },
  ),
  GoRoute(
    name: RouteNames.forgotPassword,
    path: RoutePath.forgotPassword,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    name: RouteNames.accountBanned,
    path: RoutePath.accountBanned,
    builder: (context, state) => const AccountBannedScreen(),
  ),
  GoRoute(
    name: RouteNames.createTournament,
    path: RoutePath.createTournament,
    builder: (context, state) => const CreateTournamentScreen(),
  ),
  GoRoute(
    name: RouteNames.tournamentDetails,
    path: RoutePath.tournamentDetails,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      final extra = state.extra;
      final isJoined = extra is Map
          ? (extra['isJoined'] as bool? ?? false)
          : false;
      return TournamentDetailsScreen(tournamentId: id, isJoined: isJoined);
    },
  ),
  GoRoute(
    name: RouteNames.userLeaderboard,
    path: RoutePath.userLeaderboard,
    builder: (context, state) {
      final tournamentId = state.pathParameters['tournamentId'] ?? '';
      final title = state.extra as String? ?? '';
      return UserLeaderboardScreen(
        tournamentId: tournamentId,
        tournamentTitle: title,
      );
    },
  ),
  GoRoute(
    name: RouteNames.room,
    path: RoutePath.room,
    builder: (context, state) {
      final extra = state.extra;
      return RoomScreen(tournament: extra is Tournament ? extra : null);
    },
  ),
  GoRoute(
    name: RouteNames.createRoom,
    path: RoutePath.createRoom,
    builder: (context, state) {
      final extra = state.extra;
      if (extra is! Tournament) {
        return const Text('Tournament data missing');
      }

      return CreateRoomScreen(tournament: extra);
    },
  ),
  GoRoute(
    name: RouteNames.joinRoom,
    path: RoutePath.joinRoom,
    builder: (context, state) {
      final extra = state.extra;
      return JoinRoomScreen(tournament: extra is Tournament ? extra : null);
    },
  ),
  GoRoute(
    name: RouteNames.teamRoom,
    path: RoutePath.teamRoom,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return TeamRoomScreen(teamId: id);
    },
  ),
  GoRoute(
    name: RouteNames.organizerTournament,
    path: RoutePath.organizerTournament,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return OrganizerTournamentScreen(tournamentId: id);
    },
  ),
  GoRoute(
    name: RouteNames.previewTournament,
    path: RoutePath.previewTournament,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      final extra = state.extra;
      return PreviewTournamentScreen(
        tournamentId: id,
        initialTournament: extra is Tournament ? extra : null,
      );
    },
  ),
  GoRoute(
    name: RouteNames.organiserLeaderboard,
    path: RoutePath.organiserLeaderboard,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return OrganiserLeaderboardScreen(tournamentId: id);
    },
  ),
  GoRoute(
    name: RouteNames.addMoney,
    path: RoutePath.addMoney,
    builder: (context, state) => const AddMoneyScreen(),
  ),
  GoRoute(
    name: RouteNames.editProfile,
    path: RoutePath.editProfile,
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    name: RouteNames.registeredTeams,
    path: RoutePath.registeredTeams,
    builder: (context, state) {
      final tournamentId = state.pathParameters['tournamentId'] ?? '';
      return RegisteredTeamsScreen(tournamentId: tournamentId);
    },
  ),
  GoRoute(
    name: RouteNames.merchItemDetail,
    path: RoutePath.merchItemDetail,
    builder: (context, state) {
      final id = state.pathParameters['id'] ?? '';
      return MerchItemDetailScreen(itemId: id);
    },
  ),
  GoRoute(
    name: RouteNames.orderConfirmation,
    path: RoutePath.orderConfirmation,
    builder: (context, state) {
      final orderId = state.pathParameters['orderId'] ?? '';
      return OrderConfirmationScreen(orderId: orderId);
    },
  ),
  GoRoute(
    name: RouteNames.myOrders,
    path: RoutePath.myOrders,
    builder: (context, state) => const MyOrdersScreen(),
  ),
];
