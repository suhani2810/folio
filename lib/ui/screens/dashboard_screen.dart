import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/dashboard/dashboard_bloc.dart';
import '../../blocs/dashboard/dashboard_event.dart';
import '../../blocs/dashboard/dashboard_state.dart';
import '../../blocs/scanner/scanner_bloc.dart';
import '../../blocs/scanner/scanner_event.dart';
import '../../repositories/document_repository.dart';
import '../widgets/document_list_tile.dart';
import '../widgets/folder_list_tile.dart';
import 'scanner_screen.dart';
import 'document_detail_screen.dart';
import 'documents_by_folder_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Folio',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1.5, color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => context.read<DashboardBloc>().add(LoadDashboard()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is DashboardLoaded) {
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader('Folders (${state.folders.length})', onAdd: () => _showAddFolderDialog(context)),
                _buildFolderList(state),
                _buildHeader('Recent Documents'),
                _buildRecentList(state),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<ScannerBloc>().add(ResetScanner());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScannerScreen()),
          );
        },
        backgroundColor: const Color(0xFF673AB7),
        label: const Text('New Scan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.document_scanner_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(String title, {VoidCallback? onAdd}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black),
            ),
            if (onAdd != null)
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.create_new_folder_outlined, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderList(DashboardLoaded state) {
    if (state.folders.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('No folders yet.', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final folder = state.folders[index];
            return FolderListTile(
              folder: folder,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DocumentsByFolderScreen(folder: folder)),
              ),
              onDelete: () => context.read<DashboardBloc>().add(DeleteFolder(folder.id!)),
            );
          },
          childCount: state.folders.length,
        ),
      ),
    );
  }

  Widget _buildRecentList(DashboardLoaded state) {
    if (state.recentDocuments.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text('No scans yet. tap "New Scan" to start.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45))),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final doc = state.recentDocuments[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Hero(
                tag: 'doc_${doc.id}',
                child: DocumentListTile(
                  doc: doc,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentDetailScreen(
                        document: doc,
                        repository: context.read<DocumentRepository>(),
                      ),
                    ),
                  ),
                  onDelete: () => context.read<DashboardBloc>().add(DeleteDocument(doc.id!)),
                ),
              ),
            );
          },
          childCount: state.recentDocuments.length,
        ),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Folder Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<DashboardBloc>().add(AddFolder(controller.text));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}