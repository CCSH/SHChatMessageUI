//
//  SHFileHelper.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHFileHelper.h"
#import "SHMessageHeader.h"

@implementation SHFileHelper

#pragma mark - 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - 获取录音设置
+ (NSDictionary *)getAudioRecorderSettingDict {
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}

#pragma mark - 获取资源名字并且保存资源
+ (NSString *)getFileNameWithContent:(id)content type:(SHMessageFileType)type{
    
    if (!content) {
        return @"";
    }
    
    NSString *filePath;
    NSData *data;
    switch (type) {
        case SHMessageFileType_image://image
        {
            filePath = [NSString stringWithFormat:@"%@/%@.jpg",kSHPath_image,[SHMessageHelper getTimeWithZone]];
            data = [SHMessageHelper getDataWithImage:content num:1];
        }
            break;
        case SHMessageFileType_wav:case SHMessageFileType_amr://语音
        {
            //转格式 WAV-->AMR
            [VoiceConverter wavToAmr:[NSString stringWithFormat:@"%@/%@.wav",kSHPath_voice_wav,content] amrSavePath:[NSString stringWithFormat:@"%@/%@.amr",kSHPath_voice_amr,content]];
        }
            break;
        case SHMessageFileType_gif://gif
        {
            filePath = [NSString stringWithFormat:@"%@/%@.gif",kSHPath_gif,[SHMessageHelper getTimeWithZone]];
        }
            break;
        case SHMessageFileType_video://video
        {
            filePath = [NSString stringWithFormat:@"%@/%@.gif",kSHPath_video,[SHMessageHelper getTimeWithZone]];
            data = [NSData dataWithContentsOfFile:content];
        }
            break;
        case SHMessageFileType_video_image://视频图片
        {
            UIImage *image = [SHMessageHelper getVideoImageWithVideoPath:content];
            data = [SHMessageHelper getDataWithImage:image num:1];
            filePath = [NSString stringWithFormat:@"%@/%@.jpg",kSHPath_video_image,[self getNameWithUrl:content]];
        }
            break;
        default:
            break;
    }
    
    if (data) {
        [data writeToFile:filePath atomically:NO];
    }
    
    return filePath.length?filePath.lastPathComponent:@"";
}

//获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(SHMessageFileType)type{
    
    switch (type) {
        case SHMessageFileType_image://image
        {
            return [NSString stringWithFormat:@"%@/%@.jpg",kSHPath_image,name];
        }
            break;
        case SHMessageFileType_wav://语音wav
        {
            return [NSString stringWithFormat:@"%@/%@.wav",kSHPath_voice_wav,name];
        }
            break;
        case SHMessageFileType_amr://语音amr
        {
            return [NSString stringWithFormat:@"%@/%@.amr",kSHPath_voice_amr,name];
        }
            break;
        case SHMessageFileType_gif://gif
        {
            return [NSString stringWithFormat:@"%@/%@.gif",kSHPath_gif,name];
        }
            break;
        case SHMessageFileType_video://video
        {
            return [NSString stringWithFormat:@"%@/%@.mp4",kSHPath_video,name];
        }
            break;
        case SHMessageFileType_video_image://视频图片
        {
            return [NSString stringWithFormat:@"%@/%@.jpg",kSHPath_video_image,name];
        }
            break;
        default:
            break;
    }
    return name;
}

//获取名字
+ (NSString *)getNameWithUrl:(NSString *)url{
    
    if (!url.length) {
        return nil;
    }
    
    NSArray *arr = [url.lastPathComponent componentsSeparatedByString:@"."];
    
    if (arr.count) {
        return arr.firstObject;
    }
    return url;
}

@end
