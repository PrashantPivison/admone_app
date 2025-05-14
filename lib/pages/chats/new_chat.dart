  import 'package:flutter/material.dart';
  import '../../config/theme.dart';

  class NewChatsScreen extends StatefulWidget {
    const NewChatsScreen({super.key});

    @override
    State<NewChatsScreen> createState() => _NewChatsState();
  }

  class _NewChatsState extends State<NewChatsScreen> {
    final TextEditingController _messageController = TextEditingController();

    void _sendMessage() {
      if (_messageController.text.trim().isEmpty) return;
      _messageController.clear();
    }

    void _attachFile() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Select from Device'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Open file picker here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Open Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Open camera here
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onError,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              Container(color: Theme.of(context).colorScheme.primary),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "New Message",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(child: Container()), // Empty space where messages would be
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.chatsBorder, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.chatsGrey,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: "Enter Subject Here",
                              hintStyle: TextStyle(
                                color: Color(0xFFAEAEAE),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.chatsBorder, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.chatsGrey,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: "Type your message here...",
                              hintStyle: TextStyle(
                                color: Color(0xFFAEAEAE),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Attach Button
                        Container(
                          height: 30,
                          constraints: const BoxConstraints(minWidth: 80),  // Use constraints instead of fixed width
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,  // Important for proper sizing
                            children: [
                              const Icon(Icons.attach_file, size: 14, color: Colors.black),
                              const SizedBox(width: 4),
                              Text('Attach', style: btnText.copyWith(color: Colors.black)),
                            ],
                          ),
                        ),

                        // Send Button
                        Container(
                          height: 30,
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text('Send', style: btnText.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: _attachFile,
                    //       child: Container(
                    //         height: 30,
                    //         width: 80,
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 12, vertical: 6),
                    //         decoration: BoxDecoration(
                    //           color: Colors.transparent,
                    //           borderRadius: BorderRadius.circular(8),
                    //           border: Border.all(color: Colors.black, width: 1),
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             const Icon(Icons.attach_file,
                    //                 size: 14, color: Colors.black),
                    //             const SizedBox(width: 3),
                    //             Text('Attach',
                    //                 style: btnText.copyWith(color: Colors.black)),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: _sendMessage,
                    //       child: Container(
                    //         height: 30,
                    //         width: 80,
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 12, vertical: 6),
                    //         decoration: BoxDecoration(
                    //           color: Theme.of(context).colorScheme.primary,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             const Icon(Icons.arrow_forward,
                    //                 size: 14, color: Colors.white),
                    //             const SizedBox(width: 6),
                    //             Text('Send',
                    //                 style: btnText.copyWith(color: Colors.white)),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
