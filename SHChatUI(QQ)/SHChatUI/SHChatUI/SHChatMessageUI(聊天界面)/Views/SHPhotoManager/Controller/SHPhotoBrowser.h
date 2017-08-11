//
//  SHPhotoBrowser.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoBaseController.h"


/**
 相册浏览器
 */
@class PHAssetCollection;
@interface SHPhotoBrowser : SHPhotoBaseController

@property (nonatomic, copy) NSString * collectionTitle;
@property (nonatomic, strong) PHAssetCollection * assetCollection;

@end
