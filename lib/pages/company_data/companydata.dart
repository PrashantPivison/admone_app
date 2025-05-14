// // lib/pages/company_data/companydata.dart
//
// import 'package:flutter/material.dart';
// import 'package:my_app/backend/api_requests/companydata_api.dart';
// import '../../config/theme.dart';
// import 'package:my_app/pages/company_data/companydata_model.dart';
// import 'companydata_details.dart';
//
// class CompanyDataPage extends StatefulWidget {
//   const CompanyDataPage({Key? key}) : super(key: key);
//
//   @override
//   State<CompanyDataPage> createState() => _CompanyDataPageState();
// }
//
// class _CompanyDataPageState extends State<CompanyDataPage> {
//   late Future<EntitiesResponse> _futureEntities;
//   @override
//   void initState() {
//     super.initState();
//     _futureEntities = CompanyDataApi.fetchClients();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: SafeArea(
//         child: FutureBuilder<EntitiesResponse>(
//           future: _futureEntities,
//           builder: (ctx, snap) {
//             if (snap.connectionState != ConnectionState.done) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snap.hasError) {
//               return Center(
//                   child: Text('Error loading companies: ${snap.error}'));
//             }
//             final data = snap.data!;
//             final count = data.clients.length;
//             return Column(
//               children: [
//                 // ————————— Header —————————
//                 // Container(
//                 //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 //   height: 100,
//                 //   width: double.infinity,
//                 //   color: Colors.red,
//                 //   child: const Align(
//                 //     alignment: Alignment.bottomLeft,
//                 //     child: Text(
//                 //       'Company Data',
//                 //       style: TextStyle(
//                 //         fontSize: 35,
//                 //         fontWeight: FontWeight.w600,
//                 //         color: Colors.white,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 const SizedBox(height: 20),
//
//                 // ——————— Summary line ———————
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 20),
//                 //   child: Text(
//                 //     'You have $count corporation${count == 1 ? '' : 's'} registered with us',
//                 //     style: const TextStyle(
//                 //       fontSize: 20,
//                 //       fontWeight: FontWeight.w200,
//                 //       color: Colors.black,
//                 //     ),
//                 //   ),
//                 // ),
//                 const SizedBox(height: 20),
//
//                 // —————— Scrollable list ——————
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                       child: Column(
//                         children: data.clients.map((c) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 20),
//                             child: Container(
//                               padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     c.name,
//                                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                                       fontFamily: 'Inter',
//                                       color: Theme.of(context).colorScheme.primary,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     // style: TextStyle(
//                                     //     fontSize: 20, color: Colors.blue[500]),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   if (c.businessStructure != null)
//                                     Text(
//                                       c.businessStructure!,
//                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                         fontFamily: 'Inter',
//                                         color: CustomColors.textGrey,
//                                         // fontWeight: FontWeight.w600,
//                                       ),
//                                       // style: TextStyle(
//                                       //     fontSize: 15,
//                                       //     color: Colors.grey[600]),
//                                     ),
//                                   const SizedBox(height: 10),
//                                   if (c.fullAddress != null)
//                                     Text(
//                                       c.fullAddress!,
//                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                         fontFamily: 'Inter',
//                                         // color: Theme.of(context).colorScheme.primary,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                       // style: const TextStyle(
//                                       //     fontSize: 15,
//                                       //     color: Colors.black,
//                                       //     fontWeight: FontWeight.w700),
//                                     ),
//                                   const SizedBox(height: 10),
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) => CompanydataDetails(
//                                                 clientId: c.id,
//                                                 clientName: c.name),
//                                           ),
//                                         );
//                                       },
//                                       child: const Text(
//                                         'See Details',
//                                         style: TextStyle(
//                                           fontFamily: 'Inter',
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


// lib/pages/company_data/companydata.dart

import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/companydata_api.dart';
import '../../config/theme.dart';
import 'package:my_app/pages/company_data/companydata_model.dart';
import 'companydata_details.dart';

class CompanyDataPage extends StatefulWidget {
  const CompanyDataPage({Key? key}) : super(key: key);

  @override
  State<CompanyDataPage> createState() => _CompanyDataPageState();
}

class _CompanyDataPageState extends State<CompanyDataPage> {
  late Future<EntitiesResponse> _futureEntities;

  @override
  void initState() {
    super.initState();
    _futureEntities = CompanyDataApi.fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<EntitiesResponse>(
          future: _futureEntities,
          builder: (ctx, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error loading companies: ${snap.error}'));
            }
            final data = snap.data!;

            return Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Column(
                    children: data.clients.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                  fontFamily: 'Inter',
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (c.businessStructure != null)
                                Text(
                                  c.businessStructure!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    fontFamily: 'Inter',
                                    color: CustomColors.textGrey,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              if (c.fullAddress != null)
                                Text(
                                  c.fullAddress!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CompanydataDetails(
                                          clientId: c.id,
                                          clientName: c.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'See Details',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}