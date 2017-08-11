//
//  SHPhotoPicker.h
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright (c) 2015年 SHXiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPhotoPicker : UIView

//最大选择数,默认为20
@property (nonatomic, assign) NSInteger selectedCount;

//最大预览数,默认为20
@property (nonatomic, assign) NSInteger preViewCount;

/**
 弹出图片选择器

 @param sender sender
 
 sender:需要弹出图片选择器的VC
 sender:无tabbar传入当前VC
 sender:无tabbar且需要遮盖导航栏传入VC.navigationController
 sender:有tabbar需传入VC.tabbarController
 
 @param block 回调（图片数组)
 */
- (void)showPhotoPickerInSender:(UIViewController *)sender block:(void(^) (NSArray <NSArray *>*images,BOOL isHide))block;

/**
 消失
 */
- (void)dismissPhotoPicker;

@end
