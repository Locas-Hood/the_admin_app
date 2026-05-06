class DataDocument {
  final List<DataSection> sections;

  DataDocument({required this.sections});

  factory DataDocument.fromJson(dynamic json) {
    if (json is List<dynamic>) {
      return DataDocument(
        sections: json
            .map((item) => DataSection.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }

    return DataDocument(
      sections: [DataSection.fromJson(json as Map<String, dynamic>)],
    );
  }

  dynamic toJson() {
    return sections.map((section) => section.toJson()).toList();
  }
}

class DataSection {
  String lastUpdate;
  List<String> syrianProvinces;
  List<String> syrianProvincesAr;
  List<Ministry> ministries;

  DataSection({
    required this.lastUpdate,
    required this.syrianProvinces,
    required this.syrianProvincesAr,
    required this.ministries,
  });

  factory DataSection.fromJson(Map<String, dynamic> json) {
    return DataSection(
      lastUpdate: json['last_update'] as String? ?? '',
      syrianProvinces: List<String>.from(json['syrian_provinces'] ?? []),
      syrianProvincesAr: List<String>.from(json['syrian_provinces_ar'] ?? []),
      ministries: (json['ministries'] as List<dynamic>? ?? [])
          .map((item) => Ministry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final result = {
      'last_update': lastUpdate,
      if (syrianProvinces.isNotEmpty) 'syrian_provinces': syrianProvinces,
      if (syrianProvincesAr.isNotEmpty)
        'syrian_provinces_ar': syrianProvincesAr,
      'ministries': ministries.map((item) => item.toJson()).toList(),
    };
    return result;
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

class Ministry {
  final int id;
  String nameAr;
  String nameEn;
  String provinces;
  List<Directorate> directorates;

  Ministry({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.provinces,
    required this.directorates,
  });

  factory Ministry.fromJson(Map<String, dynamic> json) {
    return Ministry(
      id: _parseInt(json['id']),
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      provinces: json['provinces'] as String? ?? '',
      directorates: (json['directorates'] as List<dynamic>? ?? [])
          .map((item) => Directorate.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'provinces': provinces,
      'directorates': directorates.map((item) => item.toJson()).toList(),
    };
  }
}

class Directorate {
  String nameAr;
  String nameEn;
  List<MinistryService> services;

  Directorate({
    required this.nameAr,
    required this.nameEn,
    required this.services,
  });

  factory Directorate.fromJson(Map<String, dynamic> json) {
    return Directorate(
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      services: (json['services'] as List<dynamic>? ?? [])
          .map((item) => MinistryService.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_ar': nameAr,
      'name_en': nameEn,
      'services': services.map((item) => item.toJson()).toList(),
    };
  }
}

class MinistryService {
  String titleAr;
  String titleEn;
  List<String> req;
  List<String> reqEn;
  String link;

  MinistryService({
    required this.titleAr,
    required this.titleEn,
    required this.req,
    required this.reqEn,
    required this.link,
  });

  factory MinistryService.fromJson(Map<String, dynamic> json) {
    return MinistryService(
      titleAr: json['title_ar'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      req: List<String>.from(json['req'] ?? []),
      reqEn: List<String>.from(json['req_en'] ?? []),
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title_ar': titleAr,
      'title_en': titleEn,
      'req': req,
      if (reqEn.isNotEmpty) 'req_en': reqEn,
      if (link.isNotEmpty) 'link': link,
    };
  }
}
