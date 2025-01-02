import 'dart:typed_data';

class LoadImageModel {
  bool? result;
  int? imageWidth;
  int? imageHeight;
  Uint8List? byteArray;

  LoadImageModel({
    this.result,
    this.imageWidth,
    this.imageHeight,
    this.byteArray,
  });
}
