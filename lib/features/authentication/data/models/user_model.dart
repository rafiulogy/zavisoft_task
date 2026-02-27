class UserModel {
  final int id;
  final String email;
  final String username;
  final String phone;
  final UserName name;
  final UserAddress address;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.name,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      name: UserName.fromJson(json['name'] ?? {}),
      address: UserAddress.fromJson(json['address'] ?? {}),
    );
  }

  String get fullName => '${name.firstname} ${name.lastname}';
}

class UserName {
  final String firstname;
  final String lastname;

  UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }
}

class UserAddress {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final Geolocation geolocation;

  UserAddress({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] ?? 0,
      zipcode: json['zipcode'] ?? '',
      geolocation: Geolocation.fromJson(json['geolocation'] ?? {}),
    );
  }

  String get fullAddress => '$number $street, $city $zipcode';
}

class Geolocation {
  final String lat;
  final String long;

  Geolocation({required this.lat, required this.long});

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
    );
  }
}
