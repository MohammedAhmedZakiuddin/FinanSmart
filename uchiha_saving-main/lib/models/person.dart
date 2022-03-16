import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uchiha_saving/models/address.dart';
import 'package:uchiha_saving/models/name.dart';

class Person {
  final String id;
  final Name name; //
  final String photoURL;
  final double balance;
  final String phone; //
  final String email;
  final Address address; //

  Person({
    required this.id,
    required this.phone,
    required this.email,
    required this.address,
    required this.name,
    required this.photoURL,
    required this.balance,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name.toMap,
        "balance": balance,
        "phone": phone,
        "email": email,
        "photoURL": photoURL,
        "address": address.toMap(),
      };

  factory Person.fromMap(Map<String, dynamic> data) => Person(
        id: data["id"],
        phone: data["phone"],
        email: data["email"],
        address: Address.fromDynamic(data["address"]),
        balance: data["balance"].toDouble(),
        name: Name.fromDynamic(data["name"]),
        photoURL: data["photoURL"],
      );

  factory Person.fromDocumentSnapshot(DocumentSnapshot data) => Person(
        id: data["id"],
        phone: data["phone"],
        email: data["email"],
        address: Address.fromDynamic(data["address"]),
        balance: data["balance"].toDouble(),
        name: Name.fromDynamic(data["name"]),
        photoURL: data["photoURL"],
      );
}
