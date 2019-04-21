# MovieSearch
===============
Project is to let the user search for a movie query text and get the list of movies along with its title, overview, posterImagePath and other metadata.


Coding language
===============
Swift 4.2


APIs used for fetching image data
=================================
The data is fetched asynchronously using URLSession apis.
NSCache for Image caching. 
JsonDecoder for decoding the data.
DataModels were 'Decodable'.
SearchController for searchbar.


Built with
==========
Xcode 10.0, deployment target iOS 12.0


Features
========
Following are the features that were implemented:

1. Present a search bar using UISearchController to let user enter the search query for movies. Upon entering search query, app fetches the data from the movie database (TMDb) and presents a list of search results.
2. Each item in the search result, displays posterImage, title and overview.
3. Implemented pagination using infinite scrolling for the list table view as this gives user a seamless experience.
5. App also checks if we have reached the maximum pages for the given search query and does not query for any further pages. No hardcoded limit for the pages was assumed. Instead computed this limit based on the response.
6. Upon entering another search the results table refreshes.
7. Used Grand central discpatch for multi threading. Ensuring that the UI related tasks are performed on the main thread.
8. Ensured that the logging is only used in DEBUG scheme and not for RELEASE, by creating a logger utility.
9. Provided localization for English language.
10. Used MVVM-C design pattern.
11. Used storyboards for UI and Autolayouts for laying UI elements.
12. Added test cases for the view model to test the core business logic.
13. Also, handled the error scenarios for when user enters a query that is invalid and generates no search results.
14. If no posterImage is returned by the service then displaying a placeholder image.


App architecture:
================
1. App has been designed to use MVVM-C design pattern. The reason for going with this over MVC is that it helps compartmentalize the code to have all the business logic in view models and UI presentation in the views and view controllers.
2. Used infinite scrolling for pagination as opposed to user manually tapping a button to load more data as the former provides a better and more seamless user experience.
3. Used various extensions to make few commonly used functions more reusable.
4. Provided localization, logging and unit test support.
5. Used Multi threading using Grand Central Dispatch.
6. Used Autolayouts for laying the UI elements.
7. Used Image caching using NSCache.
8. Used JsonDecoder to decode the response. Data Models were 'Decodable'. This is preferred over JSONSerialization.
9. Although not asked for, implemented pagination and used Infinite scrolling for the UITableview.


What would I have done additional, if had more time, towards appstore submission of this app:
============================================================================================

1. Would have supported list as well as grid view for the movie results.
2. Would have provided an ability to filter the results based on some criteria such as language, popularity etc.
3. Upon tapping the items in list or grid would have shown the detailed screen with more details from the service.
4. Added more unit tests around the view model to test for negative scenarios.
5. Need to test the app under low memory conditions, profiling, checking for leaks etc.
6. In an ideal corporate scenario before the app is submitted to the appstore it goes through QA testing (manual and automatic), various static scans and penetration testing etc.
7. Tested the app using Apple’s Network Link Conditioner.


Reference
============ 
Apple documentation and TMDb apis.


Unit Tests
==========
Added the basic unit testing target. Implemented unit tests for the view model. Would have done more negative unit test cases, if had more time.

--------------------
Lopa Dharamshi (Mota)