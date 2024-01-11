# iOS Assessment Project - InTalenta.id

## Overview
Welcome to the iOS Assessment Project for InTalenta. This take-home test is designed to evaluate your iOS development skills, particularly in UIKit and composable architecture. Please follow the instructions provided below to complete the assessment.

## Project Requirements
The app must have following screens (three screens in total):
1. List of Animals
- Shows a list of the following animals: Elephant, Lion, Fox, Dog, Shark, Turtle, Whale, Penguin
- Navigates to screen 2 when the user taps any of the animals.
- This screen also has a “favorites” button that navigates to screen 3.
2. Animal Pictures
- Shows all the available pictures of a given animal.
- Allows users to like/unlike specific images by tapping the image or a favorite button.
3. Favorite Pictures
- Shows the images that the user liked.
- Shows which animal a particular image belongs to
- Allows users to filter images by selecting an animal.


## Architecture
This project utilizes a composable architecture to enhance code organization and maintainability. Ensure that your code adheres to the principles of composable architecture, separating concerns and promoting code reusability.

## Dependencies
The project relies on the following third-party libraries:

- SnapKit: Used for UI constraints to simplify the layout code.
- Netfox: Enables network tracking for debugging purposes.
- FittedSheets: Implements a bottom sheet component for a seamless user experience.
- Kingfisher: Utilized for fetching and caching images from the server.
Ensure that you integrate these dependencies correctly in your project.

## Preview

<details>
     
<summary>iPhone 15, iOS 17</summary>

![iOS](./preview.gif)

</details>
