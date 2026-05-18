import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final String documentName;

  const DocumentDetailScreen({
    super.key,
    required this.documentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        title: Text(documentName),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.builder(
          itemCount: 6,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),

          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: Container(
                      color: Colors.grey.shade200,

                      child: const Center(
                        child: Icon(
                          Icons.description,
                          size: 70,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 12,
                    left: 12,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        'Page ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,

                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,

                      child: Icon(
                        Icons.edit,
                        color: Colors.deepPurple.shade400,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,

        onPressed: () {},

        icon: const Icon(
          Icons.picture_as_pdf,
          color: Colors.white,
        ),

        label: const Text(
          'Export PDF',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}