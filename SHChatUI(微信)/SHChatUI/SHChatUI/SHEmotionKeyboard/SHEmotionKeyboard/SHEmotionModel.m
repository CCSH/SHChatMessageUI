//
//  SHEmotionModel.m
//  SHEmotionKeyboard
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHEmotionModel.h"
#import <objc/runtime.h>

#define iKY_AUTO_SERIALIZATION  \
\
+ (NSArray *)propertyOfSelf{  \
unsigned int count = 0;  \
Ivar *ivarList = class_copyIvarList(self, &count); \
NSMutableArray *properNames =[NSMutableArray array]; \
for (int i = 0; i < count; i++) { \
Ivar ivar = ivarList[i]; \
NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)]; \
NSString *key = [name substringFromIndex:1]; \
[properNames addObject:key]; \
} \
free(ivarList); \
return [properNames copy];\
} \
- (void)encodeWithCoder:(NSCoder *)enCoder{ \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
[enCoder encodeObject:[self valueForKey:propertyName] forKey:propertyName]; \
} \
} \
- (id)initWithCoder:(NSCoder *)aDecoder{ \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
[self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName]; \
} \
return  self; \
} \
- (NSString *)description{ \
NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"\n"]; \
NSArray *properNames = [[self class] propertyOfSelf]; \
for (NSString *propertyName in properNames) { \
NSString *propertyNameString = [NSString stringWithFormat:@"%@ - %@\n",propertyName,[self valueForKey:propertyName]]; \
[descriptionString appendString:propertyNameString]; \
} \
return [descriptionString copy]; \
}

@implementation SHEmotionModel

iKY_AUTO_SERIALIZATION

+ (instancetype)emotionWithDict:(NSDictionary *)dict{
    id obj = [[self alloc]init];
    
    NSArray *properties = [self loadProperties];
    
    for (NSString *key in properties) {
        if (dict[key]) {
            [obj setValue:dict[key] forKey:key];
        }
        
    }
    return obj;
}

+ (NSArray *)loadProperties{
    
    unsigned int count = 0;
    
    // 返回值是所有属性的数组
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        // 1. 从数组中获得属性
        objc_property_t pty = properties[i];
        
        // 2. 拿到属性名称
        const char *cname = property_getName(pty);
        [arrayM addObject:[NSString stringWithUTF8String:cname]];
    }
    
    // 释放属性数组
    free(properties);
    
    return arrayM;
}

@end
