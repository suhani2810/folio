import '../core/database_helper.dart';
import '../models/folder_model.dart';
import '../models/document_model.dart';
import '../models/page_model.dart';

class DocumentRepository {

  Future<void> createFolder(String name) async {
    final db = await DatabaseHelper.database;

    await db.insert(
      'folders',
      Folder(
        name: name,
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<List<Folder>> getFolders() async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      'folders',
      orderBy: 'createdAt DESC',
    );

    return result.map((e) => Folder.fromMap(e)).toList();
  }

  Future<void> createDocument({
    required int folderId,
    required String name,
  }) async {

    final db = await DatabaseHelper.database;

    await db.insert(
      'documents',
      DocumentModel(
        folderId: folderId,
        name: name,
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<List<DocumentModel>> getDocuments() async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      'documents',
      orderBy: 'createdAt DESC',
    );

    return result
        .map((e) => DocumentModel.fromMap(e))
        .toList();
  }

  Future<void> deleteDocument(int id) async {
    final db = await DatabaseHelper.database;

    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}