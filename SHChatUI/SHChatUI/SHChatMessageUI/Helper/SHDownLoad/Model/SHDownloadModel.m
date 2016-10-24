//
//  SHDownloadModel.m
//  断点续传之下载
//
//  Created by CSH on 16/6/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHDownloadModel.h"

#define SHDownLoad_Url @"SHDownLoad_Url"
#define SHDownLoad_FileName @"SHDownLoad_FileName"
#define SHDownLoad_TotalLength @"SHDownLoad_TotalLength"
#define SHDownLoad_TotalSizel @"SHDownLoad_TotalSizel"

@implementation SHDownloadModel

- (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return (float) (contentLength / (float)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (float) (contentLength / (float)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (float) (contentLength / (float)1024); }
    else { return (float) (contentLength); }
}

- (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return @"GB";}
    else if(contentLength >= pow(1024, 2)) { return @"MB"; }
    else if(contentLength >= 1024) { return @"KB"; }
    else { return @"B"; }
}

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    [aCoder encodeObject:self.url forKey:SHDownLoad_Url];
    [aCoder encodeObject:self.fileName forKey:SHDownLoad_FileName];
    [aCoder encodeInteger:self.totalLength forKey:SHDownLoad_TotalLength];
    [aCoder encodeObject:self.totalSize forKey:SHDownLoad_TotalSizel];
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:SHDownLoad_Url];
        self.fileName = [aDecoder decodeObjectForKey:SHDownLoad_FileName];
        self.totalLength = [aDecoder decodeIntegerForKey:SHDownLoad_TotalLength];
        self.totalSize = [aDecoder decodeObjectForKey:SHDownLoad_TotalSizel];
    }
    return self;
}


@end
