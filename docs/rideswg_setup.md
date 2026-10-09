# RideSwg — Car Modification App

## Project Structure

```
lib/
├── main.dart                          # App entry, Supabase init, ProviderScope
├── core/
│   ├── theme/app_theme.dart           # Carbon-fiber dark theme, colors, text styles
│   ├── router/app_router.dart         # GoRouter with auth guard
│   └── supabase/supabase_config.dart  # Supabase client
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── login_screen.dart      # Login with Supabase auth + animated bg
│   │       └── signup_screen.dart     # Sign up screen + gold button
│   ├── garage/
│   │   ├── data/car_model.dart        # CarModel data class + 6 demo cars
│   │   └── presentation/
│   │       └── garage_screen.dart     # Car grid + category filter
│   ├── mod_builder/
│   │   └── presentation/
│   │       └── mod_builder_screen.dart  # 3D viewer + mod tabs + live stats
│   └── mod_catalog/
│       └── presentation/
│           └── mod_catalog_screen.dart  # Parts catalog + search
└── shared/
    └── widgets/
        └── main_shell.dart            # Bottom nav shell
```

## 🔑 Step 1: Configure Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. Go to **Project Settings → API**
3. Copy **Project URL** and **anon/public key**
4. Edit [`lib/core/supabase/supabase_config.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/core/supabase/supabase_config.dart):

```dart
static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

> [!IMPORTANT]
> Enable **Email Auth** in Supabase → Authentication → Providers → Email

## 📦 Step 2: Install Dependencies

```bash
/home/z3iss/programs/flutter/bin/ flutter pub get
```

## 🚀 Step 3: Run the App

```bash
/home/z3iss/programs/flutter/bin/ flutter run
```

## 🚗 Step 4: Add Real 3D Car Models

Replace placeholder `modelUrl` in [`car_model.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/features/garage/data/car_model.dart) with real GLB files.

**Free GLB car model sources:**
- [Sketchfab](https://sketchfab.com/3d-models?q=car&sort_by=-likeCount&type=downloadable) — free downloadable GLB
- [poly.pizza](https://poly.pizza) — CC0 licensed models
- [market.pmnd.rs](https://market.pmnd.rs) — React/3D community models

**Hosting options:**
- Supabase Storage (recommended for this project)
- Firebase Storage
- AWS S3 / Cloudflare R2

After uploading, update the URL:
```dart
const CarModel(
  id: 'toyota_supra_mk4',
  name: 'Supra MK4',
  modelUrl: 'https://your-storage.supabase.co/storage/v1/object/public/models/supra_mk4.glb',
  ...
)
```

## 🎨 Features Implemented

| Feature | Status | File |
|---|---|---|
| Login screen (Supabase) | ✅ | `auth/login_screen.dart` |
| Sign up screen | ✅ | `auth/signup_screen.dart` |
| Auth guard / redirect | ✅ | `router/app_router.dart` |
| Car garage (grid) | ✅ | `garage/garage_screen.dart` |
| Category filter | ✅ | `garage/garage_screen.dart` |
| 3D Model Viewer | ✅ | `mod_builder/mod_builder_screen.dart` |
| Live performance stats | ✅ | `mod_builder/mod_builder_screen.dart` |
| Mod options (Body/Wheels/Aero/Exhaust) | ✅ | `mod_builder/mod_builder_screen.dart` |
| Window tint slider | ✅ | `mod_builder/mod_builder_screen.dart` |
| Parts catalog | ✅ | `mod_catalog/mod_catalog_screen.dart` |
| Dark carbon-fiber theme | ✅ | `core/theme/app_theme.dart` |
| Animated login background | ✅ | `auth/login_screen.dart` |
| Bottom navigation | ✅ | `shared/main_shell.dart` |

## 🗺️ Roadmap (Next Steps)

- [ ] Supabase DB — save user builds
- [ ] Real car GLB models in Supabase Storage
- [ ] Community feed (share builds)
- [ ] AR try-on (camera + 3D overlay)
- [ ] In-app purchases for premium parts
- [ ] Push notifications for new parts
