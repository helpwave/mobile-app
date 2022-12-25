import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:helpwave/styling/constants.dart';

const MarkerIcon personMarker = MarkerIcon(
  icon: Icon(
    Icons.radio_button_checked,
    color: Colors.blue,
    size: iconSizeMedium,
  ),
);

const MarkerIcon directionArrowMarker = MarkerIcon(
  icon: Icon(
    Icons.double_arrow,
    size: iconSizeMedium,
  ),
);

const MarkerIcon startIcon = MarkerIcon(
  icon: Icon(
    Icons.person,
    size: iconSizeBig,
    color: Colors.brown,
  ),
);

const MarkerIcon defaultMarker = MarkerIcon(
  icon: Icon(
    Icons.person_pin_circle,
    color: Colors.blue,
    size: iconSizeBig,
  ),
);

MarkerIcon hospitalMarker = MarkerIcon(
  iconWidget: Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.local_hospital,
      color: Colors.red,
      size: iconSizeMedium,
    ),
  ),
);
