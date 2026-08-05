# Eagle Esport — Project Audit

> Generated: 2026-08-04
> This document captures the current state of every feature, screen, provider, repository, and known issue in the codebase.

---

## Section 1: Project Overview

| Property | Value |
|---|---|
| App name | Eagle Esport |
| Platform | Android (iOS not started) |
| State management | Riverpod (flutter_riverpod 3.3.2) |
| Navigation | go_router 17.3.0 |
| Backend | Supabase (DB + Auth + Realtime) + Node.js on Render |
| Flutter SDK | ^3.11.4 |
| App version | 1.0.0+1 |
| Total Dart files in lib/ | 176 |
| Package name | com.example.eagle_esports (**must change before release**) |

---

## Section 2: Dependencies

### Runtime Dependencies

| Package | Version | Purpose |
|---|---|---|
| flutter | sdk | Framework |
| http | ^1.6.0 | HTTP requests to Node.js backend |
| intl | ^0.20.3 | Date/number formatting |
| go_router | ^17.3.0 | Declarative routing with StatefulShellRoute |
| flutter_riverpod | ^3.3.2 | State management & dependency injection |
| supabase_flutter | ^2.14.2 | Supabase client (auth, DB, realtime, RPC) |
| razorpay_flutter | ^1.4.5 | Razorpay payment gateway integration |
| image_picker | ^1.2.2 | Camera/gallery image selection for avatar uploads |
| cupertino_icons | ^1.0.8 | iOS-style icons |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| flutter_test | sdk | Testing framework |
| flutter_lints | ^6.0.0 | Lint rules |
| flutter_launcher_icons | ^0.14.4 | App icon generation |

### Custom Fonts

- **Orbitron** (500, 600, 700) — headings, labels, numbers
- **Manrope** (400, 500, 600, 700) — body text, captions

---

## Section 3: Routes Inventory

| Route Name | Path | Notes |
|---|---|---|
| `splash` | `/` | Initial route, animated logo, redirects based on auth |
| `login` | `/login` | Email + password sign-in |
| `signup` | `/signup` | Registration form |
| `otp` | `/otp` | OTP verification after signup |
| `forgotPassword` | `/forgot-password` | Password reset via email |
| `accountBanned` | `/banned` | Shown when profile.is_banned = true |
| `home` | `/home` | User tab root — tournament list |
| `myTournaments` | `/my-tournaments` | User tab root — active & completed |
| `wallet` | `/wallet` | User tab root — balance + history |
| `merch` | `/merch` | User tab root — merch store |
| `userProfile` | `/profile` | User tab root — profile |
| `tournamentDetails` | `/tournaments/:id` | Tournament detail screen |
| `userLeaderboard` | `/leaderboard/:tournamentId` | Read-only leaderboard for users |
| `room` | `/tournaments/:id/room` | Create or join room |
| `createRoom` | `/tournaments/:id/room/create` | Create room form |
| `joinRoom` | `/rooms/join` | Join room via code |
| `teamRoom` | `/teams/:id/room` | Team room details after joining |
| `addMoney` | `/wallet/add-money` | Razorpay top-up screen |
| `editProfile` | `/profile/edit` | Edit name, phone, avatar |
| `merchItemDetail` | `/merch/:id` | Merch item detail + purchase |
| `orderConfirmation` | `/merch/orders/:orderId` | Post-purchase confirmation |
| `myOrders` | `/merch/orders` | Order history |
| `organiserDashboard` | `/organiser-dashboard` | Organiser tab root — dashboard |
| `organiserTournaments` | `/organiser/tournaments` | Organiser tab root — tournament list |
| `organiserStats` | `/organiser/stats` | Organiser tab root — stats |
| `organiserProfile` | `/organiser/profile` | Organiser tab root — profile |
| `createTournament` | `/organiser-dashboard/create` | Tournament creation form |
| `organizerTournament` | `/organiser-dashboard/tournaments/:id` | Organiser tournament management |
| `previewTournament` | `/organiser-dashboard/tournaments/:id/preview` | Preview before publishing |
| `organiserLeaderboard` | `/organiser-dashboard/tournaments/:id/leaderboard` | Organiser leaderboard entry |
| `registeredTeams` | `/organiser/tournaments/:tournamentId/teams` | View registered teams list |

---

## Section 4: Feature Inventory

### auth

| Layer | Files | Status |
|---|---|---|
| data | auth_repository.dart | [exists] |
| providers | auth_providers.dart, auth_notifier.dart | [exists] |
| screens | login_screen.dart, signup_screen.dart, otp_screen.dart, forgot_password_screen.dart, account_banned_screen.dart | [exists] |
| widgets | signup_form_fields.dart, signup_submit_button.dart | [exists] |

---

### home

| Layer | Files | Status |
|---|---|---|
| data | — | [empty] |
| providers | — | [empty] (uses tournament_providers) |
| screens | home_screen.dart | [exists] |
| widgets | tournament_list.dart, tournament_filter_bar.dart, tournament_list_item.dart | [exists] |

---

### tournament

| Layer | Files | Status |
|---|---|---|
| data | tournament_repository.dart | [exists] |
| providers | tournament_providers.dart | [exists] |
| screens | tournament_details_screen.dart | [exists] |
| widgets | tournament_details_banner_image.dart, tournament_details_entry_fee_card.dart, tournament_details_header.dart, tournament_details_info_card.dart, tournament_details_locked_room_card.dart, tournament_details_requirements_card.dart, tournament_details_rules_card.dart, tournament_details_schedule_card.dart, tournament_details_sidebar.dart, tournament_details_stat_tile.dart, tournament_details_stats_grid.dart, tournament_details_sticky_cta.dart | [exists] |

---

### team

| Layer | Files | Status |
|---|---|---|
| data | team_repository.dart | [exists] |
| providers | team_providers.dart | [exists] |
| screens | room_screen.dart, create_room_screen.dart, join_room_screen.dart, team_room_screen.dart, registered_teams_screen.dart | [exists] |
| widgets | team_card.dart, team_members_sheet.dart, create_room_form.dart, join_room_form.dart, team_invite_code_card.dart, team_members_list.dart, team_room_actions.dart, team_room_credentials_card.dart, team_room_empty_slot_card.dart, team_room_header.dart, team_room_invite_card.dart, team_room_join_code_card.dart, team_room_member_card.dart, team_room_members_grid.dart | [exists] |

---

### leaderboard

| Layer | Files | Status |
|---|---|---|
| data | leaderboard_repository.dart | [exists] |
| providers | leaderboard_providers.dart | [exists] |
| screens | organiser_leaderboard_screen.dart, user_leaderboard_screen.dart | [exists] |
| widgets | leaderboard_preview.dart, leaderboard_rank_row.dart, match_result_form.dart, match_tab_bar.dart | [exists] |

---

### wallet

| Layer | Files | Status |
|---|---|---|
| data | wallet_repository.dart | [exists] |
| providers | wallet_providers.dart | [exists] |
| screens | wallet_screen.dart, add_money_screen.dart, transaction_details_screen.dart | [exists] |
| widgets | topup_option_tile.dart, topup_summary_card.dart, transaction_list_item.dart, wallet_balance_card.dart | [exists] |

---

### my_tournaments

| Layer | Files | Status |
|---|---|---|
| data | my_tournaments_repository.dart | [exists] |
| providers | my_tournaments_providers.dart | [exists] |
| screens | my_tournaments_screen.dart | [exists] |
| widgets | active_tournament_card.dart, completed_tournament_card.dart, tournament_result_sheet.dart | [exists] |

---

### profile

| Layer | Files | Status |
|---|---|---|
| data | profile_repository.dart | [exists] |
| providers | profile_providers.dart | [exists] |
| screens | user_profile_screen.dart, organiser_profile_screen.dart, edit_profile_screen.dart | [exists] |
| widgets | avatar_picker.dart, user_profile_header.dart, user_profile_menu.dart, user_profile_stats_row.dart | [exists] |

---

### organiser_dashboard

| Layer | Files | Status |
|---|---|---|
| data | — | [empty] (uses tournament_providers) |
| providers | — | [empty] (uses tournament_providers) |
| screens | organiser_dashboard_screen.dart, create_tournament_screen.dart, organizer_tournament_screen.dart, preview_tournament_screen.dart | [exists] |
| widgets | create_tournament_button.dart, create_tournament_submit_button.dart, dashboard_header.dart, dashboard_stats_row.dart, organizer_tournament_actions.dart, organizer_tournament_header.dart, organizer_tournament_room_form.dart, organizer_tournament_stats.dart, preview_tournament_actions.dart, preview_tournament_banner.dart, preview_tournament_summary.dart, recent_tournaments_list.dart, tournament_form_basic_fields.dart, tournament_form_mode_selector.dart, tournament_form_numeric_fields.dart, tournament_form_prize_fields.dart, tournament_form_schedule_fields.dart | [exists] |

---

### organiser_tournaments

| Layer | Files | Status |
|---|---|---|
| data | — | [empty] |
| providers | — | [empty] |
| screens | organiser_tournaments_screen.dart | [exists] |
| widgets | organiser_tournament_filter_bar.dart, organiser_tournament_list.dart | [exists] |

---

### merch

| Layer | Files | Status |
|---|---|---|
| data | merch_repository.dart | [exists] |
| providers | merch_providers.dart | [exists] |
| screens | merch_store_screen.dart, merch_item_detail_screen.dart, my_orders_screen.dart, order_confirmation_screen.dart | [exists] |
| widgets | merch_category_bar.dart, merch_image_carousel.dart, merch_item_card.dart | [exists] |

---

### stats

| Layer | Files | Status |
|---|---|---|
| data | — | [empty] |
| providers | — | [empty] |
| screens | organiser_stats_screen.dart | [exists] |
| widgets | stats_overview_row.dart, tournament_stat_card.dart, tournament_stats_list.dart | [exists] |

---

### splash

| Layer | Files | Status |
|---|---|---|
| data | — | [empty] |
| providers | — | [empty] |
| screens | splash_screen.dart | [exists] |
| widgets | corner_hud.dart, form_field_section.dart | [exists] |

---

### notification

**[not found]** — No `lib/feature/notification/` directory exists. The model (`lib/models/notification.dart`) is defined but no feature folder, screens, providers, or repository have been created.

---

### settings

**[not found]** — No `lib/feature/settings/` directory exists.

---

## Section 5: Shared Code

### lib/shared/services/

| File | Description |
|---|---|
| payment_service.dart | HTTP calls to Node.js backend for create-order and confirm-payment; falls back to Supabase RPC |
| cloudinary_service.dart | Unsigned image upload to Cloudinary for avatar/banner images |

### lib/shared/widgets/

| File | Description |
|---|---|
| scaffold_with_nav_bar.dart | User-role StatefulShellRoute scaffold with 5-tab BottomNavigationBar |
| organiser_scaffold_with_nav_bar.dart | Organiser-role StatefulShellRoute scaffold with 4-tab BottomNavigationBar |
| user_app_bar.dart | Branded top bar showing "EAGLE ESPORTS" + wallet balance pill |
| app_top_bar.dart | Reusable top bar with back button and optional trailing widget |
| eagle_logo.dart | Animated Eagle logo widget used in splash screen |
| loader.dart | Segmented loading animation |

### lib/models/

| File | Description |
|---|---|
| profile.dart | User profile model (id, fullName, avatarUrl, phone, role, isBanned) |
| tournament.dart | Tournament model with GameMode and TournamentStatus enums |
| team.dart | Team model with TeamPaymentStatus enum |
| team_member.dart | Junction table model for team ↔ user relationship |
| wallet.dart | Wallet model (talonBalance, userId) |
| wallet_transaction.dart | Immutable audit log model with WalletTxType, WalletTxCategory, WalletTxStatus |
| topup_option.dart | Admin-managed top-up tier model |
| tournament_match.dart | Per-round match model (matchNumber) |
| tournament_room.dart | Room credentials model (roomId, roomPassword, revealedAt) |
| match_result.dart | Per-team per-match score model (placement, kills) |
| leaderboard_entry.dart | Final aggregated standings model (totalKills, totalPoints, rank, prizeAwarded) |
| notification.dart | Notification model with NotificationType enum — **model only, no feature built** |
| merch_item.dart | Merch catalog item model with MerchCategory enum |
| merch_order.dart | Merch order model with MerchOrderStatus enum |

### lib/core/theme/

| File | Description |
|---|---|
| theme.dart | Barrel export for all theme tokens and widgets |
| app_colors.dart | Color tokens — HUD/glassmorphism palette, status colors, gradients |
| app_text_styles.dart | Text style tokens — Orbitron headings, Manrope body |
| app_spacing.dart | Spacing tokens (4px base unit), screen/card/list padding |
| app_dimensions.dart | Dimension tokens — icon sizes, avatar sizes, input/button heights |
| app_radius.dart | Border radius tokens |
| app_decorations.dart | Shared BoxDecoration helpers |
| app_theme.dart | Material ThemeData configuration |
| app_typography.dart | Font family name constants |

### lib/core/theme/widgets/ (barrel exports)

| File | Exports |
|---|---|
| app_button.dart | → buttons/primary_gradient_button.dart, secondary_outline_button.dart, danger_button.dart, icon_action_button.dart |
| app_card.dart | → cards/glass_card.dart, tournament_card.dart, stat_card.dart |
| app_badge.dart | → badges/status_badge.dart, pro_badge.dart |
| app_text_field.dart | → fields/app_text_field.dart, otp_input_field.dart |
| app_background.dart | Full-screen themed background with grid texture + atmospheric glow |
| app_chip.dart | Chip widget |
| app_progress_bar.dart | Progress bar widget |

### lib/core/routes/

| File | Description |
|---|---|
| router.dart | GoRouter configuration with auth/profile redirect logic |
| app_routes.dart | All route definitions (302 lines) |
| route_names.dart | String constants for named routes |
| route_path.dart | String constants for route paths |

---

## Section 6: Known Issues & TODOs

### Confirmed Stubs

- **lib/feature/team/data/team_repository.dart** — `markTeamPaid` catches RPC failure and falls back to a direct `.update({'payment_status': 'paid'})` on the `teams` table, bypassing wallet balance checks and the `pay_tournament_entry` RPC. Needs replacing when wallet is live.

### Confirmed Bugs

- **lib/feature/auth/presentation/providers/auth_providers.dart (line 28)** — `profileProvider` calls `.single()` on the `profiles` query. Throws `StateError` if the profile row doesn't exist yet (e.g. right after signup or if the DB trigger hasn't fired).
- **lib/feature/auth/presentation/screens/login_screen.dart (lines 135–143)** — "FORGOT PASSWORD?" GestureDetector is hardcoded to show a SnackBar ("Security key recovery protocol offline") instead of navigating to the forgot password screen.
- **lib/feature/auth/presentation/screens/otp_screen.dart (line 76)** — Back button calls `context.pushNamed(RouteNames.signup)` instead of `context.pop()`, pushing a duplicate signup screen onto the stack.
- **lib/feature/auth/presentation/screens/forgot_password_screen.dart (lines 45, 73)** — Navigation uses `pushNamed(RouteNames.login)` for both back button and post-reset, creating duplicate stack entries instead of popping.
- **lib/feature/tournament/data/tournament_repository.dart (line 45)** — `watchTournamentById` maps with `Tournament.fromMap(data.first)`. If the stream emits an empty list, `data.first` throws `StateError: No element`.
- **lib/feature/team/data/team_repository.dart (line 73)** — `watchTeam` uses `Team.fromMap(rows.first)` — crashes with `StateError` if the team is deleted while being watched.
- **lib/feature/team/presentation/screens/create_room_screen.dart (line 24)** — `ref.read(authNotifierProvider).value!.user.id` uses forced unwrap `value!` — crashes if user session is null.
- **lib/feature/team/presentation/screens/join_room_screen.dart (line 26)** — Same forced unwrap crash risk as create_room_screen.
- **lib/feature/team/presentation/screens/team_room_screen.dart (lines 29–86)** — `SingleChildScrollView` inside a `Column` without `Expanded`/`Flexible` wrapper — causes unbounded height / RenderFlex overflow.
- **lib/feature/wallet/data/wallet_repository.dart (line 25)** — `watchWallet` uses `Wallet.fromMap(rows.first)` — crashes if user has no wallet row yet.
- **lib/feature/merch/data/merch_repository.dart (line 70)** — `watchOrder` uses `MerchOrder.fromMap(rows.first)` — crashes if order is deleted while being watched.
- **lib/feature/leaderboard/presentation/widgets/match_result_form.dart** — `_prefill()` runs on every rebuild via `existing.whenData(_prefill)`. Should use `ref.listen` to only prefill once.
- **lib/feature/leaderboard/presentation/screens/organiser_leaderboard_screen.dart** — `DefaultTabController` resets to index 0 when a new match is added. Should use a manual `TabController` with `TickerProviderStateMixin`.

### Confirmed TODOs

- User profile stats row shows `—` for tournaments joined count — `userProfileStatsProvider` computes it from active + completed providers which may not be loaded
- Notifications feature not built — model exists (`lib/models/notification.dart`), no feature folder
- Notifications DB triggers not written — nothing writes to the notifications table
- App icon not configured — `flutter_launcher_icons` is in dev_dependencies but icon may still be default
- Native splash screen not configured — `flutter_native_splash` not added to pubspec
- Privacy policy page not live at eagleesport.in/privacy
- Razorpay still on test keys — needs live keys before launch
- Node.js backend on Render free tier — spins down after 15 mins idle
- Package name is `com.example.eagle_esports` — must change before Play Store submission

### Navigation Fixes Applied

The following navigation fixes were applied in a previous session:
- `splash_screen.dart`: `context.pushNamed` → `context.go` (prevents stack buildup)
- All `goNamed` calls replaced with `pushNamed` across the codebase
- `RouteNamesNavigation` extension removed

### Security Concerns

- **lib/shared/services/payment_service.dart (lines 77–86)** — When the Node.js backend is unavailable, `confirmPayment` falls back to calling `credit_wallet` RPC directly from the client. This bypasses Razorpay signature verification and allows unverified wallet credits.
- **lib/shared/services/cloudinary_service.dart (line 13)** — Cloudinary cloud name hardcoded (`daez9rfrd`). While unsigned presets are safe, consider environment variables.
- **lib/shared/services/payment_service.dart (line 7)** — Backend URL hardcoded (`https://eagle-esports-backend.onrender.com`). Should use environment config.

---

## Section 7: Database Schema

### Tables

| Table | Purpose | Key Columns |
|---|---|---|
| `profiles` | User profiles, extends auth.users | id (FK auth.users), full_name, avatar_url, phone, role, is_banned |
| `wallets` | User wallet balances | id, user_id (FK profiles), talon_balance, updated_at |
| `wallet_transactions` | Immutable audit log of all balance changes | id, wallet_id, user_id, type (credit/debit), category, amount, balance_after, reference_id, status |
| `topup_options` | Admin-managed top-up tiers | id, amount, is_active, sort_order |
| `tournaments` | Tournament listings | id, organiser_id, title, game_mode, max_slots, filled_slots, entry_fee, prize_pool, prize_distribution (JSON), placement_points_map (JSON), kill_point_value, status, start_time, registration_end_time, leaderboard_template |
| `tournament_rooms` | Game room credentials | id, tournament_id, room_id, room_password, revealed_at |
| `teams` | Team registrations | id, tournament_id, team_name, leader_id, in_game_leader_name, invite_code, slot_number, payment_status |
| `team_members` | Junction table: team ↔ user | id, team_id, user_id, is_leader, joined_at |
| `tournament_matches` | Per-round match records | id, tournament_id, match_number, created_at |
| `match_results` | Per-team per-match scores | id, match_id, team_id, placement, placement_points, kills, kill_points, match_total |
| `leaderboard` | Final aggregated standings | id, tournament_id, team_id, total_kills, total_points, rank, prize_awarded |
| `merch_items` | Merch store catalog | id, name, description, price, category, images (array), stock_quantity, is_active |
| `merch_orders` | Merch purchase orders | id, user_id, merch_item_id, quantity, talon_spent, status, fulfillment_note |
| `notifications` | Push notification records | id, user_id, type, title, body, reference_id, is_read — **triggers not implemented** |

### RPC Functions

| Function | Purpose |
|---|---|
| `start_tournament` | Sets tournament status to live, reveals room credentials, sets revealed_at |
| `cancel_tournament` | Sets tournament status to cancelled, triggers refunds |
| `complete_tournament` | Sets tournament status to completed, calculates final standings, distributes prizes |
| `pay_tournament_entry` | Debits team leader's wallet and sets team payment_status to paid |
| `credit_wallet` | Credits a user's wallet (topup, prize payout) and logs transaction |
| `debit_wallet` | Debits a user's wallet (merch purchase) and logs transaction |

---

## Section 8: Backend

### Location

The Node.js backend is a separate project, not co-located with the Flutter repo. It is deployed on Render.

### Endpoints

| Path | Method | Purpose |
|---|---|---|
| `/create-order` | POST | Creates a Razorpay order; accepts `{amount, userId}`, returns `{orderId, keyId, amount, currency}` |
| `/confirm-payment` | POST | Verifies Razorpay signature and credits wallet; accepts `{razorpay_payment_id, razorpay_order_id, razorpay_signature, userId, amount}` |

### Deployment

- **Hosting**: Render free tier
- **URL**: `https://eagle-esports-backend.onrender.com`
- **Known issue**: Free tier spins down after 15 minutes of inactivity. First request after spin-down takes 30–60 seconds.

---

## Section 9: What Is Left To Build

### Critical (blocks launch)

- [ ] Replace payment stub in `team_repository.dart` — remove direct `.update({'payment_status': 'paid'})` fallback
- [ ] Change package name from `com.example.eagle_esports` to real name
- [ ] Configure app icon (run `flutter pub run flutter_launcher_icons`)
- [ ] Configure native splash screen (add `flutter_native_splash`)
- [ ] Switch Razorpay to live keys
- [ ] Privacy policy page live at eagleesport.in/privacy
- [ ] Remove client-side `credit_wallet` RPC fallback in payment_service.dart (security critical)

### High (important before launch)

- [ ] Notifications feature (DB triggers + repository + providers + screen)
- [ ] Fix leaderboard `_prefill` rebuild bug — use `ref.listen` instead of `whenData`
- [ ] Fix `DefaultTabController` reset bug — use manual `TabController` with `TickerProviderStateMixin`
- [ ] Upgrade Render to paid tier or add UptimeRobot keepalive ping
- [ ] End-to-end payment test with real Razorpay flow
- [ ] Fix `profileProvider` crash when profile row doesn't exist yet (use `.maybeSingle()`)
- [ ] Fix all `.first` crashes in stream watchers (wallet, team, merch order) — handle empty lists
- [ ] Fix forced unwrap `value!` in create_room_screen and join_room_screen
- [ ] Fix forgot_password_screen and otp_screen navigation (use `context.pop()`)
- [ ] Fix login_screen forgot password link (navigate instead of snackbar)
- [ ] Fix team_room_screen unbounded height layout

### Medium (post-launch)

- [ ] Wire tournaments joined count in user profile stats
- [ ] Push notifications via FCM
- [ ] Tournament search/filter by name
- [ ] iOS build and App Store submission
- [ ] Admin panel for managing tournaments, merch, and users
- [ ] Settings screen (theme toggle, notification preferences)
- [ ] Deep linking for tournament share URLs
- [ ] Analytics integration

---

## Section 10: File Size Concerns

### Current files over 150 lines

| Lines | File | Notes |
|---|---|---|
| 302 | core/routes/app_routes.dart | Route definitions — expected to be large |
| 270 | merch/presentation/screens/merch_item_detail_screen.dart | Consider splitting |
| 254 | wallet/presentation/screens/add_money_screen.dart | Partially split (topup_option_tile, topup_summary_card extracted) |
| 222 | profile/presentation/widgets/user_profile_menu.dart | Consider splitting |
| 216 | core/theme/widgets/cards/tournament_card.dart | Post-split file — acceptable |
| 204 | auth/presentation/screens/login_screen.dart | Consider splitting |
| 203 | merch/presentation/screens/my_orders_screen.dart | Consider splitting |
| 200 | core/theme/app_theme.dart | ThemeData config — expected to be large |
| 198 | leaderboard/presentation/widgets/match_result_form.dart | Consider splitting |
| 196 | auth/presentation/screens/signup_screen.dart | Partially split (form_fields, submit_button extracted) |
| 196 | organiser_dashboard/screens/create_tournament_screen.dart | Already split into form widgets |
| 195 | organiser_dashboard/screens/organizer_tournament_screen.dart | Consider splitting |
| 184 | leaderboard/screens/organiser_leaderboard_screen.dart | Acceptable |
| 181 | my_tournaments/screens/my_tournaments_screen.dart | Consider splitting |
| 179 | auth/presentation/screens/account_banned_screen.dart | Acceptable |
| 178 | tournament/screens/tournament_details_screen.dart | Already split into detail widgets |
| 171 | wallet/screens/transaction_details_screen.dart | Acceptable |
| 169 | team/presentation/widgets/team_card.dart | Partially split (team_members_sheet extracted) |
| 169 | team/data/team_repository.dart | Data layer — acceptable |
| 165 | team/presentation/widgets/create_room_form.dart | Consider splitting |
| 156 | models/tournament.dart | Model — acceptable |
| 155 | wallet/presentation/providers/wallet_providers.dart | Provider — acceptable |
| 153 | team/presentation/providers/team_providers.dart | Provider — acceptable |
| 151 | team/presentation/widgets/join_room_form.dart | Acceptable |

### Previously large files — split status

| Original File | Pre-split Lines | Current Lines | Status |
|---|---|---|---|
| app_button.dart | 242 | 4 (barrel) | ✅ Split into 4 button files |
| app_card.dart | 320 | 3 (barrel) | ✅ Split into 3 card files |
| app_badge.dart | ~120 | 2 (barrel) | ✅ Split into 2 badge files |
| app_text_field.dart | 239 | 2 (barrel) | ✅ Split into 2 field files |
| add_money_screen.dart | 349 | 254 | ✅ Partially split (2 widgets extracted) |
| signup_screen.dart | 315 | 196 | ✅ Partially split (2 widgets extracted) |
| team_card.dart | 261 | 169 | ✅ Partially split (members sheet extracted) |

---

## Summary Statistics

| Metric | Count |
|---|---|
| Feature modules | 13 (auth, home, tournament, team, leaderboard, wallet, my_tournaments, profile, organiser_dashboard, organiser_tournaments, merch, stats, splash) |
| Screens | ~30 |
| Widgets | ~80 |
| Providers/Notifiers | ~12 files |
| Repositories | 7 (auth, tournament, team, leaderboard, wallet, my_tournaments, merch, profile) |
| Models | 14 |
| Confirmed bugs | 13 |
| Critical blockers | 7 |
| Total Dart files | 176 |
