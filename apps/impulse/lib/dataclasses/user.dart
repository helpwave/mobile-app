import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

extension GenderValueExtension on Gender {
  String get text {
    switch(this){
      case Gender.male:
        return "Mannlich";
      case Gender.female:
        return "Weiblich";
      case Gender.na:
        return "Nicht angegeben";
      case Gender.divers:
        return "Divers";
    }
  }
}

enum PAL {
  laying,
  sitting,
  standing,
  walking,
  active
}

extension PalValueExtension on PAL {

  double get value {
    switch(this) {
      case PAL.laying:
        return 1.2;
      case PAL.sitting:
        return 1.4;
      case PAL.standing:
        return 1.6;
      case PAL.walking:
        return 1.8;
      case PAL.active:
        return 2.0;
    }
}
  String get text {
    switch(this) {
      case PAL.laying:
        return "Sitzende oder liegende Lebensweise - Immobile, bettlägerige Menschen";
      case PAL.sitting:
        return "Sitzende Arbeit, wenig anstrengende Freizeit - Büroangestellte";
      case PAL.standing:
        return "Sitzende, kurzzeitige gehende und stehende Arbeit - Studierende";
      case PAL.walking:
        return "Überwiegend gehende und stehende Arbeit - VerkäuferIn, KellnerIn HandwerkerIn";
      case PAL.active:
        return "Körperlich anstrengender Beruf oder sehr aktive Freizeitaktivität - BauarbeiterIn, LandwirtIn, LeistungssportlerIn";
    }
  }
}

class User {
  String id;
  String username;
  Gender gender;
  DateTime birthday;
  PAL pal;
  int height;
  double weight;
  String teamId;

  User({
    required this.id,
    required this.username,
    required this.gender,
    required this.birthday,
    required this.pal,
    required this.height,
    required this.weight,
    this.teamId = "",
  });
}
