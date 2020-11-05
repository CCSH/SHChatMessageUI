//
//  SHMessageHelper.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMessageHelper.h"
#import "SHMessage.h"

#define TIME_Formatter @"yyyy-MM-dd HH:mm"
#define TIME_Formatter2 @"yyyy-MM-dd-HH-mm-ss-SSS"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_MONTH     2592000
#define D_YEAR      31556926

@implementation SHMessageHelper

#pragma mark - 获取零时区时间
+ (NSString *)getTimeWithZone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter2];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - 获取当前时区时间
+ (NSString *)getTimeWithCurrentZone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter2];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - 获取零时区转当前时区的时间
+ (NSString *)getCurrentTimeWithZone:(NSString *)zone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter];
    
    return [dateFormatter stringFromDate:[self getCurrentDateWithZone:zone]];
}

#pragma mark 获取零时区转当前时区的date
+ (NSDate *)getCurrentDateWithZone:(NSString *)zone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter2];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:zone];
}

#pragma mark - 获取零时区转当前时区的时间
+ (NSString *)getCurrentTimeWithCurrentZone:(NSString *)currentZone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter];
    
    return [dateFormatter stringFromDate:[self getCurrentDateWithCurrentZone:currentZone]];
}

#pragma mark 获取当前时区的date
+ (NSDate *)getCurrentDateWithCurrentZone:(NSString *)currentZone{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter2];
    
    return [dateFormatter dateFromString:currentZone];
}

#pragma mark - 添加公共参数
+ (SHMessage *)addPublicParameters{
    
    SHMessage *message = [[SHMessage alloc]init];
    
    return [self addPublicParametersWithMessage:message];
}

+ (SHMessage *)addPublicParametersWithMessage:(SHMessage *)message{
    
    message.messageId = [self getTimeWithZone];
    message.isRead = YES;
    message.messageRead = YES;
    message.messageState = SHSendMessageType_Sending;
    message.sendTime = [self getTimeWithZone];
    message.bubbleMessageType = arc4random()%2;
    
    if (message.bubbleMessageType == SHBubbleMessageType_Receiving) {
        message.messageState = SHSendMessageType_Successed;
        message.isRead = NO;
        message.messageRead = NO;
    }
    
    message.userId = @"123";
    message.userName = @"小明";
    message.avator = @"headImage";
    
    return message;
}

#pragma mark - 是否显示时间
+ (BOOL)isShowTimeWithTime:(NSString *)time setTime:(NSString *)setTime{
    
    if (!setTime.length) {
        return YES;
    }
    //大于5分钟进行显示
    if ([[self getCurrentDateWithZone:time] timeIntervalSinceDate:[self getCurrentDateWithZone:setTime]] > 1*D_MINUTE) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 获取聊天时间
+ (NSString *)getChatTimeWithTime:(NSString *)time{
    
    NSDate *date = [self getCurrentDateWithZone:time];
    NSDate *today = [NSDate date];
    
    NSString *timeText = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
    
    //当前
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday  fromDate:date];
    //今天
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    //昨天
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        
        return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
        
        //昨天
        return [NSString stringWithFormat:@"昨天 %@",timeText];
    } else {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc]init];
        //年月日
        [dateFormatter setDateFormat:TIME_Formatter];
        return [dateFormatter stringFromDate:date];
    }
}

#pragma mark - 获取Size
+ (CGSize)getSizeWithMaxSize:(CGSize)maxSize size:(CGSize)size{
    
    //规定的宽高都小于最大的 则使用规定的
    if (MIN(size.width, size.height)) {
        
        if (size.width > size.height) {
            //宽大 按照宽给高
            CGFloat width = MIN(maxSize.width, size.height);
            return CGSizeMake(width, width*size.height/size.width);
        }else{
            //高大 按照高给宽
            CGFloat height = MIN(maxSize.height, size.height);
            return  CGSizeMake(height*size.width/size.height, height);
        }
    }
    
    return maxSize;
}

#pragma mark - 获取文本高度
- (CGFloat)getHeightWithTextView:(UITextView *)textView maxH:(CGFloat)maxH minH:(CGFloat)minH{
    
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [textView.text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:textView.font}
                                              context:nil];
    
    CGFloat textHeight = size.size.height + 22;
    
    if (textHeight < minH) {
        
        return minH;
    }else if (textHeight > maxH){
        
        return maxH;
    }else{
        
        return textHeight;
    }
}

#pragma mark - 获取视频第一帧图片
+ (UIImage *)getVideoImage:(NSString *)path {
    
    if (!path.length){
        return nil;
    }
    
    AVURLAsset *asset;
    if ([path hasPrefix:@"http"]) {//网络
        
        asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:path] options:nil];
    }else{//本地
        
        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    }
    
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError ==== %@", thumbnailImageGenerationError);
    
    UIImage *image = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    return image;
}

#pragma mark image 转 data
+ (NSData *)getDataWithImage:(UIImage *)image num:(CGFloat)num {
    
    image = [self fixOrientation:image];
    NSData *data = UIImageJPEGRepresentation(image, num);
    if (!data) {
        UIImagePNGRepresentation(image);
    }
    return data;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
