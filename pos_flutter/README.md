# HesabiMan POS - Flutter Application

A comprehensive Point of Sale (POS) system built with Flutter, converted from the original web-based POS.htm application.

## Tech Stack

### Frontend (Flutter/Dart)
- **Flutter** - Cross-platform UI framework
- **Provider + ChangeNotifier** - State management
- **SQLite (sqflite_sqlcipher)** - Encrypted local database
- **flutter_secure_storage** - Secure credential storage
- **shared_preferences** - Lightweight persistent storage
- **intl** - Internationalization (Fa/Ps/En)
- **uuid** - Unique ID generation
- **path_provider** - File path handling
- **share_plus** - Receipt sharing functionality
- **Poppins font** - Modern typography
- **Material Icons** - Icon library

### Backend (Node.js + Express + PostgreSQL)
- **Node.js** - Runtime environment
- **Express** - Web framework
- **PostgreSQL** - Relational database

## Project Structure

```
pos_flutter/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── user.dart
│   │   ├── product.dart
│   │   ├── customer.dart
│   │   ├── cart_item.dart
│   │   └── sale.dart
│   ├── providers/                # State management
│   │   ├── database_provider.dart
│   │   ├── auth_provider.dart
│   │   ├── theme_provider.dart
│   │   ├── product_provider.dart
│   │   ├── customer_provider.dart
│   │   ├── cart_provider.dart
│   │   └── sale_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── pos_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── products_screen.dart
│   │   ├── customers_screen.dart
│   │   ├── users_screen.dart
│   │   └── expenses_screen.dart
│   ├── widgets/                  # Reusable widgets
│   ├── services/                 # External services
│   └── utils/                    # Utilities & constants
│       └── constants.dart
├── assets/
│   └── fonts/                    # Poppins font files
├── test/                         # Unit tests
└── pubspec.yaml                  # Dependencies
```

## Features

### Core POS Features
- 🛒 Product catalog with barcode scanning
- 🛍️ Shopping cart management
- 💰 Multiple payment methods (Cash, Half, Custom, Credit)
- 📝 Discount application (percentage/amount)
- ⏸️ Hold/Recall orders
- 🧾 Receipt generation and sharing
- 👤 Customer management with credit tracking

### User Management
- 🔐 PIN-based authentication
- 👥 Role-based access control (Admin, Manager, Cashier)
- 🔑 Permission-based feature access
- 🔄 User switching

### Inventory
- 📦 Stock tracking
- ⚠️ Low stock alerts
- 📅 Expiry date monitoring
- 🏷️ Barcode support

### Reports & Analytics
- 📊 Sales dashboard
- 📈 Daily/Weekly/Monthly reports
- 💵 Expense and income tracking
- 🔄 Shift management (X/Z reports)

### Multi-language Support
- 🇦🇫 Dari/Farsi
- 🇦🇫 Pashto
- 🇬🇧 English

### Theme Support
- ☀️ Light mode
- 🌙 Dark mode

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Node.js (for backend)
- PostgreSQL (for backend)

### Installation

1. Clone the repository
2. Navigate to the Flutter project:
   ```bash
   cd pos_flutter
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Add Poppins font files to `assets/fonts/`

5. Run the app:
   ```bash
   flutter run
   ```

### Backend Setup (Optional)

1. Navigate to backend folder (to be created)
2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure PostgreSQL connection in `.env`

4. Run migrations

5. Start server:
   ```bash
   npm start
   ```

## Database Schema

The app uses SQLite for local storage with the following tables:
- `users` - User accounts and permissions
- `products` - Product catalog
- `categories` - Product categories
- `customers` - Customer information
- `customer_transactions` - Customer account transactions
- `sales` - Sales records
- `expenses` - Expenses and income
- `shifts` - Shift management
- `held_orders` - Suspended orders

## Testing

Run tests:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### Windows
```bash
flutter build windows --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is proprietary software.

## Support

For support, please contact the development team.
