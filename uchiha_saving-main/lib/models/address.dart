class Address {
  final String street, roomNumber, city, state;
  final int zipCode;

  Address({
    required this.street,
    required this.roomNumber,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  Map<String, dynamic> toMap() {
    return {
      "street": street,
      "roomNumber": roomNumber,
      "city": city,
      "state": state,
      "zipCode": zipCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      city: data["city"],
      roomNumber: data["roomNumber"],
      state: data["state"],
      street: data["street"],
      zipCode: data["zipCode"],
    );
  }

  factory Address.fromDynamic(dynamic data) {
    return Address(
      city: data["city"],
      roomNumber: data["roomNumber"],
      state: data["state"],
      street: data["street"],
      zipCode: data["zipCode"],
    );
  }
}
