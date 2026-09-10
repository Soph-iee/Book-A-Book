# Book-A-Book

A peer-to-peer book lending platform built with Flutter. Browse books near you, borrow with refundable escrow, and manage requests — all connected through a Supabase backend.

## What it does

Book-A-Book connects readers who want to lend and borrow physical books. Signed-out visitors can browse the public catalogue. Once signed in, users can  request books, borrow books, list books and track incoming/outgoing requests, and manage their profile.

The app is built around proximity: books are shown "near you", and location is required before browsing. The design targets a minimum of 393×852 mobile canvas, but the same codebase runs on Windows desktop.

## Tech stack

| Layer | Choice |
|---|---|
| UI | Flutter, Material 3, `flutter_screenutil` |
| State | Riverpod (`flutter_riverpod`, `riverpod_annotation`) |
| Routing | `go_router` |
| Backend | Supabase (`supabase_flutter`) — PostgREST + Auth + Storage |
| Location | `geolocator` |
| Networking | `http`, custom `LoggingHttpClient` |
| Serialization | `json_annotation` / `freezed_annotation` |
| Desktop | Windows support via Flutter's desktop embedding |

## Features

- **Public landing page** — browse genres and available books without signing in
- **Authentication** — sign in, sign up, password reset via Supabase Auth
- **Book catalogue** — search by title/author, filter by genre, horizontal carousels
- **Book detail** — cover gallery, owner card, AI summary, tags, borrow CTA
- **Borrow flow** — refundable escrow confirmation before borrowing
- **Request management** — incoming and outgoing borrow requests (in progress)
- **Profile** — avatar, location text, name (in progress)
- **Onboarding** — location gate after sign-up (GPS or manual entry)



## Project structure

```
book_a_book/
├── lib/src/
│   ├── app.dart
│   ├── core/
│   │   ├── config/env.dart
│   │   ├── errors/failure.dart
│   │   ├── network/logging_http_client.dart
│   │   ├── router/app_router.dart
│   │   ├── services/location_service.dart
│   │   ├── supabase/
│   │   │   ├── supabase_adapter.dart
│   │   │   ├── supabase_providers.dart
│   │   │   └── tables.dart
│   │   ├── theme/
│   │   └── widgets/
│   └── features/
│       ├── auth/
│       │   ├── data/auth_repository.dart
│       │   ├── domain/auth_user.dart
│       │   │   auth_session.dart
│       │   └── presentation/
│       │       ├── view_models/auth_view_model.dart
│       │       ├── screens/sign_in_screen.dart
│       │       └── screens/sign_up_screen.dart
│       ├── books/
│       │   ├── data/
│       │   │   ├── models/book_api_model.dart
│       │   │   └── books_repository.dart
│       │   ├── domain/book.dart
│       │   └── presentation/
│       │       ├── view_models/books_view_model.dart
│       │       ├── screens/books_screen.dart
│       │       ├── screens/book_detail_screen.dart
│       │       └── widgets/book_card.dart
│       ├── home/
│       ├── onboarding/
│       ├── profile/
│       └── requests/
├── docs/design/
├── assets/
│   ├── images/
│   └── svg/
├── dart_define.example.json
├── dart_define.json
└── pubspec.yaml
```


