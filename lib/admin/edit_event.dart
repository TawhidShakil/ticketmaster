import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class EditEvent extends StatefulWidget {
  final Map<String, dynamic> event;
  const EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final supabase = Supabase.instance.client;

  // category list
  List<String> eventcategory = [
    "Seminar",
    "Workshop",
    "Conference",
    "Festival",
  ];

  late String? selectedEventType;
  late TextEditingController eventNameController;
  late TextEditingController priceController;
  late TextEditingController detailsController;

  XFile? imageFile;
  bool isUpdating = false;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController(
      text: widget.event['event_name'],
    );
    priceController = TextEditingController(
      text: widget.event['price'].toString(),
    );
    detailsController = TextEditingController(text: widget.event['details']);
    selectedEventType = widget.event['category'];
    currentImageUrl = widget.event['image_url'];
  }

  /// pick image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => imageFile = image);
    }
  }

  /// Update event logic
  Future<void> updateEvent() async {
    if (eventNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        detailsController.text.isEmpty ||
        selectedEventType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    setState(() => isUpdating = true);

    try {
      String? finalImageUrl = currentImageUrl;

      // 1️⃣ upload new image if picked
      if (imageFile != null) {
        final ext = imageFile!.name.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        final bytes = await imageFile!.readAsBytes();

        await supabase.storage.from('images').uploadBinary(fileName, bytes);

        finalImageUrl = supabase.storage.from('images').getPublicUrl(fileName);
      }

      // 2️⃣ Update data in Supabase
      final price = int.tryParse(priceController.text.trim()) ?? 0;

      await supabase
          .from('ticket_events')
          .update({
            'event_name': eventNameController.text.trim(),
            'price': price,
            'category': selectedEventType,
            'details': detailsController.text.trim(),
            'image_url': finalImageUrl,
          })
          .eq('id', widget.event['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate refresh needed
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image picker
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: imageFile != null
                        ? (kIsWeb
                              ? Image.network(
                                  imageFile!.path,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.cover,
                                ))
                        : (currentImageUrl != null
                              ? Image.network(
                                  currentImageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                )),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Event Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _inputField("Event Name", eventNameController),
              const SizedBox(height: 20),

              const Text(
                "Ticket Price",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _inputField(
                "Price",
                priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              const Text(
                "Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  value: selectedEventType,
                  items: eventcategory
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedEventType = value),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _inputField("Details", detailsController, maxLines: 5),
              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: isUpdating ? null : updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6351ec),
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isUpdating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Event",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xffececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
