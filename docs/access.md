# 🏎️ RideSwg — Test Logins & Access Documentation

This document contains test accounts for **RideSwg** development, QA, and demonstration purposes.

---

## ⚡ Quick Test Credentials

All test accounts are pre-configured into the application. You can use them directly on the **Login Screen** either by clicking any **Test Access** card for 1-tap instant login or by manually entering the credentials:

| Badge | Display Name | Role | Email | Password | Access Level |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **`PRO`** | **Alex Mercer** | Pro Street Tuner | `driver@rideswg.com` | `RideSwg2026!` | All Models & Performance Parts |
| **`TRACK`** | **Sarah Jenkins** | Track Specialist | `speed@rideswg.com` | `RideSwg2026!` | Track & Aero Catalog |
| **`DRIFT`** | **Kenji Sato** | Drift Master | `drift@rideswg.com` | `RideSwg2026!` | JDM & Stance Builds |
| **`VIP`** | **Demo Driver** | VIP Member | `demo@rideswg.com` | `demo1234` | Full Demo Access |

---

## 📱 How to Use in the App

### Option A: 1-Tap Quick Login (Fastest)
1. Launch the app (`flutter run -d chrome`).
2. Scroll to the **TEST ACCESS** section on the login screen.
3. Tap the **Log In** icon `➔` on any driver card to instantly enter the **Garage** as that driver.

### Option B: Auto-Fill Form
1. Tap anywhere on any test driver card.
2. The email and password will automatically populate the form fields.
3. Tap **SIGN IN**.

### Option C: Manual Entry
1. Enter any of the emails and passwords listed above into the login form.
2. Tap **SIGN IN**.

---

## 🛠️ Adding These Users to Supabase (Optional)

If you have connected your Supabase project in [`lib/core/supabase/supabase_config.dart`](file:///home/z3iss/Zn/code/zeiss/lord_z/ride_swg/lib/core/supabase/supabase_config.dart) and want these accounts persisted directly in your Supabase backend:

### Method 1: Via Supabase Dashboard
1. Go to your [Supabase Dashboard](https://supabase.com/dashboard).
2. Navigate to **Authentication** ➔ **Users**.
3. Click **Add User** ➔ **Create User**.
4. Enter the email and password from the table above.
5. In **User Metadata**, include:
   ```json
   {
     "display_name": "Alex Mercer"
   }
   ```
6. Toggle **Auto Confirm User?** to `true` (skips email confirmation).

### Method 2: Via Supabase SQL Editor
Run the following SQL snippet in your Supabase SQL editor:

```sql
-- 1. Alex Mercer (Pro Street Tuner)
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'driver@rideswg.com',
  crypt('RideSwg2026!', gen_salt('bf')),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"display_name":"Alex Mercer","role":"Pro Street Tuner"}',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- 2. Sarah Jenkins (Track Specialist)
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'speed@rideswg.com',
  crypt('RideSwg2026!', gen_salt('bf')),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"display_name":"Sarah Jenkins","role":"Track Specialist"}',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- 3. Kenji Sato (Drift Master)
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'drift@rideswg.com',
  crypt('RideSwg2026!', gen_salt('bf')),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"display_name":"Kenji Sato","role":"Drift Master"}',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;

-- 4. Demo Driver (VIP Member)
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'demo@rideswg.com',
  crypt('demo1234', gen_salt('bf')),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"display_name":"Demo Driver","role":"VIP Member"}',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING;
```

---

## 🔒 Security Note

> [!WARNING]
> These credentials are for **local testing, QA, and demonstration only**.
> Do not use these passwords for production environments or production database accounts.
