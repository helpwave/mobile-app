import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class StreetMap extends StatefulWidget {
  final double width;
  final double height;
  final double border;

  const StreetMap({
    super.key,
    this.width = -1,
    this.height = -1,
    this.border = 5,
  });

  @override
  State<StatefulWidget> createState() => _StreetMapState();
}

class _StreetMapState extends State<StreetMap> {
  @override
  Widget build(BuildContext context) {
    double border = widget.border;

    OSMFlutter osmFlutter = OSMFlutter(
      controller: MapController(
        initMapWithUserPosition: false,
        initPosition: GeoPoint(
          latitude: 51.9582531914801,
          longitude: 7.614308513084836,
        ),
        areaLimit: BoundingBox(
          east: 7.868367326136183,
          north: 52.05926850228487,
          south: 51.815854199654915,
          west: 7.459126643491313,
        ),
      ),
      trackMyPosition: false,
      initZoom: 12,
      minZoomLevel: 2,
      maxZoomLevel: 19,
      stepZoom: 1,
      // TODO update staticPoints and their display
      staticPoints: [
        StaticPositionGeoPoint(
          "Unique Name 1",
          MarkerIcon(
            iconWidget: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_hospital,
                color: Colors.red,
                size: 48,
              ),
            ),
          ),
          [
            GeoPoint(
              latitude: 51.9582531914801,
              longitude: 7.614308513084836,
            ),
            GeoPoint(latitude: 51.85, longitude: 7.6)
          ],
        )
      ],
      mapIsLoading: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ],
          ),
        ),
      ),
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,
            size: 48,
          ),
        ),
      ),
      roadConfiguration: RoadConfiguration(
        startIcon: const MarkerIcon(
          icon: Icon(
            Icons.person,
            size: 64,
            color: Colors.brown,
          ),
        ),
        roadColor: Colors.yellowAccent,
      ),
      markerOption: MarkerOption(
        defaultMarker: const MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 56,
          ),
        ),
      ),
    );

    Size mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: widget.width > 0 ? widget.width : mediaQuery.width * 0.8,
      height: widget.height > 0 ? widget.height : mediaQuery.width * 0.8,
      padding: EdgeInsets.all(border),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: osmFlutter,
    );
  }
}
