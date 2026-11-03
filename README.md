# Stock Inventory Manager (lab exam I26042572 Toshani Barama)

## 1. Features

- Add new stock items.
- Store inventory records in Firebase Cloud Firestore.
- Retrieve and display saved stock items.
- Search by SKU or item name.
- Filter items by category.
- Identify low-stock items.
- Sort inventory by quantity in ascending or descending order.
- Clear filters to display all inventory records.
- Validate user input before saving.

## 2. Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Application development |
| Dart | Programming language |
| Firebase Core | Firebase connection |
| Cloud Firestore | Inventory database |
| Android Studio | Development environment |
| GitHub | Source code and documentation |

## 3. Installation and Setup

1. Install Flutter and Android Studio.
2. Clone or download this GitHub repository.
3. Open the project in Android Studio.
4. Open the terminal in the project directory.
5. Install the required dependencies:

```bash
flutter pub get
```

6. Configure Firebase by following the instructions below.
7. Run the application:

```bash
flutter run
```

## 4. Firebase Configuration

This project uses Firebase Cloud Firestore to store and retrieve inventory records.

For security reasons, Firebase configuration files are not included in this GitHub repository.

To connect the application to your own Firebase project:

1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Enable Cloud Firestore.
3. Install the Firebase CLI and FlutterFire CLI.
4. Log in to Firebase:

```bash
firebase login
```

5. Configure Firebase for the Flutter project:

```bash
flutterfire configure
```

6. Select your Firebase project and the required platforms.
7. Run:

```bash
flutter pub get
```

The generated `firebase_options.dart` file should remain local and should not be uploaded to GitHub.

## 5. Firestore Database Structure

**Collection:** `stockItems`

Each inventory document contains the following fields:

| Field | Data Type | Description |
|---|---|---|
| sku | String | Unique stock identifier |
| itemName | String | Name of the stock item |
| category | String | Item category |
| quantity | Integer | Available stock quantity |
| unitPrice | Number | Price per unit |
| reorderLevel | Integer | Minimum stock threshold |
| createdAt | Timestamp | Record creation time |

<img width="634" height="533" alt="image" src="https://github.com/user-attachments/assets/513fce30-ff93-428e-935a-d17e2f351aa3" />

<img width="536" height="497" alt="image" src="https://github.com/user-attachments/assets/3becff37-c320-4daa-ab7c-28cb6a2ccae1" />


## 6. Sample Inventory Records

| SKU | Item Name | Category | Quantity | Unit Price | Reorder Level |
|---|---|---|---:|---:|---:|
| STK-101 | USB C Cable | Electronics | 4 | RM19.90 | 5 |
| STK-102 | Notebook | Stationery | 25 | RM4.50 | 10 |
| STK-103 | Wireless Mouse | Electronics | 1 | RM35.00 | 3 |

<img width="629" height="690" alt="image" src="https://github.com/user-attachments/assets/38cec42c-085f-4717-8a5d-4ee818670a9b" />

## 7. Input Validation

The stock entry form validates the following information before saving:

- SKU must follow the format `STK-101`.
- Item name must contain at least three characters.
- Category must be selected.
- Quantity must be a non-negative integer.
- Unit price must be a valid number greater than zero.
- Reorder level must be a non-negative integer.

Invalid entries are rejected and an appropriate validation message is displayed.

<img width="526" height="594" alt="image" src="https://github.com/user-attachments/assets/cef9e2e7-5a9c-4970-8f49-c0bfdad3e257" />

<img width="482" height="398" alt="image" src="https://github.com/user-attachments/assets/a6a95632-08f3-4b36-81b5-b0a0dda8e3f5" />

<img width="500" height="206" alt="image" src="https://github.com/user-attachments/assets/59d691b9-acb3-4cec-b5dd-e7efe94f7e64" />


## 8. Search and Filtering

The application provides the following inventory search functions:

- **Keyword Search:** Searches partially and without case sensitivity across SKU and item name.
- **Category Filter:** Displays items belonging to a selected category.
- **Low Stock Filter:** Displays items where quantity is less than or equal to the reorder level.
- **Combined Filters:** Applies multiple selected filters together.
- **Quantity Sorting:** Sorts inventory by quantity in ascending or descending order.
- **Clear Filters:** Resets the search and filtering options.

## 9. Testing

The following test cases are used to verify the application's functionality:

| Test Case | Expected Result |
|---|---|
| Add a valid stock item | Item is saved successfully |
| Enter an invalid SKU | Validation error is displayed |
| Search for `mouse` | Wireless Mouse is displayed |
| Search for `STK-102` | Notebook is displayed |
| Filter by Electronics | Electronics items are displayed |
| Apply Low Stock filter | Items below or equal to reorder level are displayed |
| Sort by ascending quantity | Items are sorted from lowest to highest |
| Clear filters | All inventory records are displayed |

<img width="632" height="494" alt="image" src="https://github.com/user-attachments/assets/c6e217aa-350a-458d-88f2-bbd35373cc12" />

<img width="632" height="448" alt="image" src="https://github.com/user-attachments/assets/4db4e0a1-f726-4c8a-8609-63a359a8bbee" />

<img width="629" height="629" alt="image" src="https://github.com/user-attachments/assets/090ae78d-dfb6-4e02-98ee-47c8b783e90b" />

<img width="620" height="635" alt="image" src="https://github.com/user-attachments/assets/09bd6f5d-4850-4fa3-badf-2fd46f275ba6" />

<img width="623" height="599" alt="image" src="https://github.com/user-attachments/assets/7557d657-1240-42f7-9245-e0e53d63fe97" />

