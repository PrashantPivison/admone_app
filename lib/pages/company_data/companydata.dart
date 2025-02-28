import 'package:flutter/material.dart';
import 'companydata_details.dart';

class CompanyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ Header Section (Fixed Height)
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              height: 100.0,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Data',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            /// ✅ Use Expanded to Avoid Overflow
            Expanded(
              child: SingleChildScrollView(
                // ✅ Make content scrollable
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You have 1 Corporation registered with us ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                      ),
                      SizedBox(height: 20.0),

                      /// ✅ Company Info Box
                      Container(
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ADMOne test corp',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blue[500]),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Partnership',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              '3548 Lone Star Cir, Fort Worth, 76177',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompanydataDetails()),
                                  );
                                },
                                child: Text(
                                  'See Details',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
