# *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User sees app icon in home screen and styled launch screen (+1pt)
- [x] User can scroll through a list of movies currently playing in theaters from The Movie DB API (+5pt)
- [x] User can "Pull to refresh" the movie list (+2pt)
- [x] User sees a loading state while waiting for the movies to load (+2pt)
- [x] User can tap a cell to see a detail view (+5pts)
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView (+5pts)
- [x] Constraints (+3pt)

The following **stretch** user stories are implemented:

- [x] User sees an alert when there's a networking error (+1pt)
- [ ] While poster is being fetched, user see's a placeholder image (+1pt)
- [ ] User sees image transition for images coming from network, not when it is loaded from cache (+1pt)
- [ ] Customize the selection effect of the cell (+1pt)
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete (+2pt)
- [x] Dynamic Height Cells (+1)
- [x] Collection View AutoLayout (+2)
- [x] Create a movie model (+2pt)
- [x] Implement the movie model (+2pt)
- [x] Implement property observers (+2pt)
- [x] Create a basic API Client (+2pt)

The following **additional** user stories are implemented:

- [x] Added segue from Superhero Collection View Controller to Details View Controller
- [x] Added UIAlertController when a network connection cannot be established (stretch story for Assignment 1)
- [x] Added UISearchBar to the SuperHero Collection View Controller
- [x] Added Infinite Scroll for the Superhero Collection View Controller with handling error for no network connection and end of page
- [x] Added UIButton that shows the user a movie trailer for the movie. If no movie trailer, then Youtube.com is presented (will change later to an UIAlertController)

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src="http://recordit.co/OaGjoEneyi" width=250><br>

## Notes

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

- Handling an out of index page number when retrieving movies for the SuperHero Collection View
- Had some trouble debugging the infinite scroll loading animation when faced with no network connection

## License

Copyright [2018] [Henry Vuong]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
