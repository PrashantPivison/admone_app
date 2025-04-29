import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/companydata_api.dart';
// import 'package:my_app/models/companydata_details_model.dart';
import 'package:my_app/pages/company_data/companydata_details_model.dart';
import '../../config/theme.dart';
import 'companydata.dart';

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
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: FutureBuilder<ClientDetails>(
          future: _futureDetails,
          builder: (ctx, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Text('Error loading details: ${snap.error}'),
              );
            }
            final data = snap.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // — Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.red,
                    height: 100,
                    width: double.infinity,
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Company Data',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // — Back Link
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios,
                            color: Colors.blueAccent),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back to list',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                  ),
                  // — Core Info Card
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.clientName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.blue[500])),
                          const SizedBox(height: 10),
                          if (data.fullAddress != null)
                            Text('Address: ${data.fullAddress!}'),
                          const SizedBox(height: 15),
                          if (data.dateOfFormation != null)
                            _labelValue(
                                'Date of Formation', data.dateOfFormation!),
                          if (data.ein != null) _labelValue('EIN', data.ein!),
                          if (data.businessActivity != null)
                            _labelValue(
                                'Business Activity', data.businessActivity!),
                          if (data.businessStructure != null)
                            _labelValue('Structure', data.businessStructure!),
                          if (data.registeredAgentName != null)
                            _labelValue(
                                'Registered Agent', data.registeredAgentName!),
                          if (data.registeredAgentAddress != null)
                            _labelValue(
                                'Agent Address', data.registeredAgentAddress!),
                        ],
                      ),
                    ),
                  ),
                  // — Banks
                  if (data.banks.isNotEmpty)
                    _sectionCard(
                      icon: Icons.account_balance,
                      title: 'Banks',
                      child: Column(
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
                  // — Shareholders
                  if (data.shareholders.isNotEmpty)
                    _sectionCard(
                      icon: Icons.people,
                      title: 'Shareholders',
                      child: Column(
                        children: data.shareholders
                            .map((s) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _labelValue('Name', s.fullName),
                                    _labelValue('SSN', s.ssn),
                                    _labelValue('Ownership',
                                        '${s.percentage.toInt()}%'),
                                    const SizedBox(height: 10),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 30),
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
                  color: Colors.black,
                ),
            children: [
              TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: value),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
}
