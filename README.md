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

Architecture
This project uses a Clean Architecture approach, organizing the code into three distinct layers: Presentation, Domain, and Data. This separation of concerns ensures that the business logic remains independent of any frameworks, databases, or user interfaces.

1. Domain Layer
   The Domain layer is the heart of the application. It contains the core business logic and is completely independent of other layers. It's the most stable part of the architecture and doesn't depend on the Presentation or Data layers.
    
    Entities: These are the core business objects. They are simple classes representing the data in its pure form, without any framework-specific annotations or methods.
    UserEntity: Represents a user with properties like uid, email, and display name.
    MessageEntity: Represents a chat message with properties like senderId, receiverId, messageContent, and timestamp.
    Repositories: These are abstract interfaces that define the contract for how data will be accessed. The implementation of these interfaces resides in the Data layer. This allows the Domain layer to specify what data it needs without knowing how that data is retrieved.
    AuthRepository: Defines methods for user authentication (e.g., signIn, signUp, signOut).
    ChatRepository: Defines methods for chat operations (e.g., sendMessage, getMessages, getUsers).
    Use Cases (Interactors): These classes contain the specific business logic for a single task. They orchestrate the flow of data using the repositories to achieve a specific goal. They serve as the entry points for the Presentation layer.
    LoginUser: Handles the logic for a user signing in.
    SendMessageUseCase: Manages the process of sending a chat message.
    GetMessagesStreamUseCase: Fetches a stream of messages for a chat room.


2.  Data Layer
    The Data layer is responsible for retrieving data from external sources and implementing the repository interfaces defined in the Domain layer. It's the most volatile part of the architecture.
    
    Data Sources: These classes are responsible for communication with specific data sources, like a remote server (e.g., Firebase) or a local database. They retrieve raw data.
    Models: These are data transfer objects (DTOs) that represent the raw data received from the data sources. They are often mapped to Entities before being passed up to the Domain layer.
    UserModel: Represents user data as it's stored in Firebase.
    MessageModel: Represents message data as it's stored in Firestore.
    Repositories: These classes implement the abstract repository interfaces from the Domain layer. They coordinate data retrieval from one or more data sources and perform the mapping from Models to Entities.
    AuthRepositoryImpl: Implements AuthRepository.
    ChatRepositoryImpl: Implements ChatRepository.

3.  Presentation Layer
    The Presentation layer is the user interface of the application. It handles UI logic and state changes, using the Domain layer to perform actions.
    
    Cubit: Manages the UI state. It calls Use Cases from the Domain layer and updates the UI based on the results. 
    Pages (UI Components): The widgets and screens that display the UI, listening to state changes from the Cubit and triggering user-driven events.
    State: The Presentation layer uses specific classes to represent the different states of a screen. For example, a chat list screen can have the following states:
    ChatListInitial: The initial state before any data has been loaded.
    ChatListLoading: Indicates that data is being fetched.
    ChatListLoaded: The state when the data has been successfully retrieved. It holds the list of ChatListEntity objects to display.
    ChatListEmpty: The state when the data has been loaded, but there are no items.
    ChatListError: The state when an error occurred during data fetching, holding an error message.