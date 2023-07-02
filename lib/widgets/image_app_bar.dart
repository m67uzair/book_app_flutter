import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:flutter/material.dart';

class ImageAppBar extends StatelessWidget {
  final String? category;
  final String title;

  const ImageAppBar({
    super.key,
    required this.title,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    bool showBackButton = Navigator.of(context).canPop();

    return Material(
      elevation: 2,
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/bookshelf.jpeg"), fit: BoxFit.cover)),
        child: Container(
          color: Colors.black45,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
            child: Row(
              mainAxisAlignment: showBackButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                if (showBackButton)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_sharp,
                      color: Colors.white,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: showBackButton ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      if (category != null)
                        Text(category ?? "", style: const TextStyle(fontSize: 12, color: Colors.white)),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: showBackButton ? 120 : null,
                        child: AutoSizeText(
                          category == null ? title.toUpperCase() : title,
                          textAlign: showBackButton ? TextAlign.end : null,
                          // softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          wrapWords: false,
                          style: category == null
                              ? kSubTitleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)
                              : kSubTitleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
    // Stack(children: [
    //   Image.asset(
    //     "assets/images/bookshelf.jpeg",
    //     width: MediaQuery.of(context).size.width,
    //     fit: BoxFit.cover,
    //   ),
    //   Positioned(
    //     right: 5,
    //     bottom: 20,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text("CATEGORY", style: kSubTitleStyle.copyWith(color: Colors.white.withOpacity(0.7), fontSize: 13)),
    //           const SizedBox(height: 5),
    //           SizedBox(
    //             width: 120,
    //             child: Text(
    //               title,
    //               textAlign: TextAlign.end,
    //               style: kSubTitleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
    //               maxLines: 2,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   )
    // ]);
  }
}
