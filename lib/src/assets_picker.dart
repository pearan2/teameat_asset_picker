import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_assets_picker/src/widget/insta_asset_picker_delegate.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class InstaAssetPicker {
  DefaultAssetPickerProvider provider =
      DefaultAssetPickerProvider(requestType: RequestType.image);
  InstaAssetPickerBuilder? builder;

  void dispose() {
    provider.dispose();
    builder?.dispose();
  }

  /// Returns `true` if the param are not matching the [provider] params
  bool isDifferentProvider({
    int? maxAssets,
    int? pageSize,
    ThumbnailSize? pathThumbnailSize,
    SortPathDelegate<AssetPathEntity>? sortPathDelegate,
    bool? sortPathsByModifiedDate,
    FilterOptionGroup? filterOptions,
  }) {
    return provider.maxAssets != maxAssets ||
        provider.pageSize != pageSize ||
        provider.pathThumbnailSize != pathThumbnailSize ||
        provider.sortPathDelegate != sortPathDelegate ||
        provider.sortPathsByModifiedDate != sortPathsByModifiedDate ||
        provider.filterOptions != filterOptions;
  }

  Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    Key? key,
    bool useRootNavigator = true,
    AssetPickerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
    int gridCount = 4,
    DefaultAssetPickerProvider? defaultProvider,
    ThemeData? pickerTheme,
    AssetPickerTextDelegate? textDelegate,
    String? title,
    required Function(Future<InstaAssetsExportDetails> exportDetails)
        onCompleted,
    Function(double progress)? onProgress,
    List<InstaAssetsCrop>? initialCropParameters,

    /// DefaultAssetPickerProvider options
    int maxAssets = defaultMaxAssetsCount,
    int pageSize = defaultAssetsPerPage,
    ThumbnailSize pathThumbnailSize = defaultPathThumbnailSize,
    SortPathDelegate<AssetPathEntity>? sortPathDelegate =
        SortPathDelegate.common,
    bool sortPathsByModifiedDate = false,
    FilterOptionGroup? filterOptions,
    Duration initializeDelayDuration = const Duration(milliseconds: 250),
  }) async {
    assert(
        defaultProvider == null ||
            defaultProvider.requestType == RequestType.image,
        'Only images can be shown in the picker for now');

    if (defaultProvider != null &&
        isDifferentProvider(
          maxAssets: defaultProvider.maxAssets + provider.selectedAssets.length,
          pageSize: defaultProvider.pageSize,
          pathThumbnailSize: defaultProvider.pathThumbnailSize,
          sortPathDelegate: defaultProvider.sortPathDelegate,
          sortPathsByModifiedDate: defaultProvider.sortPathsByModifiedDate,
          filterOptions: defaultProvider.filterOptions,
        )) {
      provider = defaultProvider;
    } else if (isDifferentProvider(
      maxAssets: maxAssets,
      pageSize: pageSize,
      pathThumbnailSize: pathThumbnailSize,
      sortPathDelegate: sortPathDelegate,
      sortPathsByModifiedDate: sortPathsByModifiedDate,
      filterOptions: filterOptions,
    )) {
      provider = DefaultAssetPickerProvider(
        maxAssets: maxAssets,
        pageSize: pageSize,
        pathThumbnailSize: pathThumbnailSize,
        requestType: RequestType.image,
        sortPathDelegate: sortPathDelegate,
        sortPathsByModifiedDate: sortPathsByModifiedDate,
        filterOptions: filterOptions,
        initializeDelayDuration: initializeDelayDuration,
      );
    }

    builder = InstaAssetPickerBuilder(
      provider: provider,
      title: title,
      gridCount: gridCount,
      pickerTheme:
          pickerTheme ?? AssetPicker.themeData(Theme.of(context).primaryColor),
      textDelegate: textDelegate,
      initialCropParameters: initialCropParameters,
      onCompleted: onCompleted,
      onProgress: onProgress,
    );

    return AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder!,
    );
  }
}