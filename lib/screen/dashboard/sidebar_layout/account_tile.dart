import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  final String? name;
  final NetworkImage? image;
  const AccountTile({Key? key, required this.name, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: SizeConfig.getWidthSize(8.5),
                backgroundImage: image,
                backgroundColor: Colors.white,
                child: (image == null)
                    ? Icon(
                        Icons.person,
                        color: kPrimaryColor,
                        size: SizeConfig.getWidthSize(10),
                      )
                    : Container(),
              ),
            ),
            SizedBox(height: 5),
            Text(
              name!,
              style: TextStyle(
                  fontSize: SizeConfig.getWidthSize(5.5),
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
