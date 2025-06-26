import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/pages/list_display_page.dart';
import 'package:letterboxd/store/firebase_service/firestore_provider.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  bool isSearching = false;
  String searchQuery = '';

  List<Map<String, dynamic>> _filterLists(List<Map<String, dynamic>> lists) {
    if (searchQuery.isEmpty) return lists;

    return lists.where((list) {
      final listName = (list['listName'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return listName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userLists = ref.watch(getUserLists);

    final currentUser = ref.watch(authControllerProvider);
    final firestoreService = ref.read(firestoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search lists...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              )
            : const Text('Your Lists'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: userLists.when(
        data: (lists) {
          if (lists.isEmpty) {
            return const Center(
              child: Text(
                'No lists created yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final filteredLists =
              _filterLists(lists.cast<Map<String, dynamic>>());
          if (filteredLists.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Text(
                'No lists found matching "$searchQuery"',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: filteredLists.length,
            itemBuilder: (context, index) {
              final list = filteredLists[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListDisplayPage(
                          listName: list['listName'],
                          uid: currentUser?.uid ?? '',
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    list['listName'] ?? 'Unnamed List',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${(list['movies'] as List?)?.length ?? 0} movies',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete List'),
                          content: const Text(
                              'Are you sure you want to delete this list?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (shouldDelete == true && currentUser?.uid != null) {
                        await firestoreService.deleteList(
                          currentUser!.uid,
                          list['listName'],
                          ref,
                        );
                      }
                    },
                  ),
                  tileColor: const Color.fromARGB(255, 33, 33, 33),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child:
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController controller = TextEditingController();
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create a List'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter list name',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (controller.text.isNotEmpty &&
                        currentUser?.uid != null) {
                      await firestoreService.addToList(
                        currentUser!.uid,
                        controller.text,
                        {},
                        ref,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
