import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// Message shown when crop, soil, or sowing date has not been selected
  ///
  /// In en, this message translates to:
  /// **'Please select crop, soil and sowing date'**
  String get selectCropSoilDate;

  /// Greeting shown to the user on the home screen
  ///
  /// In en, this message translates to:
  /// **'Namaste'**
  String get namaste;

  /// Fallback username shown when profile username is unavailable
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Label for the crop sowing date section
  ///
  /// In en, this message translates to:
  /// **'Sowing Date'**
  String get sowingDate;

  /// Placeholder shown before a sowing date is selected
  ///
  /// In en, this message translates to:
  /// **'Select Sowing Date'**
  String get selectSowingDate;

  /// Title shown when selecting a crop
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCrop;

  /// Hint text for the crop search field
  ///
  /// In en, this message translates to:
  /// **'Search Crop'**
  String get searchCrop;

  /// Button text used to close the crop selection
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text used to request a crop recommendation
  ///
  /// In en, this message translates to:
  /// **'Get Recommendation'**
  String get getRecommendation;

  /// Question asking the user about the current soil condition of their field
  ///
  /// In en, this message translates to:
  /// **'How is your field soil?'**
  String get howIsYourFieldSoil;

  /// Soil condition indicating low moisture
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// Description for dry soil
  ///
  /// In en, this message translates to:
  /// **'Needs irrigation'**
  String get needsIrrigation;

  /// Soil condition indicating balanced moisture
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Description for normal soil
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// Soil condition indicating high moisture
  ///
  /// In en, this message translates to:
  /// **'Wet'**
  String get wet;

  /// Description for wet soil
  ///
  /// In en, this message translates to:
  /// **'High moisture'**
  String get highMoisture;

  /// Message shown when weather data is unavailable
  ///
  /// In en, this message translates to:
  /// **'Weather not available'**
  String get weatherNotAvailable;

  /// Label shown for the current day in the weather forecast
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Short name for Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// Short name for Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// Short name for Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// Short name for Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// Short name for Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// Short name for Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// Short name for Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// Tagline shown on onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Right crop, right time'**
  String get onboardingTitle;

  /// Button text to skip onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Button text to go to next onboarding page
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Login screen title / button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Home tab / navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Weather section label
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// Title of the crop recommendation screen's app bar
  ///
  /// In en, this message translates to:
  /// **'Crop suggestion'**
  String get cropSuggestion;

  /// Loading message while crop recommendation is being generated
  ///
  /// In en, this message translates to:
  /// **'Preparing your recommendation...'**
  String get preparingRecommendation;

  /// Generic fallback error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Button text to retry a failed action
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Heading for alternate crop suggestions list
  ///
  /// In en, this message translates to:
  /// **'Other good options'**
  String get otherGoodOptions;

  /// Note shown when soil data used is an estimate, not user-provided
  ///
  /// In en, this message translates to:
  /// **'Soil data is estimated from your district average. Add your Soil Health Card for a more accurate recommendation.'**
  String get soilDataEstimatedNote;

  /// Note reminding user that recommendations refresh daily
  ///
  /// In en, this message translates to:
  /// **'Weather changes daily — check again tomorrow for an updated pick.'**
  String get weatherChangesDailyNote;

  /// Title suffix on irrigation output screen, shown after crop name
  ///
  /// In en, this message translates to:
  /// **'Today\'s Recommendation'**
  String get todaysRecommendation;

  /// Heading for the reasoning box on irrigation output screen
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get why;

  /// Label for the crop's current growth stage
  ///
  /// In en, this message translates to:
  /// **'Crop Growth Stage'**
  String get cropGrowthStage;

  /// Expandable section label showing technical irrigation numbers
  ///
  /// In en, this message translates to:
  /// **'More Information (Technical)'**
  String get moreInfoTechnical;

  /// Technical label for crop evapotranspiration value
  ///
  /// In en, this message translates to:
  /// **'ETc (Today\'s Water Use)'**
  String get etcLabel;

  /// Technical label for root zone water depletion value
  ///
  /// In en, this message translates to:
  /// **'Root zone depletion (Dr)'**
  String get depletionLabel;

  /// Technical label for readily available water value
  ///
  /// In en, this message translates to:
  /// **'Readily Available Water (RAW)'**
  String get rawLabel;

  /// Technical label for total available water value
  ///
  /// In en, this message translates to:
  /// **'Total Available Water (TAW)'**
  String get tawLabel;

  /// Title of the profile screen
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Label for the full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Hint text for the name field
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Label for the mobile number field
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Hint text for the mobile number field
  ///
  /// In en, this message translates to:
  /// **'10 digit mobile number'**
  String get tenDigitMobileNumber;

  /// Validation error when mobile number is empty
  ///
  /// In en, this message translates to:
  /// **'Number is required'**
  String get numberRequired;

  /// Validation error when mobile number length is wrong
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10 digit number'**
  String get enterValidTenDigitNumber;

  /// Label for the village/district field
  ///
  /// In en, this message translates to:
  /// **'Village / District'**
  String get villageDistrict;

  /// Hint text for the village/district field
  ///
  /// In en, this message translates to:
  /// **'Enter your village or district'**
  String get enterVillageOrDistrict;

  /// Generic validation error for required fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Label for the state field
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Hint text for the state field
  ///
  /// In en, this message translates to:
  /// **'Enter your state'**
  String get enterYourState;

  /// Button text to save profile
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// Snackbar message after successful profile save
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully ✅'**
  String get profileSavedSuccess;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for notification toggle
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Settings tile label
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Settings tile label
  ///
  /// In en, this message translates to:
  /// **'Data & Security'**
  String get dataSecurity;

  /// About us dialog title
  ///
  /// In en, this message translates to:
  /// **'About FasalGuru'**
  String get aboutFasalGuru;

  /// About us dialog body text
  ///
  /// In en, this message translates to:
  /// **'FasalGuru is a crop advisory app that gives farmers in Lucknow and Sitapur districts the right crop and irrigation advice based on soil, weather, and rainfall data.\n\nOur goal is to help farmers make better decisions through technology.\n\nVersion 1.0.0'**
  String get aboutFasalGuruDescription;

  /// Button to close a dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Delete account confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountTitle;

  /// Delete account confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Your profile data and account will both be deleted forever.'**
  String get deleteAccountConfirmMessage;

  /// Confirm delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Settings tile label
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Settings tile label
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// Settings tile label
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Login screen heading
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login screen subheading
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginToAccount;

  /// Validation error when email field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Validation error when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Password is empty'**
  String get passwordEmpty;

  /// Validation error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password too weak'**
  String get passwordTooWeak;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Fallback error message when login fails
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Text before the sign up link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Validation error when terms checkbox is not checked
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms and Privacy Policy'**
  String get agreeToTermsError;

  /// Fallback error message when sign up fails
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get signUpFailed;

  /// Signup screen heading
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Signup screen subheading
  ///
  /// In en, this message translates to:
  /// **'Welcome! Please enter your details'**
  String get welcomeEnterDetails;

  /// Label/hint for username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Validation error when username is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get pleaseEnterUsername;

  /// Validation error when username is too short
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// Hint for confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Validation error when password and confirm password differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Text before the Terms link on signup
  ///
  /// In en, this message translates to:
  /// **'I agree with'**
  String get iAgreeWith;

  /// Terms link text
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// Connector word between Terms and Privacy Policy links
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Text before the login link on signup screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Forgot password screen subheading
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email and we\'ll send you a reset link'**
  String get enterRegisteredEmail;

  /// Hint text for email field on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// Validation error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmailAddress;

  /// Snackbar message after reset link is sent
  ///
  /// In en, this message translates to:
  /// **'Reset link has been sent to your email'**
  String get resetLinkSent;

  /// Button text to send password reset link
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// Link text to return to login screen
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// Step indicator on district selection screen
  ///
  /// In en, this message translates to:
  /// **'STEP 1 OF 3'**
  String get stepOneOfThree;

  /// Small section label above the district selection heading
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get locationSectionLabel;

  /// District selection screen heading
  ///
  /// In en, this message translates to:
  /// **'Where\'s your farm?'**
  String get whereIsYourFarm;

  /// District selection screen subheading
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to tailor crop and irrigation advice to your soil and weather.'**
  String get tailorAdviceDescription;

  /// District name
  ///
  /// In en, this message translates to:
  /// **'Lucknow'**
  String get lucknow;

  /// Short description of Lucknow district's main crops
  ///
  /// In en, this message translates to:
  /// **'Wheat, paddy and mango belt'**
  String get lucknowSubtitle;

  /// District name
  ///
  /// In en, this message translates to:
  /// **'Sitapur'**
  String get sitapur;

  /// Short description of Sitapur district's main crops
  ///
  /// In en, this message translates to:
  /// **'Sugarcane and wheat belt'**
  String get sitapurSubtitle;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Bottom nav bar label for home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav bar label for crop recommendation tab
  ///
  /// In en, this message translates to:
  /// **'Crop AI'**
  String get navCropAI;

  /// Bottom nav bar label for profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Heading on location permission screen
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get allowLocationAccess;

  /// First line explaining why location is needed
  ///
  /// In en, this message translates to:
  /// **'We need your location for accurate'**
  String get locationAccuracyReasonLine1;

  /// Second line explaining why location is needed
  ///
  /// In en, this message translates to:
  /// **'weather & irrigation advice'**
  String get locationAccuracyReasonLine2;

  /// Displays fetched latitude value
  ///
  /// In en, this message translates to:
  /// **'Latitude : {value}'**
  String latitudeLabel(String value);

  /// Displays fetched longitude value
  ///
  /// In en, this message translates to:
  /// **'Longitude : {value}'**
  String longitudeLabel(String value);

  /// Shown when location has not been fetched yet
  ///
  /// In en, this message translates to:
  /// **'Location not fetched'**
  String get locationNotFetched;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
