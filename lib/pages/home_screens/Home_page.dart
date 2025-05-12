import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/notification_api.dart';
import 'package:my_app/pages/company_data/companydata.dart';
import 'package:my_app/pages/notification/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:my_app/app_state.dart';
import 'package:my_app/backend/api_requests/dashboard_api.dart';
import 'package:my_app/pages/auth_screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import 'package:my_app/service/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _DashboardState();
}

class _DashboardState extends State<HomePage> {
  Map<String, dynamic>? _user;
  List<dynamic> _documents = [];
  List<dynamic> _messages = [];
  bool _loading = true;
  String? _error;
  int _entities = 0;
  List<dynamic> _notifications = [];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _user = appState.userData;
    _fetchDashboardData();
    _fetchUnreadCount();
    _initSocket();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchUnreadCount();
    }
  }

  void _initSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    SocketService().connect(userId, (data) async {
      print('📩 Live notification received: $data');
      await _fetchUnreadCount();
    });

    Future.delayed(const Duration(seconds: 30), () {
      if (!SocketService().isConnected()) {
        print('🔁 Retrying socket connection...');
        _initSocket();
      }
    });
  }

  Future<void> _fetchDashboardData() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final response = await DashboardApi.getDashboardStats(appState.token!);
      setState(() {
        _documents = response['recentFiles'] ?? [];
        _messages = response['threads'] ?? [];
        _entities = response['entities'] as int? ?? 0;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final data = await NotificationApi.getNotifications(fetchAll: true);
      final unread = data.where((n) => n['unread'] == null).toList();
      setState(() {
        _notifications = data;
        _unreadCount = unread.length;
      });
    } catch (e) {
      print("Error loading notifications: $e");
    }
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'Inter',
              color: CustomColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  List<Widget> _buildDocumentItems(BuildContext context) {
    if (_loading) return [const Center(child: CircularProgressIndicator())];
    if (_error != null) return [Text('Error loading documents: $_error')];
    if (_documents.isEmpty) return [const Text('No documents found')];

    return _documents.map((doc) {
      final isPDF = doc['file_type']?.toLowerCase() == 'pdf';
      final icon = isPDF
          ? Image.asset('images/pdf.png', width: 25, height: 25)
          : Image.asset('images/jpg.png', width: 25, height: 25);

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _buildListItem(
          context,
          icon: icon,
          title: doc['file_name'] ?? '',
          subtitle: 'Uploaded ${(doc['uploaded_on'])}',
          gicon: null,
        ),
      );
    }).toList();
  }

  List<Widget> _buildMessaggesItems(BuildContext context) {
    if (_loading) return [const Center(child: CircularProgressIndicator())];
    if (_error != null) return [Text('Error loading messages: $_error')];
    if (_messages.isEmpty) return [const Text('No messages found')];

    return _messages.map((msg) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _buildListItem(
          context,
          icon: null,
          gicon: Icons.message_outlined,
          title: msg['lastMessage'] ?? '',
          subtitle: 'From ${msg['lastMessageSender']} | ${msg['lastMessageTime'] ?? ''}',
          giconColor: Colors.green,
        ),
      );
    }).toList();
  }

  Widget _buildListItem(
      BuildContext context, {
        required Widget? icon,
        required String title,
        required String subtitle,
        required IconData? gicon,
        String? amount,
        Color? giconColor,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (gicon != null)
              Icon(gicon, size: 25, color: giconColor ?? Colors.blue),
            if (gicon == null && icon != null) icon,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontFamily: 'Inter',
                        color: CustomColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontFamily: 'Inter',
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (amount != null)
              Text(
                amount,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontFamily: 'Inter',
                  color: CustomColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
            ),
          ),
          // const SizedBox(height: 15),
          _buildSection(
            context,
            title: 'Recent Files',
            items: _buildDocumentItems(context),
          ),
          const SizedBox(height: 15),
          _buildSection(
            context,
            title: 'Recent Messages',
            items: _buildMessaggesItems(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 250,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appbar_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Empty container to balance the row
                      Container(width: 48), // Same width as the notification icon

                      // Centered logo
                      Image.asset(
                        'images/admlogo.png',
                        width: 80,
                        height: 80,
                      ),

                      // Notification icon with badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => NotificationsPage()),
                              );
                            },
                          ),
                          if (_unreadCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_unreadCount',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user?['user']?['name'] ?? '',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontFamily: 'Poppins',
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user?['user']?['email'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'Poppins',
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CompanyDataPage()),
                        );
                      },
                      child: Text(
                        "Connected with $_entities Entities",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.primary,
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
      body: _buildDashboardContent(),
    );
  }
}