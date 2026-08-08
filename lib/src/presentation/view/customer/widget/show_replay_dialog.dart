import 'package:flutter/material.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

void showReplyDialog(BuildContext context) {
  final TextEditingController messageController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Center(
                child: Text(
                  "Send Replay",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff20283A),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Divider
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xffD5D8DD),
              ),

              const SizedBox(height: 18),

              // Message label
              const Text(
                "Message",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff424653),
                ),
              ),

              const SizedBox(height: 6),

              // Message field
              TextField(
                controller: messageController,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Enter",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffAEB3BD),
                  ),
                  contentPadding: const EdgeInsets.all(13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xffD1D3D8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xffD1D3D8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xffD1D3D8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: SizedBox(
                  width: 135,
                  height: 39,
                  child: CustomButton(
                    text: "Submit",
                    onTap: () {
                      final message = messageController.text.trim();

                      if (message.isEmpty) return;

                      Navigator.pop(context);
                      // API / controller call here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}