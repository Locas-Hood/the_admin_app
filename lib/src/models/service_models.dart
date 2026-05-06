class ServicesFile {
  final List<DigitalServiceCategory> categories;

  ServicesFile({required this.categories});

  factory ServicesFile.fromJson(Map<String, dynamic> json) {
    return ServicesFile(
      categories: (json['digital_services_syria'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DigitalServiceCategory.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'digital_services_syria': categories
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class DigitalServiceCategory {
  String categoryAr;
  String categoryEn;
  List<DigitalServiceItem> services;

  DigitalServiceCategory({
    required this.categoryAr,
    required this.categoryEn,
    required this.services,
  });

  factory DigitalServiceCategory.fromJson(Map<String, dynamic> json) {
    return DigitalServiceCategory(
      categoryAr: json['category_ar'] as String? ?? '',
      categoryEn: json['category_en'] as String? ?? '',
      services: (json['services'] as List<dynamic>? ?? [])
          .map(
            (item) => DigitalServiceItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_ar': categoryAr,
      'category_en': categoryEn,
      'services': services.map((item) => item.toJson()).toList(),
    };
  }
}

class DigitalServiceItem {
  final String id;
  String nameAr;
  String nameEn;
  String descriptionAr;
  String descriptionEn;
  List<String> requirementsAr;
  List<String> requirementsEn;
  String officialUrl;

  DigitalServiceItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.requirementsAr,
    required this.requirementsEn,
    required this.officialUrl,
  });

  factory DigitalServiceItem.fromJson(Map<String, dynamic> json) {
    return DigitalServiceItem(
      id: json['id'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      descriptionEn: json['description_en'] as String? ?? '',
      requirementsAr: List<String>.from(json['requirements_ar'] ?? []),
      requirementsEn: List<String>.from(json['requirements_en'] ?? []),
      officialUrl: json['official_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'requirements_ar': requirementsAr,
      'requirements_en': requirementsEn,
      'official_url': officialUrl,
    };
  }
}
