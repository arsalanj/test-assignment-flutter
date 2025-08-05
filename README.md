# Flutter Timer App

A mobile-only Flutter application for managing task-based timers with a clean, modern UI following Figma design specifications.

## 📱 Overview

This Flutter app allows users to create, manage, and track multiple timers associated with specific tasks and projects. The application features a beautiful gradient UI, real-time timer updates, and comprehensive timer management capabilities.

## ✨ Features

### Core Functionality
- **Timer Management**: Create, start, pause, and stop multiple timers
- **Task Association**: Link timers to specific projects and tasks
- **Real-time Updates**: Live timer counting with automatic UI updates
- **Timer States**: Support for active, paused, and completed timer states
- **Favorites**: Mark timers as favorites for quick access

### User Interface
- **Figma-based Design**: Pixel-perfect implementation of provided Figma designs
- **Gradient Background**: Beautiful blue gradient matching design specifications
- **Custom Timer Cards**: Elegant timer cards with project/task information
- **Tab Navigation**: Organized tabs for different timer categories
- **Responsive Layout**: Optimized for mobile devices

### Navigation & Deep Linking
- **Deep Linking Support**: Navigate directly to specific screens via routes
- **Route Management**: Clean route structure with go_router
- **Screen Navigation**: Seamless navigation between timer list, creation, and details

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── router/          # Navigation and routing
│   └── theme/           # App theming and colors
├── features/
│   └── timers/
│       ├── bloc/        # BLoC state management
│       ├── data/        # Mock data and repositories
│       ├── models/      # Data models
│       └── presentation/
│           ├── pages/   # Screen widgets
│           └── widgets/ # Reusable UI components
├── app.dart            # Main app widget
└── main.dart           # App entry point
```

## 🎨 Design System

### Colors
- **Primary Gradient**: `#0C1D4D` to `#214ECC`
- **Card Background**: `rgba(255, 255, 255, 0.08)`
- **Accent Color**: `#FFC629` (Yellow)
- **Text Colors**: White with various opacities

### Typography
- **Primary Font**: Inter
- **Monospace**: For timer displays
- **Font Weights**: 400, 500, 600, 700

## 📱 Screens

### 1. Timer List Screen (`/timers`)
- Displays all active and completed timers
- Tab navigation (Favorites, Odoo, Local)
- Timer count display
- Quick access to timer controls

### 2. Create Timer Screen (`/timers/create`)
- Project selection dropdown
- Task selection dropdown
- Timer description input
- Favorite checkbox
- Form validation

### 3. Task Details Screen (`/task/:taskId/details`)
- Task information display
- Deadline and assignment details
- Static task metadata

### 4. Task Timesheets Screen (`/task/:taskId/timesheets`)
- Timer controls (Play/Pause/Stop)
- Timer metadata and descriptions
- Real-time timer updates

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10.0
- Dart SDK ≥ 3.0.0
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd timer_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run with hot reload
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build for release
flutter build apk          # Android
flutter build ios          # iOS
```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc: ^8.1.3` - State management
- `equatable: ^2.0.5` - Value equality
- `go_router: ^12.1.3` - Navigation and routing

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints` - Linting rules

## 🎯 Key Features Implementation

### State Management
- **BLoC Pattern**: Centralized state management with `TimerBloc`
- **Event-Driven**: User actions trigger events that update state
- **Reactive UI**: UI automatically updates based on state changes

### Timer Functionality
- **Multiple Timers**: Support for concurrent timer execution
- **Persistence**: Timer state maintained during app lifecycle
- **Real-time Updates**: Automatic UI updates every second for running timers

### Navigation
- **Deep Linking**: Direct navigation to specific screens
- **Route Parameters**: Dynamic routing with task/timer IDs
- **Navigation Guards**: Proper route handling and validation

## 🎨 UI Components

### Custom Widgets
- **TimerCard**: Reusable timer display component
- **Custom AppBar**: Gradient-based navigation header
- **Tab Navigation**: Custom tab implementation
- **Timer Controls**: Play/pause/stop button components

### Responsive Design
- **Mobile-First**: Optimized for mobile devices
- **Safe Areas**: Proper handling of device safe areas
- **Adaptive Layouts**: Responsive to different screen sizes

## 🧪 Testing

The app includes comprehensive testing:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

## 📱 Platform Support

- ✅ **iOS**: Full support with native performance
- ✅ **Android**: Full support with Material Design
- ❌ **Web**: Not supported (mobile-only app)
- ❌ **Desktop**: Not supported (mobile-only app)

## 🔧 Configuration

### App Configuration
- **App Name**: Timer App
- **Bundle ID**: Configurable per platform
- **Minimum SDK**: iOS 11.0, Android API 21

### Environment Setup
- **Development**: Debug mode with hot reload
- **Production**: Release builds with optimizations

## 📋 Project Structure Details

### Models
- `TimerModel`: Timer entity with state management
- `ProjectModel`: Project information
- `TaskModel`: Task details and metadata

### BLoC Architecture
- `TimerBloc`: Main business logic controller
- `TimerEvent`: User action definitions
- `TimerState`: Application state representations

### Routing
- Declarative routing with go_router
- Type-safe route parameters
- Deep linking support

## 🎯 Future Enhancements

### Potential Features
- **Data Persistence**: Local storage with SQLite
- **Cloud Sync**: Firebase integration
- **Notifications**: Background timer notifications
- **Analytics**: Timer usage analytics
- **Export**: Timer data export functionality

### Technical Improvements
- **Unit Tests**: Comprehensive test coverage
- **Integration Tests**: End-to-end testing
- **Performance**: Optimization for large timer lists
- **Accessibility**: Enhanced accessibility features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Figma Design**: UI/UX design specifications
- **Flutter Team**: Amazing framework and documentation
- **BLoC Library**: Excellent state management solution

---

**Built with ❤️ using Flutter**
