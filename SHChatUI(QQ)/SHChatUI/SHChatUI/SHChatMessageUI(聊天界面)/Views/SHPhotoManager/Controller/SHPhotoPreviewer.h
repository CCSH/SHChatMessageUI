//
//  SHPhotoPreviewPage.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/8.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoBaseController.h"

@class PHAsset;
@interface SHPhotoPreviewer : SHPhotoBaseController

@property (nonatomic, strong) PHAsset * selectedAsset; //初始显示的图片
@property (nonatomic, strong) NSArray * previewPhotos;
@property (nonatomic, assign) BOOL isPreviewSelectedPhotos;
@property (nonatomic, copy) void(^backBlock)();
@property (nonatomic, copy) void(^doneBlock)();

@end
