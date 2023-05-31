import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as IMG;

class EditImage {
  Future<Uint8List> ReduceImageQualityAndSize(String path) async {
    Uint8List image = File(path).readAsBytesSync();
    int maxInBytes = 20000;
    Uint8List resizedData = Uint8List.fromList(image);

    IMG.Image? img = await IMG.decodeImage(image);
    int size = await image.lengthInBytes;
    int quality = 100;

    print("size max: " + maxInBytes.toString());
    print("size before: " + size.toString() + " bytes");

    while (size > maxInBytes && quality > 10) {
      // reduce image size about 10% of image, until the size is less than the maximum limit
      quality = (quality - (quality * 0.1)).toInt();
      int width = img!.width - (img.width * 0.1).toInt();
      IMG.Image resized = await IMG.copyResize(img, width: width);
      resizedData =
          await Uint8List.fromList(IMG.encodeJpg(resized, quality: quality));
      size = await resizedData.lengthInBytes;
      img = resized;
    }

    print("size after: " + size.toString() + " bytes");

    return resizedData;
  }
}
