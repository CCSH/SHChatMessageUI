//
//  SuAblumInfo.m
//  LazyWeather
//
//  Created by KevinSu on 15/12/6.
//  Copyright (c) 2015年 SuXiaoMing. All rights reserved.
//

#import "SHAblumInfo.h"

@implementation SHAblumInfo

+ (instancetype)infoFromResult:(PHFetchResult *)result collection:(PHAssetCollection *)collection {
    SHAblumInfo * ablumInfo = [[SHAblumInfo alloc]init];
    ablumInfo.ablumName = collection.localizedTitle;
    ablumInfo.count = result.count;
    ablumInfo.coverAsset = result[0];
    ablumInfo.assetCollection = collection;
    return ablumInfo;
}

@end
