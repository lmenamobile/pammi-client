import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Banner.dart';
import 'package:wawamko/src/Models/Campaign.dart';
import 'package:wawamko/src/Utils/Strings.dart';

Widget itemHighlights(Banners item){
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: Stack(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: FadeInImage(
              image: NetworkImage(item.image!),
              fit: BoxFit.cover,
              placeholder: AssetImage(''),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 50  ,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black45,
                    Colors.black54,
                  ],
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.name??'',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        height: 1.2,
                        fontSize: 18,
                        fontFamily: Strings.fontBold,
                        color: Colors.white),
                  ),
                ),
                Image.asset("Assets/images/ic_see.png",width: 30,height: 30,)
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget itemCampaigns(Campaign item,Function action){
  return InkWell(
    onTap: ()=>action(item),
    child: Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: FadeInImage(
                image: NetworkImage(item.image!),
                fit: BoxFit.cover,
                placeholder: AssetImage(''),
                imageErrorBuilder: (_,__,___){
                  return Container();
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 50  ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black45,
                      Colors.black54,
                    ],
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.campaign??'',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1.2,
                          fontSize: 18,
                          fontFamily: Strings.fontBold,
                          color: Colors.white),
                    ),
                  ),
                  Image.asset("Assets/images/ic_see.png",width: 30,height: 30,)
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}