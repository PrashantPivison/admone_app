import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_recent_docs_model.dart';

class HomeRecentDocsWidget extends StatelessWidget {
  const HomeRecentDocsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeRecentDocsModel>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
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
          // Documents list
          for (var doc in model.recentDocs) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    padding: EdgeInsets.zero,
                    color: Colors.redAccent[200],
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No new notifications'),
                        ),
                      );
                    },
                  ),
                  Text(
                    doc.filename ?? '',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${doc.daysAgo} days ago',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
