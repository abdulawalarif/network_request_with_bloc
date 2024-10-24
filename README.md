
# Network Request with Bloc

## This Flutter and Dart project demonstrates how to send network requests using the Bloc library. Here I fetched data from two different API endpoints and displays is on a list, This stracture also optimized performance through caching to prevent double network call.

**The project provides a solid foundation for developers looking to implement network-based features in their applications using Flutter’s Bloc architecture. It includes features like data loading from multiple sources, caching of responses, and efficient UI updates when data changes.**

## Features
* **Data Fetching with Bloc:** The app loads data from APIs, showcasing how to integrate network requests within the Bloc architecture for state management.
* **Caching Mechanism:** Caching is used to store the fetched data, ensuring that subsequent requests for the same data are served from memory, avoiding additional network calls and improving performance.
* **Dynamic Data Sources:** You can switch between two JSON endpoints by interacting with the app, demonstrating how multiple APIs can be handled within the same Bloc.
* **Real-Time UI Updates:** As the data is fetched and processed, the UI is updated in real-time to display the list of persons (name and age) in a clean, simple interface.

## File stracture

    
    ├── lib
    │   ├── bloc  
    │   │  ├── bloc_actions # Actions are sent from the UI 
    │   │  ├── posts_bloc  # Produce result for Posts to UI
    │   │  ├── users_bloc  # result for users
    │   │── models
    │   │   ├── post_model
    │   │   ├── user_model
    │   ├── main.dart                  
     
 

  


## Run Locally

Clone the project

```bash
  git clone https://github.com/abdulawalarif/network_request_with_bloc.git
```

Go to the project directory

```bash
  cd network_request_with_bloc
```

Install dependencies

```bash
  flutter pub get
```

Connect a physical device or start a virtual device on your machine

```bash
  flutter run
```



## How to tweak this project for your own uses
* **Change the API URLs:** Replace the example API endpoints (loadAllUsers, loadAllPosts) with your own REST API or local JSON files.

* **Modify the Data Model:** If your API returns a different structure, adjust the Person class to correctly parse your JSON responses.
* **Enhance the UI:** You can improve the UI by adding more fields to display or by using custom widgets to make the app more visually appealing.

* **Expand the Caching Strategy:** The caching mechanism in the PersonsBloc could be enhanced by adding expiration times, offline storage, or more complex caching strategies for larger datasets.

 

## Reporting Bugs or Requesting Features?

If you found an issue or would like to submit an improvement to this project,
please submit an issue using the issues tab above. If you would like to submit a PR with a fix, reference the issue you created!

##  Known Issues and Future Work
* **Lazy Loading:** Future improvements could include adding lazy loading to handle larger datasets more efficiently without freezing the UI.
* **Advanced Caching:** While the current caching mechanism works for small datasets, it can be expanded for more complex use cases, such as persisting data locally or handling cache expiration.
* **Improved Error Handling:** The current implementation focuses on successful responses. Implementing comprehensive error handling for failed network requests would make the app more robust.


## Author

- [@abdulawalarif](https://github.com/abdulawalarif)
  
## License

[MIT](https://choosealicense.com/licenses/mit/)



 
