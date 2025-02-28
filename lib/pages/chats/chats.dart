import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<String> chats = ["Alice", "Bob", "Charlie", "David"];
  String? selectedChatUser;
  List<String> messages = [];
  TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectedChatUser == null
        ? _buildChatList()
        : _buildChatScreen(selectedChatUser!);
  }

  // Chat List UI
  Widget _buildChatList() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(

        children: [
          AppBar(title: Text("0 unread messages")),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: double.infinity, // Ensures full-width scrolling
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Search Input
                    SizedBox(
                      width: 140,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Dropdown
                    SizedBox(
                      width: 110,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                        ),
                        value: "Option 1",
                        items: ["Option 1", "Option 2", "Option 3"]
                            .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(width: 8),

                    // Button
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Search"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedChatUser = chats[index]; // Open chat with selected user
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Removed CircleAvatar here
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: "${chats[index]} ",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: "Why do we use it? It is a long...",
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text("ADM Team", style: TextStyle(fontSize: 12, color: Colors.black)),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Last Message by Udit Aggarwal",
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ),
                                      Text(
                                        "17th January 2025",
                                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.black26, thickness: 1),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Chat Screen UI
  Widget _buildChatScreen(String userName) {
    return Column(
      children: [
        AppBar(
          title: Text("Chat with $userName"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedChatUser = null;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(messages[index]),
                ),
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  // Message Input Box
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      color: Colors.grey[200],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              // Attachment button action
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
