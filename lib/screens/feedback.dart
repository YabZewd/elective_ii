import 'package:flutter/material.dart';
import 'package:mobile/widgets/feedback_card.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  Future<void> _sendFeedbackEmail(BuildContext context, String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'novasupport@gmail.com',
      queryParameters: {
        'subject': 'Nova Parking App Feedback: $subject',
        'body': 'Hello, Nova Parking Support Team,\n\n',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not open email app. Please check your email client setup.'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
        ),
      );
    }
  }

  final List<String> _feedbacks = [
    'Something is not working',
    'I don\'t like the interface',
    'Reservations are not working',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What did you spot?'),
      ),
      body: ListView(
        children: _feedbacks
            .map((feedback) => InkWell(
                  onTap: () {
                    _sendFeedbackEmail(context, feedback);
                  },
                  child: FeedbackCard(title: feedback),
                ))
            .toList(),
      ),
    );
  }
}
