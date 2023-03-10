
import 'package:bike_adventure/constants/systems.dart';
import 'package:bike_adventure/side_menu/widgets/card_picture.dart';
import 'package:bike_adventure/utils/utils.dart';
import 'package:bike_adventure/widget/gallery_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ViewAddPicture extends StatefulWidget {
  const ViewAddPicture(
      {Key? key, required this.images})
      : super(key: key);
  final List<GalleryItem> images;
  // final String mainImage;

  @override
  _ViewAddPictureState createState() => _ViewAddPictureState();
}

class _ViewAddPictureState extends State<ViewAddPicture> {
  int mainIndex = 0; //메인사진인데 추후 개발
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () {
          Get.back();
        }),
    leadingWidth: 40,
    title: const Text(
      '사진 등록하기',
      style: TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: _buildMainPictures(),
    ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomSheet: Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Container()),
      floatingActionButton: FloatingActionButton(
    onPressed: () async {
      // final file = await takePicture();
      // Get.back(result: file?.path);

      // // show loader
      // presentLoader(context, text: 'Wait...');
      //
      // // calling with dio
      // var responseDataDio =
      //     await _dioUploadService.uploadPhotos(_images);
      //
      // // calling with http
      // var responseDataHttp = await _httpUploadService
      //     .uploadPhotos(_images);
      //
      // // hide loader
      // Navigator.of(context).pop();
      //
      // // showing alert dialogs
      // await presentAlert(context,
      //     title: 'Success Dio',
      //     message: responseDataDio.toString());
      // await presentAlert(context,
      //     title: 'Success HTTP',
      //     message: responseDataHttp);

      GalleryItem item = GalleryItem(id: 0, resource: widget.images[mainIndex].resource);
      Get.back(
        result: item,
      );
    },
    child: const Icon(Icons.app_registration_rounded),
      ),
    );
  }

  Widget _buildMainPictures() {
    return GridView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      children: [
            CardPicture(
              widthRate: widget.images.isNotEmpty
                  ? ADD_QUEST_PICTURE_FIRST_SIZE_RATE
                  : ADD_QUEST_PICTURE_NONE_SIZE_RATE,
              // onCameraTap: () async {
              //   final String? imagePath = await Get.to(() => TakePhoto(
              //         camera: _cameraDescription,
              //       ));
              //
              //   print('imagepath: $imagePath');
              //   if (imagePath != null) {
              //     setState(() {
              //       _images.add(imagePath);
              //     });
              //   }
              // },
              onPhotoTap: () async {
                if (widget.images.length >= 10) {
                  pushSnackbar('사진', '10장 이상 업로드 할 수 없습니다');
                  return;
                }
                final XFile? image = await getImagePicker(source: ImageSource.camera);
                if (image != null && image.path.isNotEmpty) {
                  setState(() {
                    GalleryItem item =
                        GalleryItem(id: 0, resource: image.path);
                    widget.images.add(item);
                  });
                }
              },
              onImageTap: () async {
                if (widget.images.length >= 10) {
                  pushSnackbar('사진', '10장 이상 업로드 할 수 없습니다');
                  return;
                }
                final XFile? image = await getImagePicker(source: ImageSource.gallery);
                if (image != null && image.path.isNotEmpty) {
                  setState(() {
                    GalleryItem item =
                        GalleryItem(id: 0, resource: image.path);
                    widget.images.add(item);
                  });
                }
              },
            ),
            // CardPicture(),
            // CardPicture(),
          ] +
          widget.images
              .map((GalleryItem item) => CardPicture(
                    imagePath: item.resource,
                    onImageTap: () {
                      mainIndex = widget.images.indexOf(item);
                    },
                    onRemoveTap: () {
                      setState(() {
                        int index = widget.images.indexOf(item);
                        if (index == mainIndex) {
                          mainIndex = 0;
                        }
                        widget.images.removeAt(index);
                      });
                    },
                  ))
              .toList(),
    );
  }
}
