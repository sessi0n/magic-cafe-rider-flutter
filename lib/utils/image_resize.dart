// Future<bool> resizeImage1() async{
//   for(var i = 0; i < images.length; i ++) {
//
//     AssetEntity entity = images[i];
//     File file = await entity.file;
//     var path2 = file.path;
//     var width;
//     var height;
//
//     var decodedImage = await decodeImageFromList(file.readAsBytesSync());
//
//     if(Platform.isAndroid) {
//       width = decodedImage.width;
//       height = decodedImage.height;
//     } else {
//       width = entity.width;
//       height = entity.height;
//     }
//
//     if(width < 500 || height < 500) {
//       _resizeImages.add(await resizeImage2(path2, width, height, i));
//     }
//     else if(width < height) {
//
//       var ratio2 = (height/width).toStringAsFixed(3);
//       var newValue2 = 500*double.parse(ratio2);
//
//       _resizeImages.add(await resizeImage2(path2, 500, newValue2, i));
//
//     } else if(height < width) {
//
//       var ratio2 = (width/height).toStringAsFixed(3);
//       var newValue2 = 500*double.parse(ratio2);
//       _resizeImages.add(await resizeImage2(path2, newValue2, 500,i));
//
//     } else {
//       _resizeImages.add(await resizeImage2(path2, 500, 500,i));
//     }
//   }
//   return true;
// }
//
//
// resizeImage2(String path, width, height, index) async {
//   Uint8List data = await File(path).readAsBytes();
//   var roundWidth = width.round();
//   var roundHeight = height.round();
//   File imagePath = File(path);
//
//   var isHEIC = '${imagePath.path.substring(imagePath.path.length-4,imagePath.path.length)}';
//
//   if(isHEIC == 'HEIC'||isHEIC == 'heic') {
//     String jpegPath = await HeicToJpg.convert(imagePath.path);
//     imagePath = File(jpegPath);
//   }
//
//   var realExt = p.extension('$imagePath');
//
//   Im.Image image = Im.decodeImage(imagePath.readAsBytesSync());
//   Im.Image smallerImage = Im.copyResize(image, width:roundWidth, height: roundHeight);
//
//
//   var directory;
//   var appPath;
//   var realPath;
//   if (Platform.isIOS) {
//     directory = await getApplicationDocumentsDirectory();
//     appPath = directory.path;
//     realPath = "$appPath/userPhotos";
//   } else {
//     directory = await getExternalStorageDirectory();
//     appPath = directory.path;
//     realPath = "$appPath/userPhotos";
//   }
//
//
//   Directory(realPath).create().then((Directory directory) {});
//   var pos = realExt.lastIndexOf("'");
//   realExt = (pos != -1)? realExt.substring(0, pos): realExt;
//
//   File writeImage = new File('$realPath/$index$realExt')..writeAsBytes(await Im.encodeNamedImage(smallerImage, realExt));
//   return writeImage;
// }
