import 'package:objectbox/objectbox.dart';

@Entity()
class CoordinatesModel {
  int id = 0;

  double lat;
  double lng;

  CoordinatesModel({required this.lat, required this.lng});
}
