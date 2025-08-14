// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reunited Countdown';

  @override
  String get timeBeforeReunion => 'Time until our reunion';

  @override
  String get itsTime => 'It\'s time! 💕';

  @override
  String get modifyReunionDate => 'Modify reunion date';

  @override
  String get whereWillReunionTakePlace => 'Where will your reunion take place?';

  @override
  String appointmentOn(String date) {
    return 'Appointment on $date';
  }

  @override
  String get france => 'France';

  @override
  String get indonesiaJava => 'Indonesia (Java)';

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String get hour => 'Hour';

  @override
  String get hours => 'Hours';

  @override
  String get minute => 'Minute';

  @override
  String get minutes => 'Minutes';

  @override
  String get second => 'Second';

  @override
  String get seconds => 'Seconds';

  @override
  String get languageSettings => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get indonesian => 'Bahasa Indonesia';
}
