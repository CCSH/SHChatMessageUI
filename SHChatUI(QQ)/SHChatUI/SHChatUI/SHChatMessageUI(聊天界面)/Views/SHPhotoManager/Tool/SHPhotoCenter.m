//
//  SHPhotoCenter.m
//  SHPhotoPickerDemo
//
//  Created by 万众科技 on 16/5/3.
//  Copyright © 2016年 KevinSH. All rights reserved.
//

#import "SHPhotoCenter.h"
#import "SHPhotoHeader.h"
#import "SHMessageMacroHeader.h"

@interface SHPhotoCenter () <PHPhotoLibraryChangeObserver, UIAlertViewDelegate>

@end

@implementation SHPhotoCenter

+ (instancetype)shareCenter {
    static SHPhotoCenter * center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[SHPhotoCenter alloc]init];
        center.selectedPhotos = [NSMutableArray array];
    });
    return center;
}

#pragma mark - 获取所有图片
- (void)fetchAllAsset {
    [self clearInfos];
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    [self photoLibaryAuthorizationValid];
}

- (void)reloadPhotos {
    self.allPhotos = [[SHPhotoManager manager]fetchAllAssets];
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoLibraryChangeNotification object:nil];
}

#pragma mark - 完成图片选择
- (void)endPickWithImage:(UIImage *)cameraPhoto info:(NSDictionary *)info{
    if (self.handle) self.handle(@[@[[SHDataConversion imageToData:cameraPhoto CompressionNum:1],info]],YES);
}

- (void)endPick {
    if (self.handle) {
        [[SHPhotoManager manager]fetchImagesWithAssetsArray:self.selectedPhotos isOriginal:self.isOriginal completeBlock:^(NSArray *images) {
            [self.selectedPhotos removeAllObjects];
            self.handle(images,YES);
        }];
    }
}

- (void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
}

- (BOOL)isReachMaxSelectedCount {
    if (self.selectedPhotos.count >= self.selectedCount) {

        NSLog(@"你最多可以选择%ld",(long)self.selectedCount);
        return YES;
    }
    return NO;
}

#pragma mark - 清除信息
- (void)clearInfos {
    self.isOriginal = NO;
    self.handle = nil;
    self.allPhotos = nil;
    [self.selectedPhotos removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听图片变化代理
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    //此代理方法里的线程非主线程
    [self reloadPhotos];
}

#pragma mark - 权限验证
- (void)photoLibaryAuthorizationValid {
    PHAuthorizationStatus authoriation = [PHPhotoLibrary authorizationStatus];
    if (authoriation == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //这里非主线程，选择完成后会出发相册变化代理方法
        }];
    }else if (authoriation == PHAuthorizationStatusAuthorized) {
        [self reloadPhotos];
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        });
    }
}

- (void)cameraAuthoriationValidWithHandle:(void(^)())handle {
    AVAuthorizationStatus authoriation = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authoriation == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handle) handle();
                });
            }
        }];
    }else if (authoriation == AVAuthorizationStatusAuthorized) {
        if (handle) handle();
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        });
    }
}

#pragma mark - AlertView代理
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSURL * setting = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:setting]) {
            [[UIApplication sharedApplication]openURL:setting];
        }
    }
}

@end
