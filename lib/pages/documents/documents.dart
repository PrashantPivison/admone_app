import 'package:flutter/material.dart';

class DocumentsPage extends StatelessWidget {
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
                height: 80.0,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Chats',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),


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





                  Text(
                        textAlign: TextAlign.end,
                        'Trashed Files',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            columnWidths: {
                              0: FixedColumnWidth(120),
                              1: FixedColumnWidth(200),
                              2: FixedColumnWidth(150),
                              3: FixedColumnWidth(180),
                              4: FixedColumnWidth(180),
                              5: FixedColumnWidth(100),
                              6: FixedColumnWidth(100),
                            },
                            border: TableBorder.all(color: Colors.grey),
                            // Optional for debugging
                            children: [
                              TableRow(
                                children: [
                                  _tableCell('Name', isHeader: true),
                                  _tableCell('Type', isHeader: true),
                                  _tableCell('Created By', isHeader: true),
                                  _tableCell('Company Name', isHeader: true),
                                  _tableCell('Created On', isHeader: true),
                                  _tableCell('Status', isHeader: true),
                                  _tableCell('Trashed', isHeader: true),
                                  // Keep header as text
                                ],
                              ),
                              TableRow(
                                children: [
                                  _tableCellWithIcon('2002', Icons.folder),
                                  // Folder icon
                                  _tableCell('Folder'),
                                  _tableCell('Udit Aggarwal'),
                                  _tableCell('ADMOne Test Portal'),
                                  _tableCell('10-01-2025 06:03:03'),
                                  _tableCell('Approved'),
                                  _iconTableCell(Icons.delete, Colors.red),
                                  // Trash icon
                                ],
                              ),
                              TableRow(
                                children: [
                                  _tableCellWithIcon('2002', Icons.folder),
                                  // Folder icon
                                  _tableCell('Folder'),
                                  _tableCell('Udit Aggarwal'),
                                  _tableCell('ADMOne Test Portal'),
                                  _tableCell('10-01-2025 06:03:03'),
                                  _tableCell('Approved'),
                                  _iconTableCell(Icons.delete, Colors.red),
                                  // Trash icon
                                ],
                              ),
                              TableRow(
                                children: [
                                  _tableCellWithIcon('2002', Icons.folder),
                                  // Folder icon
                                  _tableCell('Folder'),
                                  _tableCell('Udit Aggarwal'),
                                  _tableCell('ADMOne Test Portal'),
                                  _tableCell('10-01-2025 06:03:03'),
                                  _tableCell('Approved'),
                                  _iconTableCell(Icons.delete, Colors.red),
                                  // Trash icon
                                ],
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create table cells

  Widget _tableCell(String text, {bool isHeader = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

// Table cell with text and an icon
  Widget _tableCellWithIcon(String text, IconData icon) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            // Adjust size/color as needed
            SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

// Table cell with only an icon (Trash icon)
  Widget _iconTableCell(IconData icon, Color color) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 20, color: color), // Trash icon
      ),
    );
  }
}