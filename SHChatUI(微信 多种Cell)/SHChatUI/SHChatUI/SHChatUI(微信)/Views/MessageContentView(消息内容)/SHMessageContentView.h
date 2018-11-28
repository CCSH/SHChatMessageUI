//
//  SHMessageContentView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import "SHMessage.h"
#import "SHActivityIndicatorView.h"
#import "SHTextView.h"

@class SHActivityIndicatorView;
@interface SHMessageContentView : UIButton

//剪切视图
- (void)makeMaskView:(UIView *)view image:(UIImage *)image;

@end
