# Lab 3 - *Flix Part 3*

**Flix Part 3** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **11** hours spent in total

## User Stories

The following **required** user stories are complete:

- The following screens use AutoLayout to adapt to various orientations and screen sizes
- [x] Movie feed view (+3pt)
- [x] Detail view (+2pt)

The following **stretch** user stories are implemented:

- [ ] Dynamic Height Cells (+1)
- [ ] Collection View AutoLayout (+2)

The following **additional** user stories are implemented:

- [x] Added segue from Superhero Collection View Controller to Details View Controller
- [x] Added UIAlertController when a network connection cannot be established (stretch story for Assignment 1)
- [x] Added UISearchBar to the SuperHero Collection View Controller
- [x] Added Infinite Scroll for the Superhero Collection View Controller with handling error for no network connection and end of page
- [x] Added Trailer View Controller that shows the movie trailer. If not movie trailer than it links to YouTube (will fix in futre to an UIAlertController

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I think the logic behind the Infinite scroll is extremely interesting, and I had a lot of fun working on that part
2. I spent about 2.5 hours trying to update my file names from FlixPart1Assignment1 (which I thought was a crappy name) to FlixMovieApp. I think we should've been told if we would be using the same repository again.
3. You also have to create exception error handling when the API gives you a null value for the background image (Ex. Avengers: Infinite Wars)

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

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
