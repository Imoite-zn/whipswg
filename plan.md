
Listed directory lib
Listed directory features
Listed directory mod_builder
Viewed mod_builder_screen.dart:1-100
Viewed mod_builder_screen.dart:101-220
Viewed mod_builder_screen.dart:550-744
Viewed garage_screen.dart:50-180
Viewed main_shell.dart:1-133
Viewed car_model.dart:1-127

Here is the current status breakdown of each requested feature against the codebase:

---

### 📊 Feature Accounting Status

| Feature Requirement | Status | What Currently Exists | What Is Missing / Needs Building |
| :--- | :---: | :--- | :--- |
| **1. Upload Car View Module** | ❌ **Not accounted for** | Hardcoded demo fleet in [`car_model.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/features/garage/data/car_model.dart). | • UI to add/upload a custom car.<br>• Multi-angle photo upload & GLB 3D model upload.<br>• Custom vehicle specs input (VIN, Year, Make, Model, Trim). |
| **2. Body Type & Add-on Body Parts** | ⚠️ **Partial Skeleton** | Basic body kit dropdown in [`mod_builder_screen.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/features/mod_builder/presentation/mod_builder_screen.dart) with 4 generic names. | • Body type selector (Coupe, Sedan, Hatch, Widebody, Targa).<br>• Granular add-on body parts: Front Splitter, Canards, Side Skirts, Rear Diffuser, Carbon Hood, Fenders, Roof Scoops. |
| **3. Paint & Car Wrap Customizer** | ❌ **Not accounted for** | Fixed `colorHex` on stock car data; only window tint percentage slider exists. | • Interactive color palette & hex picker.<br>• Finish types: **Gloss, Matte, Satin, Metallic, Pearl, Chrome, Carbon Fiber Wrap**.<br>• Wrap livery/decal styling options. |
| **4. Final View Render After Mods** | ⚠️ **Basic Static 3D** | Embedded `<model-viewer>` running a static astronaut placeholder model. | • Dynamic visual response reflecting selected wrap/paint color.<br>• Multi-angle camera views (Front 3/4, Side Profile, Rear Diffuser, Top-Down).<br>• Final "Build Summary Render" showing before/after comparison. |
| **5. Realistic Measurements, Requirements & "Port to Mechanic"** | ❌ **Not accounted for** | Basic placeholder HP/Weight stats (`+25 HP`, `-15 lbs`). | • Real-world technical specs: wheel offsets (ET), bolt pattern (e.g. 5×114.3), tire sizing, exhaust diameter (e.g. 3.0" Cat-back), tune stages (Stage 1/2), labor time.<br>• **"Mechanic Spec Sheet" generator / export** with parts SKU, estimated labor hours, and installation requirements to share directly with a garage. |
| **6. Mechanics & Modders Module (Profile, Location, Verification)** | ❌ **Not accounted for** | App is currently car-owner focused only; test accounts have tuner role tags, but no distinct access module exists. | • Dedicated **Mechanic / Modder Portal** & access mode.<br>• Workshop profile creation (Garage name, geo-location, services offered, years in business, ASE/certifications, verified badge request). |
| **7. 5-Star Ranking & Reviews from Car Owner POV** | ❌ **Not accounted for** | Only Garage and Mod Catalog tabs exist in [`main_shell.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/shared/widgets/main_shell.dart). | • **"Find Mechanics & Modders" directory** accessible by car owners.<br>• 5-star rating display, customer reviews, verified workshop badges, distance/location sorting, and "Send Build to Workshop for Quote" flow. |

---

### 🛠️ Proposed Implementation Architecture

To implement these requirements cleanly without cluttering the app, we can organize them into **3 core modules**:

```
lib/features/
├── garage/
│   ├── presentation/
│   │   ├── garage_screen.dart
│   │   └── upload_car_screen.dart           <-- [NEW] Upload custom car (3D GLB & photos)
│   └── data/car_model.dart
├── mod_builder/
│   ├── presentation/
│   │   ├── mod_builder_screen.dart          <-- [UPGRADED] Paint/Wrap picker + Body parts
│   │   ├── widgets/paint_customizer.dart    <-- [NEW] Gloss, Matte, Satin, Metallic, Carbon
│   │   └── widgets/mechanic_spec_sheet.dart <-- [NEW] Exportable specs & requirements sheet
│   └── data/mod_specs_data.dart             <-- [NEW] Realistic technical specs & measurements
└── mechanics/                               <-- [NEW MODULE]
    ├── data/mechanic_model.dart             <-- Workshop model, ratings, services, location
    └── presentation/
        ├── mechanics_directory_screen.dart  <-- Owner POV: 5-star directory & quote request
        ├── mechanic_detail_screen.dart      <-- Workshop profile, reviews, verified badge
        └── mechanic_portal_screen.dart      <-- Mechanic access: profile setup & verification
```

---

### How would you like to proceed?

We can build this systematically:
1. **Phase 1: Mod Studio Upgrade** (Paint/Wrap customizer + Granular body parts + Realistic measurements & "Port to Mechanic" spec sheet export).
2. **Phase 2: Car Upload Module** (UI and flow to add user vehicles with multi-angle views and 3D upload).
3. **Phase 3: Mechanics & Modders Module** (5-Star workshop directory for owners + Mechanic profile creation & verification portal).

Shall we begin with **Phase 1 (Paint/Wrap customizer, modular body parts, and the realistic Mechanic Spec Sheet)**?