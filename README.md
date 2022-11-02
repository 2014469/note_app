# <center>NOTE APP<center>

### Folder structure

```
note_app/
├── README.md
├── analysis_options.yaml
├── android
├── assets                              # Contains images, icon, logo, fonts (`pubspec.yaml`)
├── build
├── cloud_functions                     # Functions about cloud(google drive, firebase)
├── ios
├── lib                                 # Write code main
├── note_app.iml
├── pubspec.lock
├── pubspec.yaml
└── test
```

### `Lib` folder

```
.
├── main.dart                           # This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
├── models                              # Contains the models layer of the project.
├── providers                           # Contains the set of class that provide data for the application, it absolutely manages the data flow.
├── resources                           # Contains all config, constant are defined (theme, color, text_styles...)
├── screens                             # Contains all ui for app, contains sub direction for each screen
├── services                            # Contains the firebase, google drive functions of the application
├── utils                               # Contains the utilities/common functions of the application.
└── widgets                             # Contains the common widgets for the applications (button, appbar,...)
```

### `provider` folder

```
.
└── home.provider.dart
```

> Convention: `{name}.provider.dart`

### `screens` folder

```
.
├── home.screen.dart
└── login.screen.dart
```

> Convention: `{name}.screen.dart`

### `utils` folder

```
.
├── devices
│   └── device_utils.dart
└── routes
    └── routes.dart
```

> Conventions: `add routes for each screen`

```dart
class Routes {
  Routes._();

  //static variables
  static const String login = '/login';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const LoginScreen(),
    home: (BuildContext context) => const HomeScreen(),
  };
```

### `resources` folder

```
.
├── colors
│   └── colors.dart                         # colors (gray,background, primary, yellow gold)
├── constants
│   └── string_constant.dart                # constant string
└── fonts
    ├── enum_text_styles.dart
    └── text_styles.dart                    # text styles (h1-h6, body1, body2, caption, title)
```

# <center>KEEP CLEAN<center>
