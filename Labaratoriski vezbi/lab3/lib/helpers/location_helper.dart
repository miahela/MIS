const apiKey = 'AIzaSyBT--ow_q9qoZAY52sm1MsUMQLBpRcA9HQ';

class LocationHelper {
  static String generateLocationPreview({double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }
}
