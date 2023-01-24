import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'select your language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkMode;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @emergencyMap.
  ///
  /// In en, this message translates to:
  /// **'Emergency map'**
  String get emergencyMap;

  /// No description provided for @questionnaire.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get questionnaire;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loadEmergencyWard.
  ///
  /// In en, this message translates to:
  /// **'Load emergency ward'**
  String get loadEmergencyWard;

  /// No description provided for @closeHelpText.
  ///
  /// In en, this message translates to:
  /// **'Alright!'**
  String get closeHelpText;

  /// No description provided for @openHelpText.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get openHelpText;

  /// No description provided for @helpTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Explanatory Text'**
  String get helpTextTitle;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'closed'**
  String get closed;

  /// No description provided for @utilization.
  ///
  /// In en, this message translates to:
  /// **'Utilization'**
  String get utilization;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More...'**
  String get more;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @otherFunctions.
  ///
  /// In en, this message translates to:
  /// **'Other Functions'**
  String get otherFunctions;

  /// No description provided for @otherEmergencyRooms.
  ///
  /// In en, this message translates to:
  /// **'Other Emergency Rooms'**
  String get otherEmergencyRooms;

  /// No description provided for @giveDetails.
  ///
  /// In en, this message translates to:
  /// **'Give details'**
  String get giveDetails;

  /// No description provided for @searchDoctorsOffices.
  ///
  /// In en, this message translates to:
  /// **'Seacrch doctor\'s office'**
  String get searchDoctorsOffices;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'call,'**
  String get call;

  /// No description provided for @notify.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notify;

  /// No description provided for @notifyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Notification'**
  String get notifyCancel;

  /// No description provided for @startNavigation.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigation;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @emergencyPass.
  ///
  /// In en, this message translates to:
  /// **'Emergency Pass'**
  String get emergencyPass;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @organDonor.
  ///
  /// In en, this message translates to:
  /// **'Organ donor'**
  String get organDonor;

  /// No description provided for @primaryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Mother tongue'**
  String get primaryLanguage;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get unknown;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchNoun.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchNoun;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood-Type'**
  String get bloodType;

  /// No description provided for @notAnswered.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAnswered;

  /// No description provided for @rhesus.
  ///
  /// In en, this message translates to:
  /// **'Rhesus'**
  String get rhesus;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @rhPlus.
  ///
  /// In en, this message translates to:
  /// **'Rh+'**
  String get rhPlus;

  /// No description provided for @rhMinus.
  ///
  /// In en, this message translates to:
  /// **'Rh-'**
  String get rhMinus;

  /// No description provided for @bloodTypeA.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get bloodTypeA;

  /// No description provided for @bloodTypeAB.
  ///
  /// In en, this message translates to:
  /// **'AB'**
  String get bloodTypeAB;

  /// No description provided for @bloodTypeB.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get bloodTypeB;

  /// No description provided for @bloodTypeO.
  ///
  /// In en, this message translates to:
  /// **'O'**
  String get bloodTypeO;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @currently.
  ///
  /// In en, this message translates to:
  /// **'currently'**
  String get currently;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'not found'**
  String get notFound;

  /// No description provided for @addAnyway.
  ///
  /// In en, this message translates to:
  /// **'Add anyway'**
  String get addAnyway;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'1x Monthly'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'1x Weekly'**
  String get weekly;

  /// No description provided for @weekly2Times.
  ///
  /// In en, this message translates to:
  /// **'2x Weekly'**
  String get weekly2Times;

  /// No description provided for @weekly4Times.
  ///
  /// In en, this message translates to:
  /// **'4x Weekly'**
  String get weekly4Times;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'1x Daily'**
  String get daily;

  /// No description provided for @daily2Times.
  ///
  /// In en, this message translates to:
  /// **'2x Daily'**
  String get daily2Times;

  /// No description provided for @daily3Times.
  ///
  /// In en, this message translates to:
  /// **'3x Daily'**
  String get daily3Times;

  /// No description provided for @daily5Times.
  ///
  /// In en, this message translates to:
  /// **'5x Daily'**
  String get daily5Times;

  /// No description provided for @medicationSearch.
  ///
  /// In en, this message translates to:
  /// **'Medication Search'**
  String get medicationSearch;

  /// No description provided for @listSearch.
  ///
  /// In en, this message translates to:
  /// **'List-Search'**
  String get listSearch;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @allergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get allergy;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'severe'**
  String get severe;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get light;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// No description provided for @resetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Completely reset?'**
  String get resetQuestion;

  /// No description provided for @acceptQuestion.
  ///
  /// In en, this message translates to:
  /// **'Accept?'**
  String get acceptQuestion;

  /// No description provided for @resetIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Reset Introduction'**
  String get resetIntroduction;

  /// No description provided for @showIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Show Introduction?'**
  String get showIntroduction;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
