# ✦ Golden — تطبيق تتبع الذهب والزكاة

تطبيق Flutter لتوثيق ومتابعة الذهب وحساب الزكاة، يدعم العربية والإنجليزية.

---

## 🏗️ Architecture

```
MVVM + Riverpod + Hive Local Storage
```

```
lib/
├── main.dart                         # Entry point
├── app.dart                          # Root widget (locale + theme)
├── l10n/
│   ├── app_en.arb                    # English strings
│   └── app_ar.arb                    # Arabic strings
├── core/
│   ├── constants/app_colors.dart     # Color palette
│   ├── theme/app_theme.dart          # Dark & Light themes
│   ├── router/app_router.dart        # GoRouter + bottom nav
│   └── utils/gold_calculator.dart    # Zakat & gold calculations
├── data/
│   ├── models/gold_item.dart         # Hive model
│   ├── local/hive_service.dart       # Hive initialization
│   └── repositories/gold_repository.dart
├── viewmodels/
│   ├── gold_list_viewmodel.dart      # StateNotifierProvider
│   ├── add_gold_viewmodel.dart       # Add/Edit form state
│   ├── zakat_viewmodel.dart          # Zakat + gold price
│   └── settings_viewmodel.dart      # Locale + Theme + Premium
└── views/
    ├── home/                         # Gold list + summary
    ├── add_gold/                     # Add/edit form
    ├── gold_detail/                  # Item details
    ├── zakat/                        # Zakat calculator
    └── settings/                    # Language, theme, premium
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management (MVVM ViewModels) |
| `hive` + `hive_flutter` | Offline local storage |
| `go_router` | Navigation |
| `image_picker` | Camera / Gallery |
| `pdf` + `printing` | PDF export (premium) |
| `http` | Gold price API |
| `shared_preferences` | Settings persistence |
| `uuid` | Unique item IDs |
| `intl` | Date formatting |

---

## 🚀 Setup & Run

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Generate Hive adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Generate localization files
```bash
flutter gen-l10n
```

### 4. Run the app
```bash
flutter run
```

---

## ✨ Features

- **📋 Gold Inventory** — Add items with name, type, karat, weight, price, date, photo, notes
- **🔢 Zakat Calculator** — Nisaab check (85g 24K), 2.5% zakat calculation
- **💰 Live Gold Price** — Fetch price via API or enter manually
- **🌐 Bilingual** — Full Arabic (RTL) & English support
- **🌙 Dark / Light Theme** — Switchable from settings
- **📄 PDF Export** — Premium feature to export gold list
- **🔒 Fully Offline** — All data stored locally on device

---

## 🕌 Zakat Logic

- **Nisaab** = 85 grams of 24K gold
- **Zakat Rate** = 2.5% of total gold value
- Weight normalized to 24K equivalent before comparison:
  ```
  weight_24K = weight_grams × (karat / 24)
  ```

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| Home | Gold list + summary card (total weight, value, zakat) |
| Add/Edit Gold | Form with image picker, type/karat selectors |
| Gold Detail | Full item info with approximate current value |
| Zakat | Nisaab progress, zakat calculation, price update |
| Settings | Language toggle, theme toggle, premium unlock |
