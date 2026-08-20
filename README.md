# HomeEase

HomeEase is a Flutter-based home service booking application that helps users find and book professionals for common household services such as electricians, plumbers, carpenters, painters and cleaners.

The idea behind HomeEase is similar to the concept used by Urban Company, where customers can browse different home services, find suitable professionals and book a service according to their requirements.

>HomeEase is an independent project inspired by the home-service marketplace concept of Urban Company. It is not an official Urban Company application or a direct clone of Urban Company.

This project was developed by<b> Habib Gheta </b>as part of industrial training (Internship) @NASTECH to gain practical experience in Flutter, Firebase, Cloud Firestore, Cloudinary, authentication, database management and responsive application development.

## Features

### User Authentication

- User registration with first name, last name, email and password
- Firebase Email/Password Authentication
- Automatic login using Firebase authentication state
- Forgot password functionality
- Password reset through email
- Password visibility toggle
- Confirm password validation
- Email and password validation
- Duplicate email detection
- Loading indicators during authentication
- Error handling with SnackBars
- Logout with confirmation
- Automatic navigation based on authentication state

### User Profile

- View user profile
- Display first name and last name
- Display registered email
- Edit profile information
- Email cannot be changed from the profile
- Upload profile picture
- Select profile picture from device gallery
- Store profile images using Cloudinary
- Display uploaded profile picture
- Person icon shown when no profile picture is available
- Automatically refresh profile information after editing

### Service Categories

- Browse available service categories
- View services in a simple category-based layout
- Admin can add categories
- Admin can edit categories
- Admin can delete categories

### Service Providers

- View available service providers
- View provider information
- Provider employee code
- Provider services
- Provider availability and status
- Provider rating
- Provider hourly charges
- Admin can add service providers
- Admin can edit service providers
- Admin can delete service providers
- Admin can manage provider services
- Admin can manage provider availability and status

### Favorites

- Add service providers to favorites
- Remove service providers from favorites
- View favorite providers
- Favorites are stored separately for each user
- Favorite status is maintained using Cloud Firestore

### Service Booking

- Select a service provider
- Select a service
- Select date
- Select available time slot
- Book a service
- View booking history
- View booking details
- View provider name
- View service name
- View booking date
- View time slot
- View service charges
- View booking status
- Cancel bookings
- Prevent unavailable or booked time slots from being selected
- Store bookings in Cloud Firestore

### Settings

- Light theme
- Dark theme
- Theme switching
- Theme preference is saved
- Selected theme is restored when the application is opened again
- Language information
- Application version information

### Admin Panel

The application includes a separate admin panel for managing the application's data.

#### Categories

- View categories
- Add categories
- Edit categories
- Delete categories

#### Service Providers

- View service providers
- Add service providers
- Edit service providers
- Delete service providers
- Manage provider services
- Manage provider availability and status

#### Users

- View registered users
- View user information
- Delete users

#### Bookings

- View all bookings
- View booking information
- Cancel bookings
- Delete bookings
- Update booking status
- View booked and cancelled status

### Admin Panel UI

- Separate admin dashboard
- Categories section
- Service Providers section
- Users section
- Bookings section
- Responsive admin layout
- Single-column layout on mobile devices
- Single-column layout on tablets
- Two-column layout on desktop
- Dark and light theme support
- Admin logout

## Additional Features

- Splash screen with HomeEase branding
- Five-second splash screen
- Automatic navigation from splash screen
- Authentication-based navigation after splash screen
- Automatic redirection of normal users to the Home screen
- Automatic redirection of administrators to the Admin Panel
- Responsive layouts for different screen sizes
- Dark theme support throughout the application
- Light theme support throughout the application
- Loading indicators during data loading
- SnackBar messages for successful and failed operations
- Confirmation dialogs for important actions
- Empty-state messages when no data is available
- Reusable custom buttons
- Reusable custom text fields
- Firebase authentication state management
- Firestore security rules
- User-specific Firestore data access
- Admin-specific Firestore permissions

## Technology Stack

### Frontend

- Flutter
- Dart
- Material Design

### Backend and Services

- Firebase Authentication
- Cloud Firestore
- Cloudinary

### Development Tools

- Android Studio
- Visual Studio Code
- Git
- GitHub

## Application Flow

### User Flow

1. Splash Screen
2. Authentication Check
3. Login or Register
4. Home Screen
5. Browse Service Categories
6. View Service Providers
7. Add Providers to Favorites
8. Select a Service Provider
9. Select Date and Time Slot
10. Confirm Booking
11. View Booking History
12. Manage Profile and Settings

### Admin Flow

1. Splash Screen
2. Authentication Check
3. Admin Login
4. Admin Panel
5. Manage Categories
6. Manage Service Providers
7. Manage Users
8. Manage Bookings

## Project Structure

```text
lib/
    models/
    screens/
        about/
        admin/
        auth/
        booking/
        favorites/
        home/
        profile/
        settings/
        splash/
    services/
    theme/
    utils/
    widgets/
```

## Firebase

Firebase is used for authentication and application data management.

### Firebase Authentication

Firebase Authentication is used for:

- User registration
- User login
- Password reset
- Authentication state management
- User logout

### Cloud Firestore

Cloud Firestore is used to store:

- User information
- Service categories
- Service providers
- Bookings
- Favorites
- Admin information

Firestore security rules are implemented to restrict access to user and admin data.

## Cloudinary

Cloudinary is used to store profile images uploaded by users.

When a user selects a profile picture:

1. The image is selected from the device gallery.
2. The image is uploaded to Cloudinary.
3. Cloudinary returns the image URL.
4. The URL is stored in the user's Firestore document.
5. The image is displayed in the user's profile.

## Responsive Design

HomeEase supports different screen sizes.

- Mobile devices use a single-column layout where appropriate
- Tablets use a single-column layout where appropriate
- Desktop screens use a two-column layout for the admin panel
- Content is scrollable on smaller screens
- UI elements adjust according to available screen space

## Getting Started

### Prerequisites

Make sure the following are installed:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Git

### Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/home_ease.git
```

### Navigate to the Project

```bash
cd home_ease
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

Firebase and Cloudinary configuration must be set up before running the application.

## Project Status

HomeEase Version 1 is complete.

The current version includes user authentication, service categories, service providers, favorites, service booking, profile management, theme switching and a complete admin panel.

## Future Improvements

The following features can be considered for future versions:

- Online payment integration
- Push notifications
- Provider-side application
- Real-time booking updates
- Reviews and ratings from actual users
- Advanced provider availability management
- Improved admin analytics
- Service provider registration

## Urban Company Inspiration

HomeEase is based on the same general concept as home-service platforms such as Urban Company.

The application allows users to browse home services, view professionals and book services according to their requirements.

HomeEase is not an official Urban Company application and is not a direct clone of Urban Company. It is an independently developed educational project inspired by the same home-service booking concept.

## Disclaimer

HomeEase is an independent educational project developed as part of industrial training.

The project is not affiliated with, sponsored by, or endorsed by Urban Company.

Urban Company is a trademark of its respective owner.

## Author

**Habib Gheta**

Diploma in Information Technology

Built using Flutter, Firebase and Cloudinary.
