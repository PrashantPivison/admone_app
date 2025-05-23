import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/companydata_api.dart';
import 'package:my_app/pages/company_data/companydata_details_model.dart';
import '../../config/theme.dart';

class CompanydataDetails extends StatefulWidget {
  final int clientId;
  final String clientName;

  const CompanydataDetails({
    Key? key,
    required this.clientId,
    required this.clientName,
  }) : super(key: key);

  @override
  State<CompanydataDetails> createState() => _CompanydataDetailsState();
}

class _CompanydataDetailsState extends State<CompanydataDetails> {
  late Future<ClientDetails> _futureDetails;

  @override
  void initState() {
    super.initState();
    _futureDetails = CompanyDataApi.fetchClientDetails(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Text(
          'Company Data',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: 'Inter',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF1F468E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<ClientDetails>(
          future: _futureDetails,
          builder: (ctx, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Text(
                  'Error loading details: ${snap.error}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Inter',
                    color: Colors.red,
                  ),
                ),
              );
            }
            final data = snap.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // — Core Info Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
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
                            widget.clientName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              fontFamily: 'Inter',
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (data.fullAddress != null)
                            Text(
                              'Address: ${data.fullAddress!}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                fontFamily: 'Inter',
                              ),
                            ),
                          const SizedBox(height: 15),
                          if (data.dateOfFormation != null)
                            _labelValue('Date of Formation', data.dateOfFormation!),
                          if (data.ein != null) _labelValue('EIN', data.ein!),
                          if (data.businessActivity != null)
                            _labelValue('Business Activity', data.businessActivity!),
                          if (data.businessStructure != null)
                            _labelValue('Structure', data.businessStructure!),
                          if (data.registeredAgentName != null)
                            _labelValue('Registered Agent', data.registeredAgentName!),
                          if (data.registeredAgentAddress != null)
                            _labelValue('Agent Address', data.registeredAgentAddress!),
                        ],
                      ),
                    ),
                  ),

                  // Extra spacing before Banks section
                  const SizedBox(height: 10),

                  // — Banks
                  if (data.banks.isNotEmpty)
                    _sectionCard(
                      icon: Icons.account_balance,
                      title: 'Banks',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.banks
                            .map((b) => _labelValue(b.name, b.accountNo))
                            .toList(),
                      ),
                    ),

                  // — Contacts
                  if (data.contacts.isNotEmpty)
                    _sectionCard(
                      icon: Icons.contact_phone,
                      title: 'Contacts',
                      child: Column(
                        children: data.contacts
                            .map((c) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _labelValue('Name', c.fullName),
                            _labelValue('Email', c.email),
                            _labelValue('Phone', c.phone),
                            const SizedBox(height: 10),
                          ],
                        ))
                            .toList(),
                      ),
                    ),

                  // — Addresses
                  if (data.addresses.isNotEmpty)
                    _sectionCard(
                      icon: Icons.location_on,
                      title: 'Addresses',
                      child: Column(
                        children: data.addresses
                            .map((a) => _labelValue(a.type, a.fullAddress))
                            .toList(),
                      ),
                    ),

                  // — Tax Accounts
                  if (data.taxAccounts.isNotEmpty)
                    _sectionCard(
                      icon: Icons.receipt_long,
                      title: 'Tax Accounts',
                      child: Column(
                        children: data.taxAccounts
                            .map((t) => _labelValue(t.accountType, t.accountNo))
                            .toList(),
                      ),
                    ),

                  // Extra spacing before DBA section
                  const SizedBox(height: 10),

                  // — DBA
                  if (data.dba.isNotEmpty)
                    _sectionCard(
                      icon: Icons.store_mall_directory,
                      title: 'DBA',
                      child: Column(
                        children: data.dba
                            .map((d) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _labelValue('Name', d.name),
                            _labelValue('Address', d.fullAddress),
                            const SizedBox(height: 10),
                          ],
                        ))
                            .toList(),
                      ),
                    ),

                  // Extra spacing before Shareholders section
                  const SizedBox(height: 10),

                  // — Shareholders


                  if (data.shareholders.isNotEmpty)
                    _sectionCard(
                      icon: Icons.people,
                      title: 'Shareholders',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Add this
                        children: [
                          for (var s in data.shareholders) ...[
                            _labelValue('Name', s.fullName),
                            _labelValue('SSN', s.ssn),
                            _labelValue('Ownership', '${s.percentage.toInt()}%'),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),







                  // if (data.shareholders.isNotEmpty)
                  //   _sectionCard(
                  //     icon: Icons.people,
                  //     title: 'Shareholders',
                  //     child: Column(
                  //       children: data.shareholders
                  //           .map((s) => Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           _labelValue('Name', s.fullName),
                  //           _labelValue('SSN', s.ssn),
                  //           _labelValue('Ownership',
                  //               '${s.percentage.toInt()}%'),
                  //           const SizedBox(height: 10),
                  //         ],
                  //       ))
                  //           .toList(),
                  //     ),
                  //   ),
                  // const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ),
  );

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),


      );
}





