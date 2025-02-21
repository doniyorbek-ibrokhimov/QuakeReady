# QuakeReady

QuakeReady is an iOS application designed to help users prepare for and respond to earthquake emergencies through interactive drills, safety quizzes, and educational content.

## Features

### 1. Interactive Drills
- Three types of earthquake safety drills:
  - Basic Drop-Cover-Hold
  - Elevator Safety Protocol
  - Crowded Space Protocol
- Step-by-step instructions with visual guidance
- Timer-based practice sessions

### 2. Safety Quizzes
- Comprehensive knowledge assessment
- Interactive multiple-choice questions
- Instant feedback and explanations
- Progress tracking

### 3. Risk Assessment
- Global and regional earthquake risk data
- Real-time risk assessment updates
- Data sourced from [Earthquakelist.org](https://earthquakelist.org/reports/top-100-countries-most-earthquakes/) (2024 statistics)
- Top high-risk countries include:
  1. Mexico (1,972 significant earthquakes)
  2. Indonesia (1,870 significant earthquakes)
  3. Japan (1,559 significant earthquakes)
  4. Philippines (996 significant earthquakes)

### 4. Achievement System
- Unlock badges for completed drills
- Track progress through different safety levels
- Earn rewards for quiz performance
- Visual progress indicators

## Technical Architecture

### Data Management
- SwiftData for persistent storage
- Models for:
  - DrillAchievement
  - QuizAchievement
  - BadgeAchievement

### UI Components
- SwiftUI-based interface
- Dark mode support
- Custom components:
  - Progress indicators
  - Interactive buttons
  - Achievement cards
  - Timer displays

### Key View Models
- DrillLibraryViewModel: Manages drill sessions and progress
- QuizLibraryViewModel: Handles quiz state and scoring
- BadgeGalleryViewModel: Tracks achievements and unlocks
- HomeViewModel: Coordinates overall app state

## Getting Started

### Prerequisites
- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

### Installation
1. Clone the repository
2. Open QuakeReady.xcodeproj in Xcode
3. Build and run the project

## Project Structure

QuakeReady/
├── Features/
│   ├── Drill/
│   ├── Quiz/
│   ├── BadgeGallery/
│   ├── Home/
│   └── Onboarding/
├── Models/
├── Views/
└── ViewModels/

## Future Enhancements
- Offline support
- Localization
- Real-time earthquake alerts
- Community features
- Additional drill scenarios
- VR/AR integration possibilities

## Technical Highlights

- MVVM Architecture
- SwiftUI for modern UI development
- SwiftData for persistence
- Environment Object pattern for state management
- Custom navigation system
- Modular feature organization
- Comprehensive achievement system
- Real-time progress tracking

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.