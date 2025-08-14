// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Reunited Countdown';

  @override
  String get timeBeforeReunion => 'Waktu sampai pertemuan kita';

  @override
  String get itsTime => 'Saatnya! 💕';

  @override
  String get modifyReunionDate => 'Ubah tanggal pertemuan';

  @override
  String get whereWillReunionTakePlace =>
      'Di mana pertemuan kalian akan berlangsung?';

  @override
  String appointmentOn(String date) {
    return 'Bertemu pada $date';
  }

  @override
  String get france => 'Prancis';

  @override
  String get indonesiaJava => 'Indonesia (Jawa)';

  @override
  String get day => 'Hari';

  @override
  String get days => 'Hari';

  @override
  String get hour => 'Jam';

  @override
  String get hours => 'Jam';

  @override
  String get minute => 'Menit';

  @override
  String get minutes => 'Menit';

  @override
  String get second => 'Detik';

  @override
  String get seconds => 'Detik';

  @override
  String get languageSettings => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get indonesian => 'Bahasa Indonesia';
}
