# Full-Stack Shopping Application Based on Website and iOS Systmem

## Overview

This project is an advanced web application designed for product search, leveraging the eBay API to display search results, details, and similar product suggestions. It incorporates user interaction features such as product wishlisting and sharing on Facebook account.

## Websites Developemnt

### Access To Frontend

[Angular Frontend](https://hw3frontend-1234.wl.r.appspot.com/)

### Construction Flow

- **Search Form:** Users can search for products using specific criteria (keyword, category, etc.). The form includes autocomplete for ease of use and validation to ensure accurate input.
  [Search Form Video Demo](https://youtu.be/tyfPb0dayXg)
- **Results Display:** Search results are shown in a tabular format with pagination. Each listing provides key details and allows adding to a wishlist.
  [Result Display Video Demo](https://youtu.be/hxbDFvQR8R8)
- **Product Details:** Clicking on a product name opens a detailed view with tabs for info, photos, shipping details, seller info, and similar products.
  [Product Details Video Demo](https://youtu.be/vMMQgeFViEE)
- **Wishlist Management:** Users can add or remove products from their wishlist, which is stored in MongoDB.
  [Wishlist Management Video Demo](https://youtu.be/bKlWzZfUPjI)
- **Responsive Design:** The application is fully responsive on iPhone 12 Pro, ensuring a seamless experience across devices.
  [Resopnsive Desgin Video Demo](https://youtu.be/ARdcNyBGicI)

### Technology Stack

- **Frontend:**

  - **Angular** for dynamic content rendering
  - **Bootstrap** for responsive design, and Angular Material for UI components.

- **Backend:**

  - **Node.js** with Express framework for server-side logic.

- **Database:**

  - **MongoDB** for storing user wishlists.

- **APIs:**

  - **eBay API** for product search and details
  - **Google Customized Search API** for additional product photos
  - **Geonames API** for location autocomplete.

- **Deployment:** Deployed on cloud platform：**Google Cloud Platform**

### Technical Highlights

- **Angular & RxJS**: Employs Angular for a dynamic UI and RxJS for managing async data flow and event handling, enhancing UX with features like autocomplete to minimize API calls.

- **RESTful Communication:** Utilizes Angular's HttpClient for efficient data exchange with the backend, showcasing RESTful API integration for seamless JSON data handling.

- **Responsive Design:** Achieved through Angular Material or custom CSS, ensuring the app is fully responsive across various devices and screen sizes.

- **API Integration:** Incorporates multiple external APIs (e.g., eBay, Google Customized Search, Geonames) for advanced data fetching and manipulation, enriching user experience.

- **MongoDB & Cloud Deployment:** Demonstrates MongoDB usage for CRUD operations and cloud deployment on platforms like GCP, AWS, or Azure, highlighting the app's scalability and global reach.

## iOS Application Development

### Overview

Developed using Swift and SwiftUI, this section of the project extends the product search functionality to iOS devices(Build and Test Based on **iPhone 15 pro** and **iOS 17**), offering a native app experience with product search, details, wishlist, and social sharing features.

### Features

- **Product Search:** Search for eBay products using various filters. [Search Form Display Demo](https://youtu.be/ypxiSsGb-mY)

- **Product Details:** View detailed information, including images and seller details. [Product Details Display Demo](https://youtu.be/dbMUdh8KUVU)

- **Wishlist:** Add or remove products from a wishlist. [Wishlist Display Demo](https://youtu.be/buIPIEVuzpA)

- **Social Sharing:** Share product details on social media. [Social Media Sharing Display Demo](https://youtu.be/RoAiVCkbitE)

### Technology Stack

- **SwiftUI** for UI development

- **Swift** for application logic

- eBay API for product data

- **MongoDB** for wishlist management

### Technical Highlights

- **SwiftUI and Swift**: Utilizes modern Swift features and SwiftUI for building a responsive and intuitive UI, emphasizing clean code architecture and efficient data handling.

- **API Integration:** Demonstrates the application's complex data fetching and manipulation capabilities by integrating with multiple external APIs, including eBay for product searches and details, enhancing the user experience with rich content.

- **Alamofire:** Employs Alamofire for network requests, streamlining HTTP communication, JSON data handling, and response validation, showcasing advanced networking practices within the Swift ecosystem.

- **MongoDB Integration:** Manages user wishlists, highlighting the app's capability to perform CRUD operations with MongoDB, demonstrating backend integration and data persistence.

- **Cloud Deployment:** The application's backend deployment on Google Cloud Platform highlights its scalability, reliability, and global accessibility, ensuring a robust infrastructure.

### Prerequisites

- Xcode 15.0.1 or later
- macOS Sonoma for development
- An eBay developer account for API access
- Installation of required libraries like Alamofire, Kingfisher, PromiseKit, and SwiftyJSON for network requests and JSON handling.

### Installation

1. Clone the repository to your local machine

2. Open the project in Xcode.

3. Install the required libraries via Swift Package Manager.

4. Build and run the app on an iOS simulator or physical device.
