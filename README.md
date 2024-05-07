
# CineMerge

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

An app where a user can create a folder based on movie genre, favorite actor/actress and can add movies from different streaming services into one folder. Users can also collabrate with friends or the public to put a list for a movie night or movie suggestions in general

### App Evaluation

- **Category:** Entertainment
- **Mobile**: An app makes it easier to share a movie straight from streaming apps without needing to copy link and putting back to the website
- **Story**: Allows for users to create a watch list from multiple movie subsctiptions and share with friends to collabreate and grow the list
- **Market**: Anyone who watchs movies and needs suggestions can share what they want on the folder and even put in reddit threads, group chats to get suggestions from the public
- **Habit**:  User or invited users add movies they are interested in watching then can later check off the movie they watched
- **Scope**: First start off with a offline version where only users can add movies and is saved to their device but later add a database and accounts so that collabration is possible for second version of the app

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User must be able to create Folders
* User must be able to add movie links, title and description
* User must be able to click on movies then watch the movie directly on the streaming app

**Optional Nice-to-have Stories**

* User can create account
* User can generate a unqiue link for each folder to share
* User can give edit access to public so public can add movies
* User can change folder icon/color

### 2. Screen Archetypes

- [X] Home Screen
* User can see all the folders they have created
* User can click on a folder to see the movies in the folder
* User can add a new folder
* User can delete a folder

- [X] Folder Screen
* User can see all the movies in the folder
* User can add a new movie to the folder
* User can delete a movie
* User can click on a movie to see the movie screen


- [X] Movie Screen
* User can see the movie thumbnail
* User can see the movie title
* User can see the movie description
* User can click on the movie to watch the movie
* User can delete the movie from the folder

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home  
* Settings 
* Add Folder 

**Flow Navigation** (Screen to Screen)

- [X] Home Screen
* => Folder Screen
* => Add Folder Screen

- [X] Folder Screen
* => Movie Screen
* => Add Movie Screen

- [X] Movie Screen
* => Watch Movie Screen

- [X] Add Folder Screen
* => Home Screen

- [X] Add Movie Screen
* => Folder Screen

- [X] Settings Screen
* => Home Screen


## Wireframes

#### Picture View
<img src="wireframes/wireframe.jpeg" width=600>

<img src="wireframes/wireframe.gif" width=600>

### Sprints

- [X] **Sprint 1** - Setup the project and create the basic UI(tab bar and navigation controllers, app icon)
- [X] **Sprint 2** - Start connecting each pages with each other
- [X] **Sprint 3** - Create a backend service to fetch movie data(Movie Title, Movie Icon and Movie Description) and save it to the local storage
- [X] **Sprint 4** - Connect each movie to a streaming service to watch the movie


### Reflection
I am getting humbled by Xcode right now every little thing I have learned is getting tested and I ahve been going through the units to remember what I forgot when something breaks hopefully I can get this app to work by the end of the sprints

### Sprint 1 App Demo

<div>
    <a href="https://www.loom.com/share/f08d80ac971e4ea79832e7e23fb03af7">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/f08d80ac971e4ea79832e7e23fb03af7-with-play.gif">
    </a>
</div>

### Sprint 2 App Demo
I currently have a problem where my folder data doesn't show up and rather fails and it was working before so I am trying to figure out what went wrong. If I figure that out I don't need placeholders for the folders and movies but rather the actual data

<div>
    <a href="https://www.loom.com/share/47ba6c06aeca4e618e8e04b254631a8d">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/47ba6c06aeca4e618e8e04b254631a8d-with-play.gif">
    </a>
  </div>

### Sprint 3 and 4 App Demo
I finished the app and also built a backend service using flask to get data from the server and save it to the local storage. I also connected the movies to a streaming service to watch the movie.
<div>
    <a href="https://www.loom.com/share/6bb778b9eb89421c97119ab913fcda35">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6bb778b9eb89421c97119ab913fcda35-with-play.gif">
    </a>
</div>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

#### Figma Design
<iframe style="border: 1px solid rgba(0, 0, 0, 0.1);" width="800" height="450" src="https://www.figma.com/embed?embed_host=share&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FjmdVcogrCFzzN7xKC7mO1y%2FMovie-Mobile-App-UI-Design-(Community)%3Ftype%3Ddesign%26node-id%3D0%253A1%26mode%3Ddesign%26t%3DjLQngppAycsAlZcE-1" allowfullscreen></iframe>

<a href="https://www.figma.com/file/jmdVcogrCFzzN7xKC7mO1y/Movie-Mobile-App-UI-Design-(Community)?type=design&node-id=0%3A1&mode=design&t=jLQngppAycsAlZcE-1">Figma Link</a>


### Schema
#### Folders
| Property    | Type     | Description                   |
|-------------|----------|-------------------------------|
| folderName  | String   | Name of the folder            |
| folderImage | File     | Image for the folder          |
| folderColor | String   | Color for the folder          |
| folderID    | String   | Unique identifier for the folder |

#### Movies
| Property    | Type     | Description                   |
|-------------|----------|-------------------------------|
| movieName   | String   | Name of the movie             |
| movieImage  | File     | Image for the movie           |
| movieID     | String   | Unique identifier for the movie|
| folderID    | Pointer to Folder | Foreign key referencing the folder |
| movieLink   | String   | Link to watch the movie        |

### Models

[Add table of models]

### Networking

- [Add list of network requests by screen ]
<br>
Does a api request to get the movie data from flask server 
Flask requests supabase to get the movie data

- [Create basic snippets for each Parse network request]
#### Get Folders
```swift 
let query = PFQuery(className:"Folders")
query.whereKey("folderID", equalTo: currentUser)
query.findObjectsInBackground { (folders: [PFObject]?, error: Error?) in
   if let error = error { 
      print(error.localizedDescription)
   } else if let folders = folders {
      print("Successfully retrieved \(folders.count) folders.")
```

- [OPTIONAL: List endpoints if using existing API such as Yelp]
localhost:5000/getFolders
localhost:5000/getMovies
localhost:5000/addFolder
localhost:5000/addMovie
localhost:5000/getMovieDetailed
