import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                height: 150.0,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back, Sameer',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600, // Keep bold for emphasis
                        color: Colors.white,
                        height: 1.5, // Adjust for better spacing
                      ),
                    ),
                    SizedBox(height: 5),
                    // Add spacing between heading & paragraph
                    Text(
                      'Manage all your accounting needs seamlessly with the ADM ONE Portal, designed to simplify your financial workflow.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        // w100 is too thin, w300 is more readable
                        height: 1.6, // Adjust for natural paragraph spacing
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 150.0,
                              width: 150.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unread Chats',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      // w100 is too thin, w300 is more readable
                                      height: 1.6,
                                      // Adjust for natural paragraph spacing
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 25,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      // w100 is too thin, w300 is more readable
                                      height:
                                          1.6, // Adjust for natural paragraph spacing
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'data',
                                    style: TextStyle(
                                      fontSize: 18,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      // w100 is too thin, w300 is more readable
                                      height:
                                          1.6, // Adjust for natural paragraph spacing
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 150.0,
                              width: 150.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pending task',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      // w100 is too thin, w300 is more readable
                                      height: 1.6,
                                      // Adjust for natural paragraph spacing
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '2 / 2',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 25,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      // w100 is too thin, w300 is more readable
                                      height:
                                          1.6, // Adjust for natural paragraph spacing
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'pending vs all',
                                    style: TextStyle(
                                      fontSize: 18,
                                      // color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      // w100 is too thin, w300 is more readable
                                      height:
                                          1.6, // Adjust for natural paragraph spacing
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ), // unread task
                    Container(
                      padding: EdgeInsets.all(15.0),
                      margin:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Chats',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              Text(
                                'See Chats',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),


                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Table(
                              border: TableBorder.symmetric(),
                              columnWidths: {
                                0: FixedColumnWidth(120),
                                // Customize column widths
                                1: FixedColumnWidth(200),
                                2: FixedColumnWidth(150),
                              },
                              children: [
                                // Table Row for headers
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Received On',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Message',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Last Message By',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Table Row for data (example row)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '2025-02-05 10:30 AM',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hello, how are you?',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'John Doe',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '2025-02-05 10:30 AM',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hello, how are you?',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'John Doe',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '2025-02-05 10:30 AM',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Hello, how are you?',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'John Doe',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // Add more rows as needed...
                              ],
                            ),
                          )
                          // Main Table Heading
          
                          // Table for recent chats
                        ],
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.0),
                        margin:
                            EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Documents',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text(
                                  'See Documents',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.picture_as_pdf),
                                        padding: EdgeInsets.only(left: 0.0),
                                        color: Colors.redAccent[200],
                                        onPressed: () {
                                          // Handle notification click
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('No new notifications')),
                                          );
                                        },
                                      ),
                                      Text(
                                        'M-Power.png',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                    Text(
                                    '21 days ago',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ) // container
            ],
          ),
        ),
      ),
    );
  }
}
