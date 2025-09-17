# Flutter Sample App

This sample app demonstrates the integration of the Auth0 Flutter SDK into a Flutter app. The sample is a companion to the [Auth0 Flutter Quickstart](https://auth0.com/docs/quickstart/native/flutter/interactive).

## Quick Start

### Clone and install

```sh
git clone https://github.com/DisasterUnknown/Flutter-Weather-App
cd Flutter-Weather-App
flutter pub get
```

### Configure Auth0 and environment

- In your Auth0 Application (Web):
  - Allowed Callback URLs: `http://localhost:3000`
  - Allowed Logout URLs: `http://localhost:3000`
  - Allowed Web Origins: `http://localhost:3000`
- Create `.env` in the project root (rename `.env.example` if present):
  ```sh
  AUTH0_DOMAIN=undefined.auth0.com
  AUTH0_CLIENT_ID={yourClientId}
  AUTH0_CUSTOM_SCHEME=com.auth0.sample
  API_KEY={yourOpenWeatherApiKey}
  ```

### Run

- VS Code: press F5. Select your desired device (Chrome for Web).
- Terminal (Web with Auth0 on port 3000):
  ```sh
  flutter run -d chrome --web-port 3000 --web-renderer html
  ```

### What you’ll see

- Logged out: a welcome `HeroWidget` asking you to log in.
- Logged in: `HomePage` shows weather cards for cities in `lib/core/cities.json` using `API_KEY`.

### Tips

- If web auth redirects to a different port, ensure you started on `--web-port 3000` and Auth0 Allowed URLs use `http://localhost:3000`.
- If weather data is empty, verify `API_KEY` in `.env` (OpenWeatherMap) and network access.

## Requirements

- Flutter 3+
- Android Studio 4+ (for Android)
- Chrome (for Web)

> [!IMPORTANT]
> On every step, if you have a [custom domain](https://auth0.com/docs/customize/custom-domains), replace the `YOUR_AUTH0_DOMAIN` and `undefined.auth0.com` placeholders with your custom domain instead of the value from the settings page.

## 1. Configure the Auth0 Application

### 🌐 Web

Go to the settings page of your [Auth0 application](https://manage.auth0.com/#/applications/) and configure the following URLs:

- Allowed Callback URLs: `http://localhost:3000`
- Allowed Logout URLs: `http://localhost:3000`
- Allowed Web Origins: `http://localhost:3000`

## 2. Run the application

Use the [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli) to run the app.

### 🌐 Web

```sh
flutter run -d chrome --web-port 3000 --web-renderer html
```

## Credits

This `README.md` is maintained by an AI developer assistant.

 

---

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
    <source media="(prefers-color-scheme: dark)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_dark_mode.png" width="150">
    <img alt="Auth0 Logo" src="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
  </picture>
</p>

<p align="center">Auth0 is an easy-to-implement, adaptable authentication and authorization platform. <br>To learn more check out <a href="https://auth0.com/why-auth0">Why Auth0?</a></p>


