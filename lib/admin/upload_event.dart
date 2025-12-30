import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  // category list
  List<String> eventcategory = [
    "Seminar",
    "Workshop",
    "Conference",
    "Festival",
  ];

  String? selectedEventType;

  // controllers
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  XFile? imageFile;
  bool isUploading = false;

  /// pick image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => imageFile = image);
    }
  }

  /// 🔥 one button upload (image + data)
  Future<void> uploadEvent() async {
    if (imageFile == null ||
        eventNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        detailsController.text.isEmpty ||
        selectedEventType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    setState(() => isUploading = true);

    try {
      // 1️⃣ upload image
      final ext = imageFile!.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final bytes = await imageFile!.readAsBytes();

      print('Uploading image: $fileName');
      await Supabase.instance.client.storage
          .from('images')
          .uploadBinary(fileName, bytes);

      print('Image uploaded successfully');

      // 2️⃣ get image url
      final imageUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(fileName);

      print('Image URL: $imageUrl');

      // 3️⃣ insert data
      final price = int.tryParse(priceController.text.trim()) ?? 0;

      print('Inserting event data...');
      await Supabase.instance.client.from('ticket_events').insert({
        'event_name': eventNameController.text.trim(),
        'price': price,
        'category': selectedEventType,
        'details': detailsController.text.trim(),
        'image_url': imageUrl,
      });

      print('Event data inserted successfully');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event uploaded successfully')),
      );

      // clear
      eventNameController.clear();
      priceController.clear();
      detailsController.clear();
      setState(() {
        imageFile = null;
        selectedEventType = null;
      });
    } catch (e) {
      print('Error uploading event: $e'); // Print detailed error to console
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Upload Event",
                      style: TextStyle(
                        color: Color(0xff6351ec),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// image box
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
                  child: imageFile == null
                      ? const Icon(Icons.camera_alt_outlined, size: 40)
                      : kIsWeb
                      ? Image.network(imageFile!.path, fit: BoxFit.cover)
                      : Image.file(File(imageFile!.path), fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Event name
            const Text(
              "Event Name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _inputField("Enter Event Name", eventNameController),

            const SizedBox(height: 30),

            /// Ticket price
            const Text(
              "Ticket Price",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _inputField(
              "Enter Price",
              priceController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 30),

            /// Category
            const Text(
              "Select Category",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
                hint: const Text("Select Category"),
                value: selectedEventType,
                items: eventcategory
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedEventType = value);
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Details
            const Text(
              "Event Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _inputField(
              "What will be on the event .....",
              detailsController,
              maxLines: 6,
            ),

            const SizedBox(height: 25),

            /// Upload button
            Center(
              child: GestureDetector(
                onTap: isUploading ? null : uploadEvent,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff6351ec),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// reusable input field
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
