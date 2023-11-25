import 'package:flutter/material.dart';
import 'package:yourbookexperience/common/components/action_button.dart';
import 'package:yourbookexperience/details/details_page.dart';
import 'package:yourbookexperience/domain/review.dart';
import 'package:yourbookexperience/list/list_item.dart';
import 'package:yourbookexperience/repo/repo.dart';
import 'package:yourbookexperience/common/theme/colors.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Review> reviews = Repo.reviews;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome, User",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.foreground2,
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 2, color: AppColors.foreground1),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Expanded(
                child: ListView.separated(
              itemCount: Repo.reviews.length,
              itemBuilder: (context, index) => ListItem(
                  review: Repo.reviews[index], onListUpdate: _updateList),
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(padding: EdgeInsets.all(4));
              },
            )),
            ActionButton(onTap: _onAdd, text: "Share Your Story")
          ])),
      backgroundColor: AppColors.background,
    );
  }

  void _onAdd() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DetailsPage(
              review: Review(
                  id: Repo.reviews.last.id + 1,
                  userId: 0,
                  bTitle: "",
                  bAuthor: "",
                  description: "",
                  experiences: "",
                  pros: [],
                  cons: [],
                  rating: 0),
              formType: FormType.add,
              onListUpdate: _updateList,
            )));
  }

  void _updateList() {
    setState(() {
      reviews = Repo.reviews;
    });
  }
}
