# Eagle Esport — Project Status

> Last updated: 2026-07-23

## App Overview

- **Platform:** Flutter mobile (Android / iOS)
- **State management:** Riverpod (`flutter_riverpod`)
- **Navigation:** go_router
- **Backend/DB:** Supabase (PostgreSQL + Auth + Realtime)
- **Secondary backend:** Node.js (Express) — payments only
- **Image hosting:** Cloudinary
- **In-game currency:** Talon (1T = ₹1)
- **Fonts:** Orbitron (display), Manrope (body)

---

## Flutter Dependencies

```
- flutter: sdk
- http: ^1.6.0
- intl: ^0.20.3
- go_router: ^17.3.0
- flutter_riverpod: ^3.3.2
- supabase_flutter: ^2.14.2
- razorpay_flutter: ^1.4.5
- image_picker: ^1.2.2
- cupertino_icons: ^1.0.8
```

---

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── routes/
│   │   ├── app_routes.dart
│   │   ├── route_names.dart
│   │   ├── route_path.dart
│   │   └── router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_decorations.dart
│       ├── app_dimensions.dart
│       ├── app_radius.dart
│       ├── app_spacing.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       ├── app_typography.dart
│       ├── theme.dart                (barrel export)
│       └── widgets/
│           ├── app_background.dart
│           ├── app_badge.dart
│           ├── app_button.dart
│           ├── app_card.dart
│           ├── app_chip.dart
│           ├── app_progress_bar.dart
│           └── app_text_field.dart
├── models/                            (14 model files)
├── shared/
│   ├── services/
│   │   ├── cloudinary_service.dart
│   │   └── payment_service.dart
│   └── widgets/
│       ├── app_top_bar.dart
│       ├── eagle_logo.dart
│       ├── loader.dart
│       ├── organiser_scaffold_with_nav_bar.dart
│       ├── scaffold_with_nav_bar.dart
│       └── user_app_bar.dart
└── feature/
    ├── auth/          [done]
    ├── home/          [done]
    ├── leaderboard/   [done]
    ├── my_tournaments/[done]
    ├── organiser_dashboard/ [done]
    ├── organiser_tournaments/ [done]
    ├── profile/       [partial]
    ├── splash/        [done]
    ├── stats/         [done]
    ├── team/          [done]
    ├── tournament/    [done]
    └── wallet/        [done]
```

---

## Routes

| Route Name | Path | Screen | Status |
|---|---|---|---|
| splash | `/` | SplashScreen | [done] |
| login | `/login` | LoginScreen | [done] |
| signup | `/signup` | SignupScreen | [done] |
| otp | `/otp` | OtpScreen | [done] |
| forgotPassword | `/forgot-password` | ForgotPasswordScreen | [done] |
| accountBanned | `/banned` | AccountBannedScreen | [done] |
| home | `/home` | HomeScreen (tab) | [done] |
| myTournaments | `/my-tournaments` | MyTournamentsScreen (tab) | [done] |
| wallet | `/wallet` | WalletScreen (tab) | [done] |
| userProfile | `/profile` | UserProfileScreen (tab) | [partial] |
| addMoney | `/wallet/add-money` | AddMoneyScreen | [done] |
| tournamentDetails | `/tournaments/:id` | TournamentDetailsScreen | [done] |
| userLeaderboard | `/leaderboard/:tournamentId` | UserLeaderboardScreen | [done] |
| room | `/tournaments/:id/room` | RoomScreen | [done] |
| createRoom | `/tournaments/:id/room/create` | CreateRoomScreen | [done] |
| joinRoom | `/rooms/join` | JoinRoomScreen | [done] |
| teamRoom | `/teams/:id/room` | TeamRoomScreen | [done] |
| organiserDashboard | `/organiser-dashboard` | OrganiserDashboardScreen (tab) | [done] |
| organiserTournaments | `/organiser/tournaments` | OrganiserTournamentsScreen (tab) | [done] |
| organiserStats | `/organiser/stats` | OrganiserStatsScreen (tab) | [done] |
| organiserProfile | `/organiser/profile` | OrganiserProfileScreen (tab) | [partial] |
| createTournament | `/organiser-dashboard/create` | CreateTournamentScreen | [done] |
| organizerTournament | `/organiser-dashboard/tournaments/:id` | OrganizerTournamentScreen | [done] |
| previewTournament | `/organiser-dashboard/tournaments/:id/preview` | PreviewTournamentScreen | [done] |
| organiserLeaderboard | `/organiser-dashboard/tournaments/:id/leaderboard` | OrganiserLeaderboardScreen | [done] |

---

## Models

- LeaderboardEntry (`leaderboard_entry.dart`)
- MatchResult (`match_result.dart`)
- MerchItem (`merch_item.dart`)
- MerchOrder (`merch_order.dart`)
- Notification (`notification.dart`)
- Profile (`profile.dart`)
- Team (`team.dart`)
- TeamMember (`team_member.dart`)
- TopupOption (`topup_option.dart`)
- Tournament (`tournament.dart`)
- TournamentMatch (`tournament_match.dart`)
- TournamentRoom (`tournament_room.dart`)
- Wallet (`wallet.dart`)
- WalletTransaction (`wallet_transaction.dart`)

---

## Theme & Core

### lib/core/theme/

| File | Purpose |
|---|---|
| app_colors.dart | Colour palette (primary, surface, accent, etc.) |
| app_decorations.dart | Reusable BoxDecoration presets |
| app_dimensions.dart | Size constants (icon, avatar, card, etc.) |
| app_radius.dart | BorderRadius presets |
| app_spacing.dart | Padding / margin constants |
| app_text_styles.dart | TextStyle presets using Orbitron + Manrope |
| app_theme.dart | ThemeData builder |
| app_typography.dart | Typography scale |
| theme.dart | Barrel export file |

### lib/core/theme/widgets/

| File | Purpose |
|---|---|
| app_background.dart | Gradient/dark background wrapper |
| app_badge.dart | Status badge widget |
| app_button.dart | Primary/secondary button variants |
| app_card.dart | Styled card container |
| app_chip.dart | Chip / tag widget |
| app_progress_bar.dart | Animated progress bar |
| app_text_field.dart | Themed text input field |

---

## Shared Widgets & Services

### lib/shared/widgets/

| File | Purpose |
|---|---|
| app_top_bar.dart | Common top app bar |
| eagle_logo.dart | Animated Eagle logo widget |
| loader.dart | Loading spinner |
| organiser_scaffold_with_nav_bar.dart | Organiser bottom-nav shell |
| scaffold_with_nav_bar.dart | User bottom-nav shell |
| user_app_bar.dart | User-specific app bar |

### lib/shared/services/

| File | Purpose |
|---|---|
| cloudinary_service.dart | Image upload to Cloudinary |
| payment_service.dart | HTTP client to Node.js `/create-order` endpoint (ngrok dev URL) |

---

## Feature Inventory

### auth/
- **data/**: auth_repository.dart
- **providers/**: auth_notifier.dart, auth_providers.dart
- **screens/**: login_screen.dart, signup_screen.dart, otp_screen.dart, forgot_password_screen.dart, account_banned_screen.dart
- **widgets/**: none

---

### home/
- **data/**: empty (uses tournament data layer)
- **providers/**: none
- **screens/**: home_screen.dart
- **widgets/**: tournament_filter_bar.dart, tournament_list.dart, tournament_list_item.dart

---

### leaderboard/
- **data/**: leaderboard_repository.dart
- **providers/**: leaderboard_providers.dart
- **screens/**: user_leaderboard_screen.dart, organiser_leaderboard_screen.dart
- **widgets/**: leaderboard_preview.dart, leaderboard_rank_row.dart, match_result_form.dart, match_tab_bar.dart

---

### my_tournaments/
- **data/**: my_tournaments_repository.dart
- **providers/**: my_tournaments_providers.dart
- **screens/**: my_tournaments_screen.dart
- **widgets/**: active_tournament_card.dart, completed_tournament_card.dart, tournament_result_sheet.dart

---

### organiser_dashboard/
- **data/**: none (shares tournament data layer)
- **providers/**: none
- **screens/**: organiser_dashboard_screen.dart, create_tournament_screen.dart, organizer_tournament_screen.dart, preview_tournament_screen.dart
- **widgets/**: create_tournament_button.dart, create_tournament_submit_button.dart, dashboard_header.dart, dashboard_stats_row.dart, organizer_tournament_actions.dart, organizer_tournament_header.dart, organizer_tournament_room_form.dart, organizer_tournament_stats.dart, preview_tournament_actions.dart, preview_tournament_banner.dart, preview_tournament_summary.dart, recent_tournaments_list.dart, tournament_form_basic_fields.dart, tournament_form_mode_selector.dart, tournament_form_numeric_fields.dart, tournament_form_prize_fields.dart, tournament_form_schedule_fields.dart

---

### organiser_tournaments/
- **data/**: none (shares tournament data layer)
- **providers/**: none
- **screens/**: organiser_tournaments_screen.dart
- **widgets/**: organiser_tournament_filter_bar.dart, organiser_tournament_list.dart

---

### profile/
- **data/**: none
- **providers/**: none
- **screens/**: user_profile_screen.dart, organiser_profile_screen.dart
- **widgets/**: user_profile_header.dart, user_profile_menu.dart, user_profile_stats_row.dart

---

### splash/
- **screens/**: splash_screen.dart (at feature root, not in presentation/)
- **widget/**: corner_hud.dart, form_field_section.dart

---

### stats/
- **data/**: none
- **providers/**: none
- **screens/**: organiser_stats_screen.dart
- **widgets/**: stats_overview_row.dart, tournament_stat_card.dart, tournament_stats_list.dart

---

### team/
- **data/**: team_repository.dart
- **providers/**: team_providers.dart
- **screens/**: room_screen.dart, create_room_screen.dart, join_room_screen.dart, team_room_screen.dart
- **widgets/**: create_room_form.dart, join_room_form.dart, team_invite_code_card.dart, team_members_list.dart, team_room_actions.dart, team_room_credentials_card.dart, team_room_empty_slot_card.dart, team_room_header.dart, team_room_invite_card.dart, team_room_join_code_card.dart, team_room_member_card.dart, team_room_members_grid.dart

---

### tournament/
- **data/**: tournament_repository.dart
- **providers/**: tournament_providers.dart
- **screens/**: tournament_details_screen.dart
- **widgets/**: tournament_details_banner_image.dart, tournament_details_entry_fee_card.dart, tournament_details_header.dart, tournament_details_info_card.dart, tournament_details_locked_room_card.dart, tournament_details_requirements_card.dart, tournament_details_rules_card.dart, tournament_details_schedule_card.dart, tournament_details_sidebar.dart, tournament_details_stat_tile.dart, tournament_details_stats_grid.dart, tournament_details_sticky_cta.dart

---

### wallet/
- **data/**: wallet_repository.dart
- **providers/**: wallet_providers.dart
- **screens/**: wallet_screen.dart, add_money_screen.dart, transaction_details_screen.dart
- **widgets/**: wallet_balance_card.dart, transaction_list_item.dart

---

## Supabase

- **Migration file:** `supabase/migrations/` directory exists but is **empty** (no .sql files found in project)
- **Tables** (based on models and repository code):
  - profiles
  - wallets
  - wallet_transactions
  - topup_options
  - tournaments
  - tournament_rooms
  - teams
  - team_members
  - tournament_matches
  - match_results
  - leaderboard
  - merch_items
  - merch_orders
- **RPC functions** (referenced in repositories):
  - start_tournament
  - cancel_tournament
  - complete_tournament
  - pay_tournament_entry
  - credit_wallet
  - debit_wallet

---

## Node.js Backend

- **Location:** `eagle_esports_backend/` (sibling of the Flutter project root)
- **Entry point:** `index.js`
- **Files found:**

| Path | Description |
|---|---|
| `index.js` | Express server entry point |
| `src/routes/create_order.js` | Razorpay order creation route |
| `src/routes/verify_payment.js` | Razorpay webhook verification route |
| `src/lib/razorpay.js` | Razorpay SDK initialiser |
| `src/lib/supabase_admin.js` | Supabase admin client |
| `src/lib/validate_env.js` | Environment variable validator |
| `test_db.js` | DB connection test script |
| `test_rzp.js` | Razorpay test script |
| `.env` | Environment variables (local) |

- **Endpoints:**
  - `POST /create-order` — creates a Razorpay order
  - `POST /verify-payment` — webhook to verify payment & credit wallet
  - `GET /health` — [unconfirmed — likely present in index.js]

---

## Known Stubs / TODOs

| File | TODO |
|---|---|
| `feature/team/data/team_repository.dart` | Replace with `pay_tournament_entry` RPC when wallet is built |
| `feature/profile/presentation/widgets/user_profile_stats_row.dart` | Wire to provider once `profile_stats_providers.dart` exists |
| `feature/tournament/presentation/widgets/tournament_details_requirements_card.dart` | Wire eligibility data once tournament requirements providers exist |
| `feature/profile/presentation/screens/user_profile_screen.dart` | Navigate to wallet screen once route exists |
| `feature/profile/presentation/screens/user_profile_screen.dart` | Navigate to notifications screen once route exists |
| `feature/profile/presentation/screens/user_profile_screen.dart` | Navigate to settings screen once route exists (×2) |

---

## What's Left to Build

### User side

- [x] Home screen (tournament listing with filter bar)
- [x] Tournament Details screen
- [x] My Tournaments screen (active + completed tabs)
- [x] Wallet screen (balance + transaction history)
- [x] Add Money screen (Razorpay checkout flow)
- [x] Transaction Details screen
- [x] User Leaderboard screen
- [ ] User Profile screen (full content — currently partial, stats row is stubbed)
- [ ] Edit Profile screen
- [ ] Settings screen
- [ ] Notifications screen
- [ ] Merch Store screen (model exists, no feature folder)
- [ ] Merch Item Details screen (model exists, no feature folder)
- [ ] My Orders screen (model exists, no feature folder)

### Organiser side

- [x] Organiser Dashboard screen
- [x] Create Tournament screen (full form with all fields)
- [x] Organiser Tournament management screen
- [x] Preview Tournament screen
- [x] Organiser Leaderboard screen (match result entry)
- [x] Organiser Tournaments list screen
- [x] Organiser Stats screen
- [ ] Organiser Profile screen (full content — currently partial, read-only)
- [ ] Edit Profile screen (organiser)
- [ ] Registered Teams screen (per-tournament)
- [ ] Settings screen (organiser)
- [ ] Notifications screen (organiser)

### Shared

- [ ] Settings screen (shared or per-role)
- [ ] Notifications screen (shared or per-role — model exists, no feature folder)

### Payment

- [x] Node.js backend code (create-order + verify-payment)
- [x] PaymentService HTTP client in Flutter
- [x] razorpay_flutter dependency added
- [ ] Real Razorpay integration (currently pointing to ngrok dev URL)
- [ ] Node.js backend deployed to production (Railway / Render)

### Data layer gaps

- [ ] Profile stats provider (`profile_stats_providers.dart` — referenced in TODO)
- [ ] Tournament requirements / eligibility provider
- [ ] Merch feature (data + presentation — models exist but no feature folder)
- [ ] Notifications feature (model exists but no feature folder)
