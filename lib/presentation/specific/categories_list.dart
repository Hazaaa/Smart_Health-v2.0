import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/models/category.dart';
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [];
    final db = Provider.of<Database>(context, listen: false);

    return Container(
        height: getRelativeHeight(0.085),
        child: FutureBuilder(
          future: db.categoriesCollection.getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return ErrorText(
                  "Došlo je do greške prilikom učitavanja kategorija!");
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final docs = snapshot.data!.docs;
              docs.forEach((QueryDocumentSnapshot element) {
                categories.add(Category.fromJson(element));
              });

              return ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.symmetric(horizontal: getRelativeWidth(0.035)),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: getRelativeHeight(0.1),
                        constraints:
                            BoxConstraints(minWidth: getRelativeWidth(0.41)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getRelativeWidth(0.03)),
                          child: Row(
                            children: [
                              Container(
                                  padding:
                                      EdgeInsets.all(getRelativeWidth(0.025)),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          kCategoriesPrimaryColor[index],
                                          kCategoriesSecondryColor[index],
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(
                                    category.getIconData(),
                                    color: Colors.white,
                                    size: getRelativeWidth(0.050),
                                  )),
                              SizedBox(width: getRelativeWidth(0.02)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                        fontSize: getRelativeWidth(0.038),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: getRelativeHeight(0.005)),
                                  Text(
                                    category.numOfDoctors > 1
                                        ? category.numOfDoctors.toString() +
                                            " doktora"
                                        : category.numOfDoctors.toString() +
                                            " doktor",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.48),
                                        fontSize: getRelativeWidth(0.03)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: getRelativeWidth(0.04))
                    ],
                  );
                },
              );
            }

            return Center(child: UpgradedCircularProgressIndicator());
          },
        ));
  }
}
