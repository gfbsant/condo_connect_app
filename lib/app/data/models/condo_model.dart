class Condo {
  Condo({
    required this.name,
    required this.city,
    required this.state,
    required this.neighborhood,
    required this.zipcode,
    required this.address,
    required this.number,
    this.id,
  });

  factory Condo.fromJson(final Map<String, dynamic> json) => Condo(
        id: json['id'],
        name: json['name'],
        city: json['city'],
        state: json['state'],
        neighborhood: json['neighborhood'],
        zipcode: json['zipcode'],
        address: json['address'],
        number: json['number'],
      );

  final int? id;
  final String name;
  final String city;
  final String state;
  final String neighborhood;
  final String zipcode;
  final String address;
  final String number;

  Map<String, dynamic> get toJson => {
        if (id != null) 'id': id,
        'name': name,
        'city': city,
        'state': state,
        'neighborhood': neighborhood,
        'zipcode': zipcode,
        'address': address,
        'number': number,
      };

  Condo copyWith({
    final int? id,
    final String? name,
    final String? city,
    final String? state,
    final String? neighborhood,
    final String? zipcode,
    final String? address,
    final String? number,
  }) =>
      Condo(
        name: name ?? this.name,
        city: city ?? this.city,
        state: state ?? this.state,
        neighborhood: neighborhood ?? this.neighborhood,
        zipcode: zipcode ?? this.zipcode,
        address: address ?? this.address,
        number: number ?? this.number,
      );
}
