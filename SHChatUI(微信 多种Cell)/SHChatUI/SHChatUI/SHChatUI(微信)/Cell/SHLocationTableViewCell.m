//
//  SHLocationTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHLocationTableViewCell.h"
#import "SHLocation.h"

@interface SHLocationTableViewCell ()

// location
@property (nonatomic, retain) MKMapView *locView;
// location 名称
@property (nonatomic, retain) UILabel *locName;

@end

@implementation SHLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(SHMessageFrame *)messageFrame{
    [super setMessageFrame:messageFrame];
    
    SHMessage *message = messageFrame.message;
    
    SHLocation *location = [[SHLocation alloc]init];
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = message.lon;
    coordinate.latitude = message.lat;
    
    location.coordinate = coordinate;
    //点击大头针的标题
    location.title = message.locationName;
    //将坐标添加到地图上
    [self.locView addAnnotation:location];
    
    //显示区域
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    //重新设置地图视图的显示区域
    [self.locView setRegion:viewRegion animated:YES];
    
    self.locName.text = message.locationName;
    
    //设置frame
    self.locView.size = CGSizeMake(self.btnContent.width, self.btnContent.height);
    self.locName.frame = CGRectMake(self.isSend?0:kChat_angle_w, self.locView.height - 30, self.locView.width - kChat_angle_w, 30);
    
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (self.isSend) {
        image = [SHFileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        image = [SHFileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self.btnContent setBackgroundImage:image forState:UIControlStateNormal];
    
    //编辑气泡
    [self.btnContent makeMaskView:self.locView image:image];
}

#pragma mark 位置消息视图
- (MKMapView *)locView{
    //位置背景
    if (!_locView) {
        _locView = [[MKMapView alloc]init];
        _locName.origin = CGPointMake(0, 0);
        _locView.mapType = MKMapTypeStandard;
        _locView.userInteractionEnabled = NO;
        [self.btnContent addSubview:_locView];
    }
    return _locView;
}

- (UILabel *)locName{
    //位置文字
    if (!_locName) {
        _locName = [[UILabel alloc]init];
        _locName.textColor = [UIColor whiteColor];
        _locName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _locName.font = [UIFont systemFontOfSize:14];
        _locName.numberOfLines = 1;
        _locName.textAlignment = NSTextAlignmentCenter;
        [self.btnContent addSubview:_locName];
    }
    return _locName;
}

@end
