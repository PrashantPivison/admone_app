// import 'package:flutter/material.dart';
// import '../../config/theme.dart';

// class NewChatsScreen extends StatefulWidget {
//   const NewChatsScreen({super.key});

//   @override
//   State<NewChatsScreen> createState() => _NewChatsState();
// }

// class _NewChatsState extends State<NewChatsScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final TextEditingController _subjectController = TextEditingController();
//   String? _selectedClient;

//   final List<String> _clients = [
//     'Client Alpha',
//     'Client Beta',
//     'Client Gamma',
//     'Client Delta'
//   ];

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;
//     _messageController.clear();
//   }

//   void _attachFile() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.insert_drive_file),
//                 title: const Text('Select from Device'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // TODO: Open file picker here
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Open Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // TODO: Open camera here
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showClientDropdown() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Heading with close button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Select Client",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                   ),
//                   IconButton(
//                     // alignment: Alignment(0, 0),
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               // Search field
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: CustomColors.chatsBorder, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                   color: CustomColors.chatsGrey,
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search client...",
//                     hintStyle: TextStyle(
//                       color: Color(0xFFAEAEAE),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, size: 20),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Client list with icons
//               Expanded(
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: _clients
//                       .map((client) => ListTile(
//                             leading: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .primary
//                                     .withOpacity(0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.perm_contact_cal_rounded,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                             title: Text(
//                               client,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                             onTap: () {
//                               setState(() {
//                                 _selectedClient = client;
//                               });
//                               Navigator.pop(context);
//                             },
//                           ))
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.onError,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: 60,
//         elevation: 0,
//         flexibleSpace: Stack(
//           children: [
//             Container(color: Theme.of(context).colorScheme.primary),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.arrow_back,
//                             color: Colors.white, size: 20),
//                       ),
//                       const SizedBox(width: 10),
//                       SizedBox(
//                         width: 300,
//                         child: Text(
//                           "New Message",
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineMedium
//                               ?.copyWith(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 color:
//                                     Theme.of(context).colorScheme.onSecondary,
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // Client Dropdown

//             GestureDetector(
//               onTap: _showClientDropdown,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: CustomColors.chatsBorder, width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                   color: CustomColors.chatsGrey,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _selectedClient ?? "Select Client",
//                         style: const TextStyle(
//                           color: Color(0xFFAEAEAE),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     const Icon(
//                       Icons.arrow_drop_down,
//                       color: Color(0xFFAEAEAE),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Subject Field
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: CustomColors.chatsBorder, width: 1),
//                 borderRadius: BorderRadius.circular(12),
//                 color: CustomColors.chatsGrey,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _subjectController,
//                           decoration: const InputDecoration(
//                             hintText: "Enter Subject Here",
//                             hintStyle: TextStyle(
//                               color: Color(0xFFAEAEAE),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Expanded(child: Container()), // Empty space where messages would be
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               height: 120,
//               decoration: BoxDecoration(
//                 border: Border.all(color: CustomColors.chatsBorder, width: 1),
//                 borderRadius: BorderRadius.circular(12),
//                 color: CustomColors.chatsGrey,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: const InputDecoration(
//                             hintText: "Type your message here...",
//                             hintStyle: TextStyle(
//                               color: Color(0xFFAEAEAE),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Attach Button
//                       Container(
//                         height: 30,
//                         constraints: const BoxConstraints(minWidth: 80),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.black, width: 1),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.attach_file,
//                                 size: 14, color: Colors.black),
//                             const SizedBox(width: 4),
//                             Text('Attach',
//                                 style: btnText.copyWith(color: Colors.black)),
//                           ],
//                         ),
//                       ),

//                       // Send Button
//                       Container(
//                         height: 30,
//                         constraints: const BoxConstraints(minWidth: 80),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.primary,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.arrow_forward,
//                                 size: 14, color: Colors.white),
//                             const SizedBox(width: 6),
//                             Text('Send',
//                                 style: btnText.copyWith(color: Colors.white)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_app/app_state.dart';
import 'package:provider/provider.dart';
import 'package:my_app/backend/api_requests/chat_api.dart';
import '../../config/theme.dart';

class NewChatsScreen extends StatefulWidget {
  const NewChatsScreen({super.key});

  @override
  State<NewChatsScreen> createState() => _NewChatsState();
}

class _NewChatsState extends State<NewChatsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  bool _sending = false;

  Map<String, dynamic>? _selectedClient;

  void _sendMessage() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (_selectedClient == null || subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _sending = true);

    try {
      final clientId = _selectedClient?['id'];

      final response = await ChatApi.createThread(
        clientId: clientId,
        subject: subject,
        messageBody: message,
        tasks: [],
        fileIds: [],
      );

      // Clear fields
      _messageController.clear();
      _subjectController.clear();
      _selectedClient = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thread created successfully!")),
      );

      // ✅ Pop and trigger refresh in Chats screen
      Navigator.pop(context, true); // pass `true` as signal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating thread: ${e.toString()}")),
      );
    } finally {
      setState(() => _sending = false);
    }
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
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClientDropdown() {
    final clients = Provider.of<AppState>(context, listen: false).clients;
    // print("clients $clients");
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Client",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.chatsBorder, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.chatsGrey,
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search client...",
                    hintStyle: TextStyle(
                        color: Color(0xFFAEAEAE),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: clients
                      .map((client) => ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.perm_contact_cal_rounded,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            title: Text(client['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            onTap: () {
                              setState(() => _selectedClient = client);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
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
            SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "New Message",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: _showClientDropdown,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.chatsBorder, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.chatsGrey,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedClient?['name'] ?? "Select Client",
                        style: const TextStyle(
                          color: Color(0xFFAEAEAE),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFAEAEAE)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.chatsBorder, width: 1),
                borderRadius: BorderRadius.circular(12),
                color: CustomColors.chatsGrey,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        hintText: "Enter Subject Here",
                        hintStyle: TextStyle(
                            color: Color(0xFFAEAEAE),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                      ),
                    ),
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
                                fontWeight: FontWeight.w600),
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
                      GestureDetector(
                        onTap: _attachFile,
                        child: Container(
                          height: 30,
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.attach_file,
                                  size: 14, color: Colors.black),
                              const SizedBox(width: 4),
                              Text('Attach',
                                  style: btnText.copyWith(color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _sending ? null : _sendMessage,
                        child: Container(
                          height: 30,
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _sending
                                ? const [
                                    SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    ),
                                  ]
                                : [
                                    const Icon(Icons.arrow_forward,
                                        size: 14, color: Colors.white),
                                    const SizedBox(width: 6),
                                    Text('Send',
                                        style: btnText.copyWith(
                                            color: Colors.white)),
                                  ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
