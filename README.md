# Galerix

A gallery app in flutter that consumes the Unsplash API.

## Getting Started

### VS Code

If you are on VSCode run the app by pressing F5

### Andorid Studio or IntelliJ

If you are on Android Studio or IntelliJ, In the target selector, select an Android device for running the app. If none are listed as available, select Tools > AVD Manager and create one there then Click the run icon in the toolbar, or invoke the menu item Run > Run.

### Terminal

First open the project folder

`cd galerix`

Check that an Android device is running. If none are shown, follow the device-specific instructions on the Install page for your OS.

`flutter devices`

Run the app with the following command:

`flutter run`

## State Mangement

After analyzing between using Redux or Provider both have their pros and cons but considering the size, complexity and few models of the app, it seems like I get almost everything from Provider that I could get from Redux but with a lot less boilerplate.
