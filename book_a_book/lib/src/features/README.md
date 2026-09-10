# Features

Each feature is a vertical slice, split into three layers. The dependency
direction is strictly one way:

```
presentation  ->  data  ->  (Supabase, via core/supabase/SupabaseAdapter)
      |             |
      +------> domain <------+
```

| Folder | Contains | May import |
|---|---|---|
| `domain/` | Plain Dart models + enums. No Flutter, no Supabase. | nothing |
| `data/` | Repository + its Riverpod provider. The only layer that queries. | `domain`, `core` |
| `presentation/` | `screens/`, `widgets/`, `view_models/`. | `domain`, `data`, `core` |

## Rules that keep this honest

1. **`SupabaseClient` appears in `core/supabase/supabase_adapter.dart` and
   nowhere else.** `grep -r "supabase" lib/src/features` should only ever match
   `data/` files. That is a mechanical test for separation of concerns.
2. **Repositories return domain types**, never `Map<String, dynamic>`.
3. **View models hold UI state, repositories hold data access.** If a view model
   builds a query string, it is doing the repository's job.
4. **Reusable widgets take data via constructor and emit callbacks.** A widget
   that reads a provider is welded to one screen's state.
5. **`core/` never imports `features/`.** One-way, or you get import cycles.
6. **Cross-feature coupling goes through `domain/`**, or not at all. `books`
   defines its own small `BookOwner` rather than importing the whole `profile`
   feature — see `books/domain/book.dart`.

## Adding a feature

Copy the shape of `books/`, which is the reference implementation:

```
books/
├── data/
│   ├── books_repository.dart              # queries + booksRepositoryProvider
│   └── models/book_api_model.dart         # raw API shape
├── domain/book.dart                        # Book, BookOwner, enums, fromMap
└── presentation/
    ├── view_models/books_view_model.dart   # AsyncNotifier + family providers
    ├── screens/books_screen.dart           # layout + wiring only
    └── widgets/book_card.dart              # reusable, provider-free
```

`requests/` and `profile/` are stubbed to that shape and still need filling in.
