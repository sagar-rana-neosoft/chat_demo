Chat Demo
This project is a real-time chat application built with Flutter. It demonstrates a clean architecture approach by separating the application into data, domain, and presentation layers. It handles user authentication, real-time messaging, and profile management.

Tech Stack
This application is built using a modern and scalable technology stack.

Flutter SDK
The project uses Flutter for cross-platform mobile development.

Version: 3.35.4

State Management
The app's state is managed using the BLoC (Business Logic Component) pattern, with the flutter_bloc package. This architecture helps to decouple the UI from the business logic, making the code more testable and maintainable.

Routing
GoRouter is used for declarative navigation. It simplifies routing by allowing you to define a clear, hierarchical routing tree.

Connectivity
The app is designed to handle network connectivity gracefully. It checks for a connection and manages state accordingly, ensuring a smooth user experience even when the internet is unavailable.

Limitations
Due to the free tier limitations of Firebase, specifically Firebase Storage, the profile picture upload feature is not currently implemented. Adding this functionality would require a premium plan for image storage.