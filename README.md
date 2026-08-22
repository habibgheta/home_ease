# HomeEase

HomeEase is a Flutter-based home service booking application that helps users find and book professionals for common household services such as electricians, plumbers, carpenters, painters and cleaners.

The idea behind HomeEase is similar to the concept used by Urban Company, where customers can browse different home services, find suitable professionals and book a service according to their requirements. People can also register themselves as Service Providers to provide professional services to Home-Owners.

>HomeEase is an independent project inspired by the home-service marketplace concept of Urban Company. It is not an official Urban Company application or a direct clone of Urban Company.

This project is developed by<b> Habib Gheta </b>as part of Industrial Training (Internship) @NASTECH to gain practical experience in Flutter, Firebase, Cloud Firestore, Cloudinary, authentication, database management and responsive application development.

## Tech Stack

### Frontend

- Flutter
- Dart

### Backend and Services

- Firebase Authentication
- Cloud Firestore
- Cloudinary

### Development Tools

- Android Studio
- Git
- GitHub

## Features

### User Authentication

- User Registration
- Firebase Email/Password Authentication
- Forgot password functionality
- Password reset through email
- Password visibility toggle
- Email and password validation
- Duplicate email detection
- Error handling with SnackBars
- Logout with alert dialog confirmation

### Service Provider Authentication

- Separate registration option for service providers
- Service provider login
- Employee code for service provider identification
- Service provider profile picture upload
- Password visibility toggle
- Email and password validation
- Logout functionality

### User Profile

- Edit profile information
- Upload profile picture from device gallery
- Store profile images using Cloudinary

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
- Provider rating
- Provider hourly charges
- Admin can add, edit, delete and manage service providers
- Admin can manage provider availability and status
- Service providers can register their own accounts
- Service providers can log in to their accounts
- Service providers can view their bookings
- Service providers can accept/reject user bookings
- Booking status is updated after provider action

### Favorites

- Add/Remove service providers to favorites
- View favorite providers
- Favorites are stored separately for each user
- Favorite status is maintained using Cloud Firestore

### Service Booking

- Select a service provider
- Select a service
- Select date
- Select available time slot
- Book a service
- New bookings start with "Pending" status
- View booking history
- View booking details
- Cancel bookings
- Users cannot cancel rejected bookings
- Prevent unavailable or booked time slots from being selected
- Store bookings in Cloud Firestore
- Booking status can be Pending, Accepted or Rejected
- Service providers can accept or reject bookings
- Admin can manage booking status
- Newest bookings are displayed first
- Different colors are used for different booking statuses

### Settings

- Light theme
- Dark theme
- Theme switching
- Theme preference is saved
- Selected theme is restored when the application is opened again

### Admin Panel

The application includes a separate admin panel for performing CRUD operations on the application's data.

#### Categories

- View categories
- Add categories
- Edit categories
- Delete categories

#### Service Providers

- Create, Read, Update and Delete (CRUD) service providers
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
- Accept/Reject bookings
- View pending, accepted and rejected bookings
- Newest bookings are displayed first

### Admin Panel UI

- Separate admin dashboard
- Categories section
- Service Providers section
- Users section
- Bookings section
- Responsive admin layout
- Single-column layout on mobile and tablet
- Two-column layout on desktop
- Dark and light theme support
- Admin logout

## Additional Features

- Splash screen with HomeEase branding
- Authentication-based navigation after splash screen 
  - Automatic redirection of normal users to the Home screen
  - Automatic redirection of admin to the Admin Panel
- Auto-login feature (i.e. If a user was logged-in the app when they closed the application, they will remain logged-in the next time they open the application)
- Responsive layouts for different screen sizes
- Light and Dark theme support throughout the application
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
        provider/
        settings/
        splash/
    services/
    theme/
    utils/
    widgets/
```

## Firebase

Firebase is used as Backend-as-a-Service (BAAS).

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

Cloudinary is used to store profile images uploaded by users, service providers and admins.

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

The current version includes user authentication, service categories, service providers, favorites, service booking, profile management, theme switching and a complete admin panel integrated with Firebase and Cloudinary.

## Future Improvements

The following features can be considered for future versions:

- Online payment integration
- Improved admin analytics

## Urban Company Inspiration

HomeEase is based on the same general concept as home-service platforms such as Urban Company.

The application allows users to browse home services, view professionals and book services according to their requirements.

HomeEase is not an official Urban Company application and is not a direct clone of Urban Company. It is an independently developed educational project inspired by the same home-service booking concept.

## Disclaimer

HomeEase is an independent educational project developed as part of Industrial Training (Internship) @NASTECH

The project is not affiliated with, sponsored by, or endorsed by Urban Company.

Urban Company is a trademark of its respective owner.

## Author

**Gheta Habib Ismail**

Diploma in Information Technology

Intern @NASTECH

Built using Flutter, Firebase and Cloudinary.
