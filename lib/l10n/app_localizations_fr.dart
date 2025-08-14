// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Reunited Countdown';

  @override
  String get timeBeforeReunion => 'Temps avant nos retrouvailles';

  @override
  String get itsTime => 'C\'est le moment ! 💕';

  @override
  String get modifyReunionDate => 'Modifier la date des retrouvailles';

  @override
  String get whereWillReunionTakePlace => 'Où auront lieu vos retrouvailles ?';

  @override
  String appointmentOn(String date) {
    return 'Rendez-vous le $date';
  }

  @override
  String get france => 'France';

  @override
  String get indonesiaJava => 'Indonésie (Java)';

  @override
  String get day => 'Jour';

  @override
  String get days => 'Jours';

  @override
  String get hour => 'Heure';

  @override
  String get hours => 'Heures';

  @override
  String get minute => 'Minute';

  @override
  String get minutes => 'Minutes';

  @override
  String get second => 'Seconde';

  @override
  String get seconds => 'Secondes';

  @override
  String get languageSettings => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get indonesian => 'Bahasa Indonesia';
}
