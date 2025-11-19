import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/document_provider.dart';
import '../../models/pdf_document.dart';
import '../../navigation/route_names.dart';

/// Library screen - Shows all PDF documents
/// Allows searching, filtering, and organizing documents
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  DocumentFilter _filter = DocumentFilter.all;
  DocumentSort _sort = DocumentSort.dateDesc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          PopupMenuButton<DocumentSort>(
            icon: const Icon(Icons.sort),
            onSelected: (sort) {
              setState(() => _sort = sort);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: DocumentSort.dateDesc,
                child: Text('Newest first'),
              ),
              const PopupMenuItem(
                value: DocumentSort.dateAsc,
                child: Text('Oldest first'),
              ),
              const PopupMenuItem(
                value: DocumentSort.nameAsc,
                child: Text('Name A-Z'),
              ),
              const PopupMenuItem(
                value: DocumentSort.nameDesc,
                child: Text('Name Z-A'),
              ),
              const PopupMenuItem(
                value: DocumentSort.sizeDesc,
                child: Text('Largest first'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Scanned'),
            Tab(text: 'Converted'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, docProvider, child) {
          if (docProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (docProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: AppDimensions.space16),
                  Text(docProvider.error!),
                  const SizedBox(height: AppDimensions.space16),
                  ElevatedButton(
                    onPressed: () => docProvider.loadDocuments(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildDocumentGrid(docProvider.documents),
              _buildDocumentGrid(
                docProvider.documents
                    .where((d) => d.documentType == DocumentType.scanned)
                    .toList(),
              ),
              _buildDocumentGrid(
                docProvider.documents
                    .where((d) => d.documentType == DocumentType.converted)
                    .toList(),
              ),
              _buildDocumentGrid(docProvider.favorites),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.scanner),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentGrid(List<PdfDocument> documents) {
    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'No documents yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'Start by scanning a document',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      );
    }

    // Sort documents
    final sortedDocs = _sortDocuments(documents);

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.space16,
        mainAxisSpacing: AppDimensions.space16,
        childAspectRatio: 0.75,
      ),
      itemCount: sortedDocs.length,
      itemBuilder: (context, index) {
        return _DocumentCard(document: sortedDocs[index]);
      },
    );
  }

  List<PdfDocument> _sortDocuments(List<PdfDocument> docs) {
    final sorted = List<PdfDocument>.from(docs);

    switch (_sort) {
      case DocumentSort.dateDesc:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case DocumentSort.dateAsc:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case DocumentSort.nameAsc:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case DocumentSort.nameDesc:
        sorted.sort((a, b) => b.title.compareTo(a.title));
        break;
      case DocumentSort.sizeDesc:
        sorted.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
    }

    return sorted;
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Documents'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter document name...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.pop(context);
            showSearch(context: context, delegate: DocumentSearchDelegate(provider));
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showSearch(context: context, delegate: DocumentSearchDelegate(provider));
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

/// Document card widget
class _DocumentCard extends StatelessWidget {
  final PdfDocument document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push(RouteNames.pdfViewerWithId(document.id));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: document.thumbnailPath != null
                    ? Image.file(
                        File(document.thumbnailPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    document.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.space4),

                  // Meta info
                  Row(
                    children: [
                      Icon(
                        _getDocTypeIcon(document.documentType),
                        size: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                      const SizedBox(width: AppDimensions.space4),
                      Expanded(
                        child: Text(
                          '${document.pageCount} pages • ${document.fileSizeFormatted}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.6),
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Favorite icon
                      if (document.isFavorite)
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.picture_as_pdf,
        size: 48,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      ),
    );
  }

  IconData _getDocTypeIcon(DocumentType type) {
    switch (type) {
      case DocumentType.scanned:
        return Icons.document_scanner;
      case DocumentType.converted:
        return Icons.transform;
      case DocumentType.imported:
        return Icons.upload_file;
    }
  }
}

enum DocumentFilter { all, scanned, converted, favorites }

enum DocumentSort { dateDesc, dateAsc, nameAsc, nameDesc, sizeDesc }
