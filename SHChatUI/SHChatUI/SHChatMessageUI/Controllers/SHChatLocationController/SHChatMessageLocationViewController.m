//
//  SHChatMessageLocationViewController.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/8.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHChatMessageLocationViewController.h"
#import "SHMessageMacroHeader.h"
#import <MapKit/MapKit.h>
#import "SHLocation.h"

@interface SHChatMessageLocationViewController ()<MKMapViewDelegate,UIAlertViewDelegate>
{
    //地图
    MKMapView *_mapView;
    //定位
    CLLocationManager *locationManager;
    
    CLGeocoder *_geocoder;
}

@end

@implementation SHChatMessageLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"位置定位";
    
    _geocoder=[[CLGeocoder alloc]init];
    
    //如果定位功能不能使用需要在Info.plist中加入两个缺省没有的字段：
//    NSLocationAlwaysUsageDescription
//    NSLocationWhenInUseUsageDescription
    
    //判断定位用户权限
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways://一直获取

            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse://使用期间
       
            break;
        case kCLAuthorizationStatusDenied://用户禁止
        {
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"" message:@"定位权限受限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        }
            
            break;
        case kCLAuthorizationStatusNotDetermined://未做决定
        {
            //获取权限
            locationManager = [[CLLocationManager alloc]init];
            //使用期间使用 NSLocationWhenInUseUsageDescription
            [locationManager requestWhenInUseAuthorization];
            //一直使用 NSLocationAlwaysUsageDescription
//            [locationManager requestAlwaysAuthorization];
        }
            break;
        case kCLAuthorizationStatusRestricted://受限制
        {
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"" message:@"定位权限受限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        }

            break;  
        default:      
            break;
    }
    
    //绘制地图
    [self initMapUI];
    
    if (self.locationType == SHMessageLocationType_Location) {//定位
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];

        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.message = [[SHMessage alloc]init];
        
    }else if (self.locationType == SHMessageLocationType_Look){//查看
        
        SHLocation *location = [[SHLocation alloc]init];
        location.coordinate = self.message.location.coordinate;
        //点击大头针的标题
        location.title = self.message.locationName;
        //将坐标添加到地图上
        [_mapView addAnnotation:location];
        
        //显示区域
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.message.location.coordinate, 1000, 1000);
        //重新设置地图视图的显示区域
        [_mapView setRegion:viewRegion animated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加地图控件
-(void)initMapUI{
    
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    
    if (self.locationType == SHMessageLocationType_Location) {//定位
        //跟踪类型:userTrackingMode
//        MKUserTrackingModeNone :不进行用户位置跟踪；
//        MKUserTrackingModeFollow :跟踪用户位置；
//        MKUserTrackingModeFollowWithHeading :跟踪用户位置并且跟踪用户前进方向；
        
        _mapView.userTrackingMode = MKUserTrackingModeFollow;

        // 显示交通状态
//        _mapView.showsTraffic = YES;
        // 显示建筑物
//        _mapView.showsBuildings = YES;
        //显示用户位置
//        _mapView.showsUserLocation = YES;
        // 显示罗盘
        _mapView.showsCompass = YES;

        //代理
        _mapView.delegate = self;
        
    }
    //地图类型:mapType
//    MKMapTypeStandard :标准地图，一般情况下使用此地图即可满足；
//    MKMapTypeSatellite ：卫星地图；MKMapTypeHybrid ：混合地图，加载最慢比较消耗资源；
    _mapView.mapType = MKMapTypeStandard;
    // 显示标尺
    _mapView.showsScale = YES;
    
    [self.view addSubview:_mapView];
}

#pragma mark - 发送点击
- (void)rightClick{
    
    //发送位置
    if ([_delegate respondsToSelector:@selector(sendCLLocation:LocationName:)]) {
        [_delegate sendCLLocation:self.message.location LocationName:self.message.locationName];
    }
    //隐藏
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    [self getAddressByLocation:userLocation.location];
    
    self.message.location = userLocation.location;
    
}

#pragma mark 定位失败
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"定位失败%@",error);

}

#pragma mark 设置大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    

    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    // 设置大头针颜色
    annotationView.pinColor = MKPinAnnotationColorRed ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    
    return annotationView;
    
}


#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
//        CLPlacemark *placemark=[placemarks firstObject];
//        
//        CLLocation *location=placemark.location;//位置
//        CLRegion *region=placemark.region;//区域
//        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//        //        NSString *name=placemark.name;//地名
//        //        NSString *thoroughfare=placemark.thoroughfare;//街道
//        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
//        //        NSString *locality=placemark.locality; // 城市
//        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
//        //        NSString *administrativeArea=placemark.administrativeArea; // 州
//        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
//        //        NSString *postalCode=placemark.postalCode; //邮编
//        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
//        //        NSString *country=placemark.country; //国家
//        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
//        //        NSString *ocean=placemark.ocean; // 海洋
//        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
- (void)getAddressByLocation:(CLLocation *)location{
    
    //反地理编码
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
       
        self.message.locationName = placemark.name;

        //存在地址
        if (self.message.locationName.length) {
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];

            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

- (void)dealloc{
    _mapView = nil;
}


@end
