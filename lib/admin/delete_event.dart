import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteEvent extends StatefulWidget {
  const DeleteEvent({super.key});

  @override
  State<DeleteEvent> createState() => _DeleteEventState();
}

class _DeleteEventState extends State<DeleteEvent> {
  final supabase = Supabase.instance.client;
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final data = await supabase
          .from('ticket_events')
          .select()
          .order('id', ascending: false);

      setState(() {
        _events = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching events: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching events: $e')));
      }
    }
  }

  Future<void> deleteEvent(dynamic eventId, String eventName) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Event',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete "$eventName"?\n\nThis action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleting event...'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    try {
      debugPrint('Attempting to delete event with ID: $eventId');

      final response = await supabase
          .from('ticket_events')
          .delete()
          .eq('id', eventId)
          .select();

      debugPrint('Delete response: $response');

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$eventName deleted successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Refresh the list
      await fetchEvents();
    } catch (e) {
      debugPrint('❌ Error deleting event: $e');
      debugPrint('Error type: ${e.runtimeType}');

      String errorMessage = 'Error deleting event';

      if (e.toString().contains('policy')) {
        errorMessage = 'Permission denied. Please check Supabase RLS policies.';
      } else if (e.toString().contains('JWT')) {
        errorMessage = 'Authentication error. Please login again.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9ff),
      appBar: AppBar(
        title: const Text(
          "Delete Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchEvents,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _events.isEmpty
            ? const Center(child: Text("No events found"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event['image_url'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                        ),
                      ),
                      title: Text(
                        event['event_name'] ?? 'Unnamed Event',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${event['category'] ?? 'No Category'} • ${event['price'] ?? 0} BDT",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteEvent(
                            event['id'],
                            event['event_name'] ?? 'Unnamed Event',
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
