//
//  NSString+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "NSString+SHExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (SHExtension)

#pragma mark SET
- (void)setPinyin:(NSString *)pinyin{
    
}
- (void)setFileName:(NSString *)fileName{
    
}
- (void)setTextLength:(NSInteger)textLength{
    
}
- (void)setMd5:(NSString *)md5{
    
}
- (void)setBase64:(NSString *)base64{
    
}
- (void)setDecoded64:(NSString *)decoded64{
    
}
- (void)setIsEmail:(BOOL)isEmail{
    
}
- (void)setIsFirstLetter:(BOOL)isFirstLetter{
    
}

#pragma mark 获取拼音
- (NSString *)pinyin{
    
    if (self.length) {
        //系统
        NSMutableString *pinyin = [NSMutableString stringWithString:self];
        CFStringTransform((CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
        return [[[pinyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        return self;
    }
}

#pragma mark 获取文件名字
- (NSString *)fileName{
    if (!self.length) {
        return self;
    }
    return [[self.lastPathComponent componentsSeparatedByString:@"."] firstObject];
}

#pragma mark 获取字符串长度(中文：2 其他：1）
- (NSInteger)textLength{
    
    //判断长度
    NSInteger textLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        unichar uc = [self characterAtIndex:i];
        textLength += isascii(uc) ? 1: 2;
    }
    return textLength;
}

#pragma mark 获取MD5加密
- (NSString *)md5{
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

#pragma mark base64编码
- (NSString *)base64{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}



#pragma mark base64解码
- (NSString *)decoded64{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



#pragma mark 是否为邮箱
- (BOOL)isEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

#pragma mark 是否首字母开头
- (BOOL)isFirstLetter{
    
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    return [regextestA evaluateWithObject:[self substringToIndex:1]];
}

@end
