import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @zakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get zakat;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myGold.
  ///
  /// In en, this message translates to:
  /// **'My Gold'**
  String get myGold;

  /// No description provided for @addGold.
  ///
  /// In en, this message translates to:
  /// **'Add Gold'**
  String get addGold;

  /// No description provided for @editGold.
  ///
  /// In en, this message translates to:
  /// **'Edit Gold'**
  String get editGold;

  /// No description provided for @goldDetails.
  ///
  /// In en, this message translates to:
  /// **'Gold Details'**
  String get goldDetails;

  /// No description provided for @noGoldYet.
  ///
  /// In en, this message translates to:
  /// **'No gold items yet'**
  String get noGoldYet;

  /// No description provided for @addFirstGold.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first gold item'**
  String get addFirstGold;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wedding Ring'**
  String get itemNameHint;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @ring.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get ring;

  /// No description provided for @bar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get bar;

  /// No description provided for @necklace.
  ///
  /// In en, this message translates to:
  /// **'Necklace'**
  String get necklace;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @karat.
  ///
  /// In en, this message translates to:
  /// **'Karat'**
  String get karat;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (grams)'**
  String get weight;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional notes...'**
  String get notesHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this gold item?'**
  String get deleteConfirmMessage;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get totalWeight;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value (approx.)'**
  String get totalValue;

  /// No description provided for @nisaab.
  ///
  /// In en, this message translates to:
  /// **'Nisaab'**
  String get nisaab;

  /// No description provided for @nisaabStatus.
  ///
  /// In en, this message translates to:
  /// **'Nisaab Status'**
  String get nisaabStatus;

  /// No description provided for @reachedNisaab.
  ///
  /// In en, this message translates to:
  /// **'✅ Nisaab Reached'**
  String get reachedNisaab;

  /// No description provided for @notReachedNisaab.
  ///
  /// In en, this message translates to:
  /// **'❌ Nisaab Not Reached'**
  String get notReachedNisaab;

  /// No description provided for @nisaabInfo.
  ///
  /// In en, this message translates to:
  /// **'Nisaab = 85 grams of 24K gold'**
  String get nisaabInfo;

  /// No description provided for @zakatAmount.
  ///
  /// In en, this message translates to:
  /// **'Zakat Amount'**
  String get zakatAmount;

  /// No description provided for @zakatRate.
  ///
  /// In en, this message translates to:
  /// **'Zakat Rate: 2.5%'**
  String get zakatRate;

  /// No description provided for @currentGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Gold Price'**
  String get currentGoldPrice;

  /// No description provided for @pricePerGram.
  ///
  /// In en, this message translates to:
  /// **'Price per gram (24K)'**
  String get pricePerGram;

  /// No description provided for @updatePrice.
  ///
  /// In en, this message translates to:
  /// **'Update Price'**
  String get updatePrice;

  /// No description provided for @enterPriceManually.
  ///
  /// In en, this message translates to:
  /// **'Enter price manually'**
  String get enterPriceManually;

  /// No description provided for @goldPricePerGram.
  ///
  /// In en, this message translates to:
  /// **'Gold Price (per gram)'**
  String get goldPricePerGram;

  /// No description provided for @fetchingPrice.
  ///
  /// In en, this message translates to:
  /// **'Fetching current price...'**
  String get fetchingPrice;

  /// No description provided for @priceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Price updated successfully'**
  String get priceUpdated;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currency;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get grams;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Export your gold collection as a PDF to keep a safe backup.'**
  String get premiumDescription;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumber;

  /// No description provided for @goldAdded.
  ///
  /// In en, this message translates to:
  /// **'Gold item added successfully'**
  String get goldAdded;

  /// No description provided for @goldUpdated.
  ///
  /// In en, this message translates to:
  /// **'Gold item updated successfully'**
  String get goldUpdated;

  /// No description provided for @goldDeleted.
  ///
  /// In en, this message translates to:
  /// **'Gold item deleted'**
  String get goldDeleted;

  /// No description provided for @gram.
  ///
  /// In en, this message translates to:
  /// **'gram'**
  String get gram;

  /// No description provided for @totalGold.
  ///
  /// In en, this message translates to:
  /// **'Total Gold'**
  String get totalGold;

  /// No description provided for @zakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get zakatDue;

  /// No description provided for @noZakatDue.
  ///
  /// In en, this message translates to:
  /// **'No Zakat Due'**
  String get noZakatDue;

  /// No description provided for @zakatExplanation.
  ///
  /// In en, this message translates to:
  /// **'Zakat is 2.5% of the total gold value when it reaches the nisaab threshold.'**
  String get zakatExplanation;

  /// No description provided for @enterGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Current Gold Price'**
  String get enterGoldPrice;

  /// No description provided for @priceNote.
  ///
  /// In en, this message translates to:
  /// **'Enter the price per gram of 24-karat gold in SAR'**
  String get priceNote;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @fromCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get fromCamera;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get fromGallery;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
