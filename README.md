# Book Management/Library App - Online Version

This project contains a mobile aggregation application specifically for managing read books. It allows adding book entries to its database, opening them in a separate menu and modifying their entries in the application display. The application has a Material user interface, and it is written in Dart, using the Flutter open source framework.

In this iteration of the project, the data is saved both locally and on a server. The server utilized by the application is a simple Node.js webserver, with persistent storage capabilities and CRUD endpoints. In terms of data consistency scenarios, creating an entry in the application stores it to the local database immediately, as well as uploads it to the server. Updating a book's information also prompts the application to echo the changes to the DB and the server. Deletion wipes the data from the server and flags the entry as deleted in the local database.

Offline scenarios:

- Offline access permits the user to view locally stored/cached books as normal. 
- Creating a book offline locally stores it in the database and flags it as "meant for upload" so that the next time the device connects to the internet, it gets pushed to the server. 
- A similar protocol is followed for the updating of data in an entry. 
- Deletion of a locally stored entry flags it for deletion on the client-side, and when the device reconnects to the internet, it signals the server to follow its deletion protocol and removes the data from the local DB.
