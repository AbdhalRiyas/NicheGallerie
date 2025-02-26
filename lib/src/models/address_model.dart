class AddressModel {
  final String firstName, lastName;
  final String company;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String email;
  final String phone;

  AddressModel({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.phone,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address_1'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      email: json['email'],
      phone: json['phone'],
      company: json['company'],
      address2: json['address_2']);

  AddressModel copyWith(String? firstName) => AddressModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName,
      address1: address1,
      city: city,
      state: state,
      postcode: postcode,
      country: country,
      email: email,
      phone: phone,
      company: company,
      address2: address2);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'company': company,
        'address_1': address1,
        'address_2': address2,
        'city': city,
        'state': state,
        'postcode': postcode,
        'country': country,
        'email': email,
        'phone': phone,
      };
}

List<AddressModel> dummyData = [
  AddressModel(
    firstName: 'John',
    lastName: 'Doe',
    company: 'Acme Corp',
    address1: '123 Main St',
    address2: 'Apt 4B',
    city: 'Anytown',
    state: 'Anystate',
    postcode: '12345',
    country: 'USA',
    email: 'john.doe@example.com',
    phone: '555-1234',
  ),
  AddressModel(
    firstName: 'Jane',
    lastName: 'Smith',
    company: 'Widgets Inc',
    address1: '456 Elm St',
    address2: 'null',
    city: 'Othertown',
    state: 'Otherstate',
    postcode: '67890',
    country: 'USA',
    email: 'jane.smith@example.com',
    phone: '555-5678',
  ),
  AddressModel(
    firstName: 'Alice',
    lastName: 'Jones',
    company: 'null',
    address1: '789 Oak St',
    address2: 'null',
    city: 'Thirdtown',
    state: 'Thirdstate',
    postcode: '13579',
    country: 'USA',
    email: 'alice.jones@example.com',
    phone: '555-2468',
  )
];
