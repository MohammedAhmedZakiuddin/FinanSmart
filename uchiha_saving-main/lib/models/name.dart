class Name {
  final String firstName;
  final String middleName;
  final String lastName;

  Name({
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  Map<String, dynamic> get toMap => {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
      };

  factory Name.fromDynamic(dynamic data) => Name(
        firstName: data["firstName"],
        middleName: data["middleName"],
        lastName: data["lastName"],
      );
}
