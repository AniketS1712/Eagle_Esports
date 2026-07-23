class RoutePath {
  RoutePath._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String accountBanned = '/banned';
  static const String organiserDashboard = '/organiser-dashboard';
  static const String organiserTournaments = '/organiser/tournaments';
  static const String organiserStats = '/organiser/stats';
  static const String organiserProfile = '/organiser/profile';
  static const String createTournament = '/organiser-dashboard/create';
  static const String home = '/home';
  static const String tournamentDetails = '/tournaments/:id';
  static const String userLeaderboard = '/leaderboard/:tournamentId';
  static const String room = '/tournaments/:id/room';
  static const String createRoom = '/tournaments/:id/room/create';
  static const String joinRoom = '/rooms/join';
  static const String teamRoom = '/teams/:id/room';
  static const String userProfile = '/profile';
  static const String organizerTournament =
      '/organiser-dashboard/tournaments/:id';
  static const String previewTournament =
      '/organiser-dashboard/tournaments/:id/preview';
  static const String myTournaments = '/my-tournaments';
  static const wallet = '/wallet';
  static const String addMoney = '/wallet/add-money';
  static const String organiserLeaderboard =
      '/organiser-dashboard/tournaments/:id/leaderboard';
  static const String editProfile = '/profile/edit';
  static const String registeredTeams =
      '/organiser/tournaments/:tournamentId/teams';
  static const String merch = '/merch';
  static const String merchItemDetail = '/merch/:id';
  static const String orderConfirmation = '/merch/orders/:orderId';
  static const String myOrders = '/merch/orders';
}
