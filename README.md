# Pokémon Guessing Game

A small Flutter app where players guess Pokémon based on images.

## Overview
This is a simple Pokémon guessing game built with Flutter. Currently, the app does not use any state management, but in the future, **Cubit** will be implemented for state management to handle game logic and UI updates more efficiently.

## Features
- Guess Pokémon based on provided clues or visuals.
- **Leaderboard Screen**: Displays player rankings stored in **Firestore**.
- **Sign-In**: Supports **Google Sign-In** using **Firebase Authentication**.
- Simple and lightweight app structure.

## Future Improvements
- Add a proper data model for Pokémon to manage attributes like name, type, and other details.
- Implement **Cubit** for robust state management.
- Extend Firebase support to **Android** (currently implemented only for **iOS**).

## Notes
- The app is in early development and will be expanded with more features and optimizations in the future.
- Firebase (Firestore and Authentication) is currently set up for iOS only. Android support can be added if needed.
