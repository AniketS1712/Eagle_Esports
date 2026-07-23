import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String otp = 'otp';
  static const String forgotPassword = 'forgot_password';
  static const String accountBanned = 'account_banned';
  static const String organiserDashboard = 'organiser_dashboard';
  static const String organiserTournaments = 'organiser_tournaments';
  static const String organiserStats = 'organiser_stats';
  static const String organiserProfile = 'organiser_profile';
  static const String createTournament = 'create_tournament';
  static const String home = 'home';
  static const String tournamentDetails = 'tournament_details';
  static const String userLeaderboard = 'user_leaderboard';
  static const String room = 'room';
  static const String createRoom = 'create_room';
  static const String joinRoom = 'join_room';
  static const String teamRoom = 'team_room';
  static const String userProfile = 'user_profile';
  static const String organizerTournament = 'organizer_tournament';
  static const String previewTournament = 'preview_tournament';
  static const String myTournaments = 'my_tournaments';
  static const String wallet = 'wallet';
  static const String addMoney = 'add_money';
  static const String organiserLeaderboard = 'organiser_leaderboard';
  static const String editProfile = 'edit_profile';
  static const String registeredTeams = 'registered_teams';
  static const String merch = 'merch';
  static const String merchItemDetail = 'merch_item_detail';
  static const String orderConfirmation = 'order_confirmation';
  static const String myOrders = 'my_orders';
}

extension RouteNamesNavigation on BuildContext {
  void goNames(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void pushNames(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
