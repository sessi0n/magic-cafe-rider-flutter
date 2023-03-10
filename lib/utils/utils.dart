import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:bike_adventure/tabs/details/gallery_photo_view_wrapper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:bike_adventure/constants/environment.dart';
import 'package:bike_adventure/constants/urls.dart';
import 'package:bike_adventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

getImageUrl(String url) {
  if (url.isNotEmpty) {
    return NetworkImage(url);
  }

  return AssetImage(url);
}

pushSnackbar(title, msg) {
  Get.snackbar(
    title,
    msg,
    icon: const Icon(Icons.person, color: Colors.black),
    snackPosition: SnackPosition.BOTTOM,
    // forwardAnimationCurve: Curves.elasticInOut,
    // reverseAnimationCurve: Curves.easeOut,
    margin: const EdgeInsets.all(15),
    duration: const Duration(seconds: 2),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    backgroundColor: Colors.white,
  );
}

getTextColor(bgColor) {
  return bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

launchURL(url) async {
  if (Platform.isIOS) {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch ' + url;
      }
    }
  } else {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

AnyLinkPreview buildAnyOnlyLink(url) {
  return AnyLinkPreview(
    link: url,
    // proxyUrl: url,
    // placeholderWidget: Text('Loading'),
    displayDirection: UIDirection.uiDirectionVertical,
    showMultimedia: false,
    bodyMaxLines: 1,
    bodyTextOverflow: TextOverflow.ellipsis,
    titleStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    ),
    bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
    errorBody: 'Show my custom error body',
    errorTitle: 'Show my custom error title',
    errorWidget: InkWell(
      onTap: () async {
        var uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
      },
      child: Container(
        color: Colors.grey[300],
        child: Center(child: Text(url ?? 'Oops! Not Loading')),
      ),
    ),
    errorImage: "https://google.com/",
    cache: const Duration(days: 7),
    backgroundColor: Colors.white,
    // borderRadius: 3,
    // borderRadius: const BorderRadius.all(Radius.circular(3.0)),
    removeElevation: true,
    // boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
    // boxShadow: const [
    //   BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
    // ],

    onTap: () async {
      var uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
    }, // This disables tap event
  );
}


void gotoUpdate(appPackageName) async {
  await Future.delayed(const Duration(seconds: 2));
  // LaunchReview.launch(
  //   androidAppId: "com.takeoff.rider_adventure",
  //   iOSAppId: "585027354",
  // );
  try {
    launchUrlString("market://details?id=" + appPackageName);
  } on PlatformException catch (e) {
    launchUrlString("https://play.google.com/store/apps/details?id=" + appPackageName);
  } finally {
    launchUrlString("https://play.google.com/store/apps/details?id=" + appPackageName);
  }
}

String getProfileImageUrl(User user) {
  if (user.roadSignUrl.isEmpty || user.roadSignFile.isEmpty) {
    return defaultProfileImg;
  }

  return Environment.cdnUrl + user.roadSignUrl + '/' + user.roadSignFile;
}

// String getGateFrontImageUrl(String? url) {
//   if (url == null || url.isEmpty) {
//     return defaultProfileImg;
//   }
//
//   return Environment.cdnUrl + url;
// }

getDefaultBGImg() {
  return defaultProfileImg;
}

Future<XFile?> getImagePicker({source}) async {
  return await ImagePicker().pickImage(
      source: source, imageQuality: 30, maxHeight: 600, maxWidth: 800);
}

Future<List<XFile>?> getMultiImagePicker() async {
  return await ImagePicker().pickMultiImage(
    maxWidth: 600,
    maxHeight: 800,
    imageQuality: 30,
  );
}

getSaleDateText(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

bool isInSaleDate(DateTime end) {
  DateTime now = DateTime.now();
  return end.isAfter(now);
}

bool getUrlValid(String url) {
  bool _isUrlValid = AnyLinkPreview.isValidLink(
    url,
    protocols: ['http', 'https'],
    // hostWhitelist: ['https://youtube.com/'],
    // hostBlacklist: ['https://facebook.com/'],
  );
  return _isUrlValid;
}

AnyLinkPreview buildAnyLinkPreviewHorizontal(url) {
  return AnyLinkPreview(
    link: url,
    // proxyUrl: url,
    // placeholderWidget: Text('Loading'),
    displayDirection: UIDirection.uiDirectionHorizontal,
    showMultimedia: true,
    bodyMaxLines: 5,
    bodyTextOverflow: TextOverflow.ellipsis,
    titleStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    ),
    bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
    errorBody: 'Show my custom error body',
    errorTitle: 'Show my custom error title',
    errorWidget: InkWell(
      onTap: () async {
        var uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
      },
      child: Container(
        color: Colors.grey[300],
        child: Center(child: Text(url ?? 'Oops! Not Loading')),
      ),
    ),
    errorImage: "https://google.com/",
    cache: const Duration(days: 7),
    backgroundColor: Colors.white,
    borderRadius: 0,
    // borderRadius: const BorderRadius.all(Radius.circular(3.0)),
    removeElevation: false,
    // boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
    // boxShadow: const [
    //   BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
    // ],

    onTap: () async {
      var uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
    }, // This disables tap event
  );
}

AnyLinkPreview buildAnyLinkPreview(url) {
  return AnyLinkPreview(
    link: url,
    // proxyUrl: url,
    // placeholderWidget: Text('Loading'),
    displayDirection: UIDirection.uiDirectionVertical,
    showMultimedia: true,
    bodyMaxLines: 5,
    bodyTextOverflow: TextOverflow.ellipsis,
    titleStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    ),
    bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
    errorBody: 'Show my custom error body',
    errorTitle: 'Show my custom error title',
    errorWidget: InkWell(
      onTap: () async {
        var uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
      },
      child: Container(
        color: Colors.grey[300],
        child: Center(child: Text(url ?? 'Oops! Not Loading')),
      ),
    ),
    errorImage: "https://google.com/",
    cache: const Duration(days: 7),
    backgroundColor: Colors.white,
    // borderRadius: 3,
    // borderRadius: const BorderRadius.all(Radius.circular(3.0)),
    removeElevation: true,
    // boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
    // boxShadow: const [
    //   BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
    // ],

    onTap: () async {
      var uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication)) throw 'Could not launch $uri';
    }, // This disables tap event
  );
}

getMyPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}

void openPicture(BuildContext context, int index, galleryItems) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        galleryItems: galleryItems,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        initialIndex: index,
        scrollDirection: Axis.horizontal,
        needDeleteButton: false,
      ),
    ),
  );
}
