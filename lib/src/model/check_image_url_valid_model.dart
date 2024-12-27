class CheckImageUrlValidResult {
  bool? result;
  int? imageWidth;
  int? imageHeight;

  CheckImageUrlValidResult({
    this.result,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  String toString() {
    return 'CheckImageUrlValidResult{result: $result, imageWidth: $imageWidth, imageHeight: $imageHeight}';
  }
}
