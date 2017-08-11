//
//  SHActivityIndicatorView.h
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessage.h"


typedef void(^SHActivityClick)(SHMessage *message);

typedef enum {
    ShowActivityType_Activity = 1,//菊花标记
    ShowActivityType_Fail,//错误图片
}ShowActivityType;

@interface SHActivityIndicatorView : UIButton

@property (nonatomic, retain) SHMessage *message;

@property (nonatomic, copy) SHActivityClick activityClick;

- (void)showType:(ShowActivityType)type;

@end
