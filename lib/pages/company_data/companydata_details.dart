import 'package:flutter/material.dart';
import 'companydata.dart';

class ShareholderCard extends StatelessWidget {
  final String name;
  final String ssn;
  final double percentage;

  ShareholderCard(
      {required this.name, required this.ssn, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Full Name:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("SSN:", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(ssn,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 10),
        Text("Ownership Percentage:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text("${percentage.toInt()}"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class CompanydataDetails extends StatelessWidget {
  const CompanydataDetails({super.key});

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
                        fontWeight: FontWeight.w600, // Keep bold for emphasis
                        color: Colors.white,
                        // height: 1.5, // Adjust for better spacing
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                // height: 400.0,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.blueAccent,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyDataPage()),
                            );
                          },
                          child: Text(
                            'Back to list',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      // height: 200.0,
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADMOne test corp',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.blue[500],
                            ),
                          ),
                          Text(
                            'Address: 3545 Lone Star Cir , Fort Worth .76177',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Formation',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '4th June 2019 ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EIN:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '52-5454544 ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Business Activity',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Oilseed (except Soybean) Farming',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registered Agent Details:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Name:Amit Shah ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'Address: Texas Motor Speedway, Lone Star Circle, Fort Worth, TX, USA, Fort Worth, TX, 76177 ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            height: 500.0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.food_bank_outlined),
                                            SizedBox(width: 10),
                                            Text(
                                              'Banks',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date of Formation',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '4th June 2019 ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date of Formation',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '4th June 2019 ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date of Formation',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '4th June 2019 ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date of Formation',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '4th June 2019 ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_city_sharp),
                                            SizedBox(width: 10),
                                            Expanded(
                                              // Wrap Text inside Expanded to prevent overflow
                                              child: Text(
                                                'Addresses',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Type',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Texas Workforce Commission',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Full address',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '601 University Dr, San Marcos, TX, 78666',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Type',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Texas Workforce Commission',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Full address',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '601 University Dr, San Marcos, TX, 78666',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.contact_emergency),
                                            SizedBox(width: 10),
                                            Expanded(
                                              // Wrap Text inside Expanded to prevent overflow
                                              child: Text(
                                                'Contact',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Full Name ',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Reema Shah',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Designation',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Accountant',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email:',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'reema@test.com',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '408-888-8888',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.taxi_alert),
                                            SizedBox(width: 10),
                                            Expanded(
                                              // Wrap Text inside Expanded to prevent overflow
                                              child: Text(
                                                'Tax Accounts',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Account Type',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Texas Workforce Commission - TWC',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Account Number',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '1231231211',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Account Type',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Texas Workforce Commission - TWC',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Account Number',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '1231231211',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.people,
                                                color: Colors.black54),
                                            SizedBox(width: 8),
                                            Text(
                                              "Shareholders",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        ShareholderCard(
                                            name: "Udit Aggarwal",
                                            ssn: "111-11-1212",
                                            percentage: 50),
                                        Divider(),
                                        ShareholderCard(
                                            name: "Amit Shah",
                                            ssn: "121-11-4544",
                                            percentage: 50),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons
                                                .data_exploration_outlined),
                                            SizedBox(width: 10),
                                            Expanded(
                                              // Wrap Text inside Expanded to prevent overflow
                                              child: Text(
                                                'DBA',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Business Name',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Store 2 ',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Full Address:',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '3545 Lone Star Cir, Fort Worth, 76177',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Wrap(
                                          // Instead of Row, use Wrap to allow proper text flow
                                          spacing:
                                              20.0, // Adjust spacing as needed
                                          runSpacing: 10.0,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Business Name',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      150, // Constrain width to avoid overflow
                                                  child: Text(
                                                    'Store 2 ',
                                                    softWrap:
                                                        true, // Ensures text wraps properly
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Full Address:',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '3545 Lone Star Cir, Fort Worth, 76177',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
