class DocumentModel {
  final int? id;
  final int folderId;
  final String name;
  final DateTime createdAt;

  DocumentModel({
    this.id,
    required this.folderId,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folderId': folderId,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      folderId: map['folderId'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
