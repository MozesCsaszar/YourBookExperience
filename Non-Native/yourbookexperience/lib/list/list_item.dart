import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yourbookexperience/details/details_page.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class ListItem extends StatefulWidget {
  final Review review;
  final Function() onListUpdate;

  const ListItem({super.key, required this.review, required this.onListUpdate});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => DetailsPage(
                        review: widget.review,
                        formType: FormType.update,
                        onListUpdate: widget.onListUpdate,
                      )),
            ),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.foreground1, width: 2),
                color: AppColors.foreground2),
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Text(
                  "${widget.review.bTitle} by ${widget.review.bAuthor}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Column(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.foreground1, width: 2))),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Rated",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            RatingBarIndicator(
                              rating: widget.review.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.text,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            Text("by User",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: AppColors.foreground1,
                                            width: 1))),
                                child: Column(
                                  children: [
                                    Text(
                                      "Pros",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      widget.review.pros
                                          .sublist(0,
                                              min(3, widget.review.pros.length))
                                          .map((e) => "+$e")
                                          .join("\n"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                ))),
                        Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: AppColors.foreground1,
                                            width: 1))),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    Text(
                                      "Const",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Text(
                                      widget.review.cons
                                          .sublist(0,
                                              min(3, widget.review.pros.length))
                                          .map((e) => "-$e")
                                          .join("\n"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                )))
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}
