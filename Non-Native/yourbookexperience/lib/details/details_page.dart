import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yourbookexperience/common/components/action_button.dart';
import 'package:yourbookexperience/details/box_input_field.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:yourbookexperience/domain/review_bloc.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class DetailsPage extends StatefulWidget {
  final Review review;
  final FormType formType;
  final Function() onListUpdate;
  const DetailsPage(
      {super.key,
      required this.review,
      required this.formType,
      required this.onListUpdate});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final TextEditingController titleController;
  late final TextEditingController authorController;
  late final TextEditingController descriptionController;
  late final TextEditingController experienceController;
  late final TextEditingController prosController;
  late final TextEditingController consController;

  late double rating;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.review.bTitle);
    authorController = TextEditingController(text: widget.review.bAuthor);
    descriptionController =
        TextEditingController(text: widget.review.description);
    experienceController =
        TextEditingController(text: widget.review.experiences);
    prosController = TextEditingController(text: widget.review.pros.join("\n"));
    consController = TextEditingController(text: widget.review.cons.join("\n"));
    rating = widget.review.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.foreground2,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
          title: Text(
            widget.formType.getPageTitle(),
            style: Theme.of(context).textTheme.headlineLarge,
          )),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.foreground1, width: 2),
                  color: AppColors.foreground2),
              padding: const EdgeInsets.all(4),
              child: ListView(children: [
                // Title
                Row(
                  children: [
                    Text(
                      "Title:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: titleController,
                      ),
                    ))
                  ],
                ),
                // Author
                Row(
                  children: [
                    Text(
                      "    Author:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: authorController,
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Rating: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: RatingBar.builder(
                        initialRating: rating,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: AppColors.text,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                    )
                  ],
                ),
                // Rating
                // Description
                BoxInputField(
                  controller: descriptionController,
                  label: "Description",
                ),
                // Experience
                BoxInputField(
                  controller: experienceController,
                  label: "Experience",
                ),
                // Pros
                BoxInputField(
                  controller: prosController,
                  label: "Pros",
                ),
                // Cons
                BoxInputField(
                  controller: consController,
                  label: "Cons",
                ),
              ]),
            )),
            widget.formType == FormType.update
                ? ActionButton(
                    onTap: () => _deleteOperation(context),
                    text: "Delete Story")
                : const Column(),
            ActionButton(
                onTap: () => _positiveOperation(context),
                text: widget.formType.getPositiveButtonText())
          ])),
      backgroundColor: AppColors.background,
    );
  }

  bool validate() {
    return titleController.text != "" &&
        authorController.text != "" &&
        rating != 0;
  }

  void _positiveOperation(BuildContext context) {
    if (validate()) {
      Review newReview = Review(
          id: -1,
          userId: 0,
          bTitle: titleController.text,
          bAuthor: authorController.text,
          description: descriptionController.text,
          experiences: experienceController.text,
          pros: prosController.text.split("\n"),
          cons: consController.text.split("\n"),
          rating: rating);
      if (widget.formType == FormType.add) {
        BlocProvider.of<ReviewBloc>(context)
            .add(AddReviewEvent(review: newReview));
      } else {
        BlocProvider.of<ReviewBloc>(context).add(
            UpdateReviewEvent(reviewId: widget.review.id, review: newReview));
      }
      widget.onListUpdate();
      Navigator.of(context).pop();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // backgroundColor: AppColors.background,
              title: Text(
                'Error',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                  "Make sure that you completed the title, author and rating fields. A review can't be ${widget.formType.getErrorWord()} without them!",
                  style: Theme.of(context).textTheme.titleMedium),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK",
                        style: Theme.of(context).textTheme.titleMedium))
              ],
            );
          });
    }
  }

  void _errorDialog(String errorText) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Database Error",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              errorText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            ],
          );
        });
  }

  void _deleteOperation(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: AppColors.background,
            title: Text(
              'Delete Confirmation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
                "Are you sure you want to delete this review? This action cannot be undone.",
                style: Theme.of(context).textTheme.titleMedium),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",
                      style: Theme.of(context).textTheme.titleMedium)),
              TextButton(
                  onPressed: () {
                    try {
                      BlocProvider.of<ReviewBloc>(context)
                          .add(DeleteReviewEvent(reviewId: widget.review.id));
                      widget.onListUpdate();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } catch (e) {
                      _errorDialog("Error on deleting element from database.");
                    }
                  },
                  child: Text("OK",
                      style: Theme.of(context).textTheme.titleMedium))
            ],
          );
        });
  }
}

enum FormType {
  update,
  add;

  String getPageTitle() {
    switch (this) {
      case add:
        return "Share Your Story";
      case update:
        return "Update Story";
    }
  }

  String getPositiveButtonText() {
    switch (this) {
      case add:
        return "Share Story";
      case update:
        return "Update Story";
    }
  }

  String getErrorWord() {
    switch (this) {
      case add:
        return "added";
      case update:
        return "updated";
    }
  }
}
