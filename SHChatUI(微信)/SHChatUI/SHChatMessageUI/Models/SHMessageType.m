//
//  SHMessageType.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageType.h"

@implementation SHMessageType

+ (NSString *)messageTypeWithType:(SHMessageBodyType)type{
    //消息类型
    NSString *messageType = @"";
    switch (type) {
        case SHMessageBodyType_Text:
            messageType = @"txt";
            break;
        case SHMessageBodyType_Image:
            messageType = @"img";
            break;
        case SHMessageBodyType_Video:
            messageType = @"video";
            break;
        case SHMessageBodyType_Location:
            messageType = @"location";
            break;
        case SHMessageBodyType_Voice:
            messageType = @"audio";
            break;
        case SHMessageBodyType_File:
            messageType = @"file";
            break;
        case SHMessageBodyType_RedPaper:
            messageType = @"redpaper";
            break;
        case SHMessageBodyType_Command:
            messageType = @"command";
            break;
        case SHMessageBodyType_Prompt:
            messageType = @"prompt";
            break;
        case SHMessageBodyType_Other:
            messageType = @"other";
            break;
        default:
            break;
    }
    return messageType;
    
}

+ (SHMessageBodyType)messageTypeWithStr:(NSString *)str{
    
    SHMessageBodyType type;
    if ([str isEqualToString:@"txt"]) {
        type = SHMessageBodyType_Text;
    }else if ([str isEqualToString:@"img"]){
        type = SHMessageBodyType_Image;
    }else if ([str isEqualToString:@"video"]){
        type = SHMessageBodyType_Video;
    }else if ([str isEqualToString:@"location"]){
        type = SHMessageBodyType_Location;
    }else if ([str isEqualToString:@"audio"]){
        type = SHMessageBodyType_Voice;
    }else if ([str isEqualToString:@"file"]){
        type = SHMessageBodyType_File;
    }else if ([str isEqualToString:@"redpaper"]){
        type = SHMessageBodyType_RedPaper;
    }else if ([str isEqualToString:@"command"]){
        type = SHMessageBodyType_Command;
    }else if ([str isEqualToString:@"prompt"]){
        type = SHMessageBodyType_Prompt;
    }else if ([str isEqualToString:@"other"]){
        type = SHMessageBodyType_Other;
    }
    return type;
}

@end
