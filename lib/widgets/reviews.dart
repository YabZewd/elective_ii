import 'package:flutter/material.dart';
import 'package:mobile/models/lots.dart';
import 'package:mobile/models/review.dart';
import 'package:mobile/services/review_service.dart';

class Reviews extends StatefulWidget {
  final Lots lot;
  const Reviews({super.key, required this.lot});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 3;
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _hasError = false;
  late String lotId;
  double? _averageRating;

  @override
  void initState() {
    super.initState();
    lotId = widget.lot.id;
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final reviewsData =
          await RemoteApi.fetchReviews(1, lotId: lotId, limit: 1000);
      if (!mounted) return;
      setState(() {
        _reviews = reviewsData['reviews'];
        _averageRating = reviewsData['rating'] != null
            ? (reviewsData['rating'] as num?)?.toDouble()
            : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AVERAGE RATING'),
        const SizedBox(height: 4),
        Row(
          children: [
            Image.asset(
              'assets/icons/star_filled.png',
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 4),
            Text(
              _averageRating != null
                  ? _averageRating!.toStringAsFixed(1)
                  : 'No Ratings Yet',
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('REVIEWS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(
          height: 320,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Failed to load reviews.'),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _fetchReviews,
                          ),
                        ],
                      ),
                    )
                  : _reviews.isEmpty
                      ? const Center(child: Text('No reviews yet.'))
                      : ListView.builder(
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            final review = _reviews[index];
                            return ListTile(
                              key: ValueKey(widget.lot.id),
                              leading: const Icon(Icons.person),
                              title: Text(review.username ?? 'Unknown User'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('${review.rating}'),
                                          const SizedBox(width: 4),
                                          Image.asset(
                                            'assets/icons/star_filled.png',
                                            width: 12,
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                          'Date: ${review.createdAt.split('T').first}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  Text(review.comment),
                                ],
                              ),
                            );
                          },
                        ),
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Write a review...',
                ),
              ),
            ),
            DropdownButton<int>(
              value: _rating.toInt(),
              items: List.generate(5, (i) => i + 1)
                  .map((val) =>
                      DropdownMenuItem(value: val, child: Text('$val')))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _rating = val!.toDouble();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final comment = _commentController.text.trim();
                if (comment.isEmpty) return;
                try {
                  await RemoteApi.submitReview(
                    lotId: widget.lot.id,
                    rating: _rating.toInt(),
                    comment: comment,
                  );
                  _commentController.clear();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review submitted!')),
                  );
                  _fetchReviews();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit review: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
