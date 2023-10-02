import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';

extension GenderValueExtension on Gender {
  String get text {
    switch(this){
      case Gender.GENDER_MALE:
        return "Mannlich";
      case Gender.GENDER_FEMALE:
        return "Weiblich";
      case Gender.GENDER_UNSPECIFIED:
        return "Nicht angegeben";
      case Gender.GENDER_DIVERSE:
        return "Divers";
    }
    return "";
  }
}

enum PALDescriptor {
  laying,
  sitting,
  standing,
  walking,
  active
}

extension PalValueExtension on PALDescriptor {

  double get value {
    switch(this) {
      case PALDescriptor.laying:
        return 1.2;
      case PALDescriptor.sitting:
        return 1.4;
      case PALDescriptor.standing:
        return 1.6;
      case PALDescriptor.walking:
        return 1.8;
      case PALDescriptor.active:
        return 2.0;
    }
}
  String get text {
    switch(this) {
      case PALDescriptor.laying:
        return "Sitzende oder liegende Lebensweise - Immobile, bettlägerige Menschen";
      case PALDescriptor.sitting:
        return "Sitzende Arbeit, wenig anstrengende Freizeit - Büroangestellte";
      case PALDescriptor.standing:
        return "Sitzende, kurzzeitige gehende und stehende Arbeit - Studierende";
      case PALDescriptor.walking:
        return "Überwiegend gehende und stehende Arbeit - VerkäuferIn, KellnerIn HandwerkerIn";
      case PALDescriptor.active:
        return "Körperlich anstrengender Beruf oder sehr aktive Freizeitaktivität - BauarbeiterIn, LandwirtIn, LeistungssportlerIn";
    }
  }
}

class User {
  String id;
  String username;
  Gender gender;
  DateTime birthday;
  PALDescriptor palDescriptor;
  double pal;
  int height;
  double weight;
  String teamId;

  static User get empty => User(
    id: "",
    username: "",
    birthday: DateTime(2000),
    gender: Gender.GENDER_UNSPECIFIED,
    pal: 0,
    weight: 1,
    height: 1,
  );

  User({
    required this.id,
    required this.username,
    required this.gender,
    required this.birthday,
    required this.pal,
    required this.height,
    required this.weight,
    this.teamId = "",
    this.palDescriptor = PALDescriptor.standing
  });
}
