import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomListTileV1 extends StatelessWidget {
  final dynamic? value;
  final String groupName;
  final String kelurahan;
  final String kecamatan;
  final String bulan;
  final String tahun;
  final Function? onTap;
  const CustomListTileV1({
    Key? key,
    this.value,
    this.groupName = "Group Name",
    this.kecamatan = "Kecamatan",
    this.kelurahan = "Kelurahan",
    this.bulan = "0",
    this.tahun = "0000",
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: InkWell(
          onTap: () => this.onTap!(this.value),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.getWidthSize(80),
                        child: Text(
                          this.groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        this.kelurahan + "/" + this.kecamatan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: txtSecondColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        ((this.bulan.length < 2) ? '0': '') + this.bulan + "/" + this.tahun,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: txtSecondColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
