//
//  SHActivityIndicatorView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActivityIndicatorView.h"

#define VIEW_SIZE 20

@interface SHActivityIndicatorView ()<UIAlertViewDelegate>

//失败按钮
@property (nonatomic, strong) UIButton *failBtn;
//菊花图标
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation SHActivityIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (UIButton *)failBtn{
    if (!_failBtn) {
        //失败图标
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _failBtn.hidden = YES;
        _failBtn.opaque = YES;
        [_failBtn setBackgroundImage:[UIImage imageNamed:@"message_fail.png"] forState:0];
        [self addSubview:_failBtn];
    }
    return _failBtn;
    
}

- (UIActivityIndicatorView *)activity{
    if (!_activity) {
        //菊花图标
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.opaque = YES;
        _activity.hidden = YES;
        [self addSubview:_activity];
    }
    return _activity;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    
    self.failBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.activity.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
}

#pragma mark - 显示操作
- (void)showType:(ShowActivityType)type{
    switch (type) {
        case ShowActivityType_Activity://菊花
            [self showActivity];
            break;
        case ShowActivityType_Fail://失败
            [self showFail];
            break;
        default:
            break;
    }
}

#pragma mark - 显示菊花
- (void)showActivity{
    _failBtn.hidden = YES;
    _activity.hidden = NO;
    [_activity startAnimating];
    
}
#pragma mark - 显示失败
- (void)showFail{
    _failBtn.hidden = NO;
    _activity.hidden = YES;
    [_activity stopAnimating];
}


@end
