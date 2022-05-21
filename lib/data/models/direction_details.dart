class DirectionDetails {
  String? polylinePoints;
  String? durationText;

  DirectionDetails({this.polylinePoints, this.durationText});

  static DirectionDetails fromJson(Map<String, dynamic> json) {
    return DirectionDetails(
      polylinePoints: json['routes'][0]['overview_polyline']['points'],
      durationText: json['routes'][0]['legs'][0]['duration']['text'],
    );
  }
}
