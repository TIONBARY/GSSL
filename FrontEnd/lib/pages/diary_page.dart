import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(MaterialApp(

  debugShowCheckedModeBanner: false,
  home: GalleryApp()
));

class GalleryApp extends StatelessWidget {
  const GalleryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List img = [
      "https://cdn.imweb.me/upload/S201910012ff964777e0e3/62f9a36ea3cea.jpg",
      "https://www.ui4u.go.kr/depart/img/content/sub03/img_con03030100_01.jpg",
      "https://images.mypetlife.co.kr/content/uploads/2021/10/19151330/corgi-g1a1774f95_1280-1024x682.jpg",
      "http://image.dongascience.com/Photo/2022/06/6982fdc1054c503af88bdefeeb7c8fa8.jpg",
      "https://dimg.donga.com/wps/NEWS/IMAGE/2022/01/28/111500268.2.jpg",
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Gallery App",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 18.0,),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black,),
                  hintText: "Search for an Image",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  )
                ),
              ),
              SizedBox(height: 24.0,),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        itemCount: img.length,
                        itemBuilder: (context, index){
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(img[index], fit: BoxFit.fill,),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index){
                          return new StaggeredTile.count(1, index.isEven ? 1.2 : 2);
                        }
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
