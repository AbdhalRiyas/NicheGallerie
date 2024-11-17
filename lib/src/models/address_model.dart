class AddressModel {
  final String firstName, lastName;
  final String? company;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  AddressModel(
      {required this.firstName,
      required this.lastName,
      this.company,
      required this.address1,
      this.address2,
      required this.city,
      required this.state,
      required this.postcode,
      required this.country,
      required this.email,
      required this.phone});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address_1'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      email: json['email'],
      phone: json['phone']);

  AddressModel copyWith(String? firstName) => AddressModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName,
      address1: address1,
      city: city,
      state: state,
      postcode: postcode,
      country: country,
      email: email,
      phone: phone);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': address1,
        'city': city,
        'state': state,
        'postcode': postcode,
        'country': country,
        'email': email,
        'phone': phone,
      };
}
