# Flutter E-Commerce App with Firebase Analytics SDK

A mobile e-commerce demo app built with Flutter and Firebase Analytics. This project demonstrates mobile SDK setup, custom event logging, e-commerce funnel tracking, and analytics implementation for a shopping app experience.

## Project Overview

Mini Shop is a Flutter shopping app designed to showcase how user interactions can be tracked through Firebase Analytics. The app includes a basic e-commerce flow from login to product browsing, cart activity, checkout, and purchase completion.

This project was created as a portfolio piece to demonstrate experience with:

- Flutter mobile development
- Firebase SDK implementation
- Event tracking
- E-commerce analytics
- User journey tracking
- Analytics debugging and documentation

## Features

- Login and sign-up demo screen
- Product listing screen
- Product detail screen
- Add-to-cart functionality
- Cart screen with subtotal calculation
- Checkout success screen
- Firebase Analytics integration
- E-commerce funnel event tracking

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Analytics
- Android SDK
- Git/GitHub

## Analytics Events Implemented

| User Action | Firebase Analytics Event |
|---|---|
| User logs in | `login` |
| User creates account | `sign_up` |
| User views home screen | `screen_view` |
| User opens product details | `view_item` |
| User adds product to cart | `add_to_cart` |
| User begins checkout | `begin_checkout` |
| User completes purchase | `purchase` |

## E-Commerce Funnel

The app tracks a simple shopping journey:

```text
Login / Sign Up
↓
View Product List
↓
View Product Detail
↓
Add to Cart
↓
Begin Checkout
↓
Purchase Complete