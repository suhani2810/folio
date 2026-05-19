import 'package:flutter/material.dart';
import '../../models/page_model.dart';
import '../../repositories/document_repository.dart';
import '../../models/folder_model.dart';
import '../../models/document_model.dart';
import '../widgets/document_list_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final DocumentRepository repository = DocumentRepository();

  List<Folder> folders = [];
  List<DocumentModel> documents = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    final loadedFolders = await repository.getFolders();

    final loadedDocuments = await repository.getDocuments();

    setState(() {
      folders = loadedFolders;
      documents = loadedDocuments;
    });
  }

  Future<void> createFolder() async {

    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(

          title: const Text('New Folder'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Folder Name',
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {

                if (controller.text.isEmpty) return;

                await repository.createFolder(
                  controller.text,
                );

                Navigator.pop(context);

                loadData();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> createFakeDocument() async {

    if (folders.isEmpty) return;

    await repository.createDocument(
      folderId: folders.first.id!,
      name: 'Document ${documents.length + 1}',
    );

    loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        title: const Text(
          'Folio',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,

        actions: [

          IconButton(
            onPressed: createFolder,
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Folders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 120,

              child: folders.isEmpty
                  ? const Center(
                child: Text(
                  'No folders yet',
                ),
              )

                  : ListView.builder(

                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                itemCount: folders.length,

                itemBuilder: (context, index) {

                  final folder = folders[index];

                  return Container(
                    width: 140,

                    margin: const EdgeInsets.only(
                      right: 16,
                    ),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.05,
                          ),

                          blurRadius: 10,

                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Container(
                          padding:
                          const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(
                              alpha: 0.15,
                            ),

                            borderRadius:
                            BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.folder,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          folder.name,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Saved Folder',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Documents',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (documents.isEmpty)

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No documents yet'),
              ),

            ...documents.map(
                  (doc) => DocumentListTile(
                documentName: doc.name,
                date: doc.createdAt.toString(),

                onDelete: () async {

                  await repository.deleteDocument(
                    doc.id!,
                  );

                  loadData();
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          FloatingActionButton.extended(
            heroTag: 'doc',

            backgroundColor: Colors.orange,

            onPressed: createFakeDocument,

            icon: const Icon(
              Icons.description,
              color: Colors.white,
            ),

            label: const Text(
              'Add Document',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          FloatingActionButton.extended(
            heroTag: 'folder',

            backgroundColor: Colors.deepPurple,

            onPressed: createFolder,

            icon: const Icon(
              Icons.create_new_folder,
              color: Colors.white,
            ),

            label: const Text(
              'Add Folder',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}