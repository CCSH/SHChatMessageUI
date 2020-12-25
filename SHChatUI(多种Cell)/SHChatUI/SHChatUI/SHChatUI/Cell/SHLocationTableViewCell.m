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
@property (nonatomic, strong) MKMapView *locView;
// location 名称
@property (nonatomic, strong) UILabel *locName;

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
    
    
    //设置内容
    [self.bubbleBtn setBubbleColor:[UIColor whiteColor]];
    
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
    CGFloat margin = messageFrame.startX;

    self.locName.frame = CGRectMake(margin + kChat_margin, 0, self.bubbleBtn.width - kChat_angle_w - 2*kChat_margin, 30);
    self.locView.frame = CGRectMake(margin, self.locName.maxY, self.bubbleBtn.width - kChat_angle_w, self.bubbleBtn.height - self.locName.height);
    
    //剪切
    [self.bubbleBtn makeMaskView];
}

#pragma mark 位置消息视图
- (MKMapView *)locView{
    //位置信息
    if (!_locView) {
        _locView = [[MKMapView alloc]init];
        _locView.mapType = MKMapTypeStandard;
        _locView.userInteractionEnabled = NO;
        [self.bubbleBtn addSubview:_locView];
    }
    return _locView;
}

- (UILabel *)locName{
    //位置文字
    if (!_locName) {
        _locName = [[UILabel alloc]init];
        _locName.textColor = [UIColor blackColor];
        _locName.font = [UIFont systemFontOfSize:14];
        _locName.numberOfLines = 1;
        _locName.textAlignment = NSTextAlignmentCenter;
        [self.bubbleBtn addSubview:_locName];
    }
    return _locName;
}

@end
