class Bank {
  final String name;
  final String accountNo;
  Bank({required this.name, required this.accountNo});
  factory Bank.fromJson(Map<String, dynamic> j) => Bank(
        name: j['name'] as String,
        accountNo: j['account_no'] as String,
      );
}

class Contact {
  final String fullName;
  final String designation;
  final String email;
  final String phone;
  Contact({
    required this.fullName,
    required this.designation,
    required this.email,
    required this.phone,
  });
  factory Contact.fromJson(Map<String, dynamic> j) => Contact(
        fullName: j['full_name'] as String,
        designation: j['designation'] as String? ?? '',
        email: j['email'] as String,
        phone: j['phone'] as String,
      );
}

class AddressInfo {
  final String fullAddress;
  final String type;
  AddressInfo({required this.fullAddress, required this.type});
  factory AddressInfo.fromJson(Map<String, dynamic> j) => AddressInfo(
        fullAddress: j['full_address'] as String,
        type: j['type'] as String,
      );
}

class TaxAccount {
  final String accountType;
  final String accountNo;
  TaxAccount({required this.accountType, required this.accountNo});
  factory TaxAccount.fromJson(Map<String, dynamic> j) => TaxAccount(
        accountType: j['account_type'] as String,
        accountNo: j['account_no'] as String,
      );
}

class DBAInfo {
  final String name;
  final String fullAddress;
  DBAInfo({required this.name, required this.fullAddress});
  factory DBAInfo.fromJson(Map<String, dynamic> j) => DBAInfo(
        name: j['name'] as String,
        fullAddress: j['full_address'] as String,
      );
}

class Shareholder {
  final String fullName;
  final String ssn;
  final double percentage;
  Shareholder({
    required this.fullName,
    required this.ssn,
    required this.percentage,
  });
  factory Shareholder.fromJson(Map<String, dynamic> j) => Shareholder(
        fullName: j['full_name'] as String,
        ssn: j['ssn'] as String,
        percentage: (j['percentage'] as num).toDouble(),
      );
}

class ClientDetails {
  final int id;
  final String name;
  final String? businessStructure;
  final String? businessActivity;
  final String? ein;
  final String? dateOfFormation;
  final String? fullAddress;
  final String? registeredAgentName;
  final String? registeredAgentAddress;
  final List<Bank> banks;
  final List<Contact> contacts;
  final List<AddressInfo> addresses;
  final List<TaxAccount> taxAccounts;
  final List<DBAInfo> dba;
  final List<Shareholder> shareholders;

  ClientDetails({
    required this.id,
    required this.name,
    this.businessStructure,
    this.businessActivity,
    this.ein,
    this.dateOfFormation,
    this.fullAddress,
    this.registeredAgentName,
    this.registeredAgentAddress,
    required this.banks,
    required this.contacts,
    required this.addresses,
    required this.taxAccounts,
    required this.dba,
    required this.shareholders,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> j) {
    List<Bank> banks = [];
    if (j['banks'] != null) {
      banks = (j['banks'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Bank.fromJson)
          .toList();
    }
    List<Contact> contacts = [];
    if (j['contacts'] != null) {
      contacts = (j['contacts'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Contact.fromJson)
          .toList();
    }
    List<AddressInfo> addresses = [];
    if (j['Addresses'] != null) {
      addresses = (j['Addresses'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(AddressInfo.fromJson)
          .toList();
    }
    List<TaxAccount> taxAccounts = [];
    if (j['tax_accounts'] != null) {
      taxAccounts = (j['tax_accounts'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(TaxAccount.fromJson)
          .toList();
    }
    List<DBAInfo> dba = [];
    if (j['dba'] != null) {
      dba = (j['dba'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(DBAInfo.fromJson)
          .toList();
    }
    List<Shareholder> shareholders = [];
    if (j['shareholders'] != null) {
      shareholders = (j['shareholders'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Shareholder.fromJson)
          .toList();
    }

    return ClientDetails(
      id: j['id'] as int,
      name: j['name'] as String,
      businessStructure: j['business_structure'] as String?,
      businessActivity: j['business_activity'] as String?,
      ein: j['ein'] as String?,
      dateOfFormation: j['date_of_formation'] as String?,
      fullAddress: j['full_address'] as String?,
      registeredAgentName: j['registered_agent_details']?['name'] as String?,
      registeredAgentAddress:
          j['registered_agent_details']?['address'] as String?,
      banks: banks,
      contacts: contacts,
      addresses: addresses,
      taxAccounts: taxAccounts,
      dba: dba,
      shareholders: shareholders,
    );
  }
}
