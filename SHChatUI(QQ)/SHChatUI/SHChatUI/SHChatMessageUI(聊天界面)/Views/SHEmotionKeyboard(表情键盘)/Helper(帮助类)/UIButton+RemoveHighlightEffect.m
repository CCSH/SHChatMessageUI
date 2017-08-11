//
//  UIButton+RemoveHighlightEffect.m
//  emoji
//
//  Created by jiang on 15/10/1.
//  Copyright © 2015年 jiang. All rights reserved.
//

#import "UIButton+RemoveHighlightEffect.h"
#import <objc/runtime.h>

#define kRemoveHighlightEffect @"RemoveHighlightEffect"

@implementation UIButton (RemoveHighlightEffect)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clazz = [self class];
        
        SEL originalSEL = @selector(setHighlighted:);
        SEL swizzledSEL = @selector(jh_setHighlighted:);
        
        Method originalMethod = class_getInstanceMethod(clazz, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSEL);
        
        //添加方法
        
        BOOL result = class_addMethod(clazz, swizzledSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (result) {
            class_replaceMethod(clazz, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        }else{
            
             method_exchangeImplementations(originalMethod, swizzledMethod);
            
        }

    });
    
    
    
    
}


-(void)jh_setHighlighted:(BOOL)highlighted{
    
    if (!self.removeHighlightEffect) {
        //这句代码代码调用原来的方法
        [self jh_setHighlighted:highlighted];
    }

    
    
}

-(void)setRemoveHighlightEffect:(BOOL)removeHighlightEffect{
    
    objc_setAssociatedObject(self, kRemoveHighlightEffect, @(removeHighlightEffect), OBJC_ASSOCIATION_ASSIGN);

}

- (BOOL)removeHighlightEffect{
    
  return objc_getAssociatedObject(self, kRemoveHighlightEffect);

}

@end
