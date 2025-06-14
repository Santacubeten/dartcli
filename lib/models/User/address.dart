import 'package:objectbox/objectbox.dart';
import 'coordinates.dart';

@Entity()
class AddressModel {
  int id = 0;

  String street;
  String city;
  String zipcode;
  final coordinates = ToOne<CoordinatesModel>();

  AddressModel({required this.street, required this.city, required this.zipcode});
}
