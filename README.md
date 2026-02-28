# ZaviMart — Daraz-Style Product Listing (Flutter)

A Flutter app demonstrating a **single-scroll, sliver-based** product listing screen
with collapsible header, sticky tab bar, horizontal swipe navigation, and real API
integration via [Fake Store API](https://fakestoreapi.com/).

---

## Running the App

```bash
flutter pub get
flutter run
```

**Demo credentials** (shown on the login screen):

| Username   | Password |
| ---------- | -------- |
| `mor_2314` | `83r5^_` |

---

## Architecture Overview

```
lib/
├── core/                    # Shared infrastructure
│   ├── bindings/            # GetX dependency injection
│   ├── models/              # ResponseData
│   ├── services/            # NetworkCaller, StorageService
│   └── utils/               # Constants, theme, validators
├── features/
│   ├── authentication/      # Login screen, controller, AuthService
│   ├── home/                # ★ Main product listing screen
│   │   ├── controllers/     # HomeController (state + scroll owner)
│   │   ├── data/
│   │   │   ├── models/      # ProductModel
│   │   │   └── services/    # ProductService (API calls)
│   │   └── presentation/
│   │       ├── screens/     # HomeScreen (single CustomScrollView)
│   │       └── widgets/     # Collapsible header, sticky tabs, product card
│   └── profile/             # User profile screen
└── routes/                  # Centralized routing
```

---

## Mandatory Explanations

### 1. How Horizontal Swipe Was Implemented

A single `GestureDetector` with `onHorizontalDragEnd` wraps the **entire
scrollable area** (above both the `RefreshIndicator` and `CustomScrollView`):

```dart
GestureDetector(
  behavior: HitTestBehavior.translucent,
  onHorizontalDragEnd: (details) {
    controller.handleHorizontalSwipe(details);
  },
  child: RefreshIndicator(
    child: CustomScrollView(...)
  ),
)
```

**Why this works without conflict:**

- Flutter's gesture arena always runs when a pointer touches the screen. Both
  the `HorizontalDragGestureRecognizer` (from our `GestureDetector`) and the
  `VerticalDragGestureRecognizer` (from `CustomScrollView`) enter the arena.
- The arena disambiguates based on the **initial movement direction**:
  - Horizontal movement → horizontal recognizer wins → tab switches, **no** vertical scroll.
  - Vertical movement → vertical recognizer wins → list scrolls, **no** tab switch.
- Only ONE recognizer wins per pointer sequence — there is never simultaneous
  horizontal + vertical gesture handling.
- A minimum velocity threshold of **300 px/s** in `handleHorizontalSwipe()`
  prevents accidental tab switches from slow or ambiguous movements.
- Tabs are also switchable by **tapping** the sticky tab bar directly.

**Why not per-item GestureDetector?** Placing `onHorizontalDragEnd` on each
product card is fragile: it doesn't work on empty areas, duplicates logic
across items, and creates many competing recognizers. A single top-level
detector is cleaner and more predictable.

### 2. Who Owns the Vertical Scroll and Why

**Owner:** A single `ScrollController` in `HomeController`, attached to the
one and only `CustomScrollView` in `HomeScreen`.

**Why:**

- The task requires **exactly one vertical scrollable**. All content is
  rendered as slivers inside this `CustomScrollView`:
  - `SliverAppBar` → collapsible header (banner + search bar)
  - `SliverPersistentHeader` → sticky tab bar (pinned)
  - `SliverList` → product cards
- There are **no** nested `ListView`s, `PageView`s, or `TabBarView`s. The
  tab content is swapped by changing the data source of the `SliverList`
  reactively via `Obx`.
- The `RefreshIndicator` monitors scroll notifications from this single
  scrollable, so pull-to-refresh works from any tab at any scroll position.
- Tab switching only mutates `selectedTabIndex`; the `ScrollController` offset
  is **never reset**, preserving the user's scroll position across tab changes.

## Features

- **Login** via Fake Store API (`POST /auth/login`)
- **Home screen** with API-driven product listing (`GET /products`)
  - Collapsible header with search
  - Sticky pinned tab bar (For You / Top Rated / Budget)
  - Pull-to-refresh from any tab
  - Horizontal swipe to switch tabs
  - Loading, error, and empty states
- **Profile screen** with user data from `GET /users/:id`
- **Logout** (clears stored token)

---

## Tech Stack

- **Flutter** with **GetX** (state management, routing, DI)
- **flutter_screenutil** for responsive sizing
- **http** package for API calls
- **shared_preferences** for token persistence
