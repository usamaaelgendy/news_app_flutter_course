# News App — Flutter course project

A Flutter news app built during the course: onboarding, login/register,
top headlines and categories, search, article details and bookmarks, using the
[NewsAPI](https://newsapi.org/docs) with `http`.

## Get your own NewsAPI key

Every student uses their **own** free key — no key is stored in this repository.

1. Create a free account at [newsapi.org/register](https://newsapi.org/register).
2. Copy the API key shown on your account page.

## Run

1. Copy the example config and put your key in it:

   ```bash
   cp env.example.json env.json
   ```

   ```json
   { "NEWS_API_KEY": "your_newsapi_key" }
   ```

   `env.json` is git-ignored, so your key never gets committed.

2. Run the app with that file:

   ```bash
   flutter pub get
   flutter run --dart-define-from-file=env.json
   ```

   Or pass the key directly:

   ```bash
   flutter run --dart-define=NEWS_API_KEY=your_newsapi_key
   ```

   In VS Code / Android Studio, add `--dart-define-from-file=env.json` to the run
   configuration's "additional run args".

The key is read in `lib/core/datasource/remote_data/api_config.dart` with
`String.fromEnvironment('NEWS_API_KEY')`. If it is missing, requests fail with a
clear "NEWS_API_KEY is missing" message.

> Note: NewsAPI's free Developer plan works from local development only.

## Author

Usama Elgendy — [usamaelgendy.com](https://usamaelgendy.com)
