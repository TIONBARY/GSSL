import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:GSSL/model/response_models/get_walk_list.dart';
import 'package:flutter/material.dart';

class WalkPage extends StatelessWidget {
  const WalkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiWalk apiWalk = ApiWalk();
    ApiUser apiUser = ApiUser();
    ApiPet apiPet = ApiPet();
    return // 임시 버튼
        Column(
      children: [
        CircleAvatar(
          child: IconButton(
              onPressed: () async {
                WalkList list = await apiWalk.getWalkList();
                debugPrint(list.content!.toString());
              },
              icon: Icon(Icons.list)),
        ),
        CircleAvatar(
          child: IconButton(
              onPressed: () async {
                Detail result = await apiWalk.getWalkDetail(90);
                debugPrint(result.toJson().toString());
              },
              icon: Icon(Icons.details)),
        ),
        CircleAvatar(
          child: IconButton(
              onPressed: () async {
                getAllPet res = await apiPet.getAllPetApi();
                List<Pets>? pets = res.pets;
                if (pets != null) {
                  await apiWalk.modifyWalk(90, [1, 2, 3]);
                }
              },
              icon: Icon(Icons.mode_edit)),
        ),
        CircleAvatar(
          child: IconButton(
              onPressed: () async {
                await apiWalk.deleteWalk(77);
              },
              icon: Icon(Icons.delete)),
        ),
        CircleAvatar(
          child: IconButton(
              onPressed: () async {
                await apiWalk.deleteAllWalk([78, 79]);
              },
              icon: Icon(Icons.delete_sweep_rounded)),
        ),
      ],
    );
  }
}

class ImageDetails {
  final String imagePath;
  final String disease;
  final String date;
  final String title;
  final String details;

  ImageDetails({
    required this.imagePath,
    required this.disease,
    required this.date,
    required this.title,
    required this.details,
  });
}
