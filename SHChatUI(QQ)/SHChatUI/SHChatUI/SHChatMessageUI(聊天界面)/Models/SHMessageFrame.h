//
//  SHMessageFrame.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ChatMargin 10           //消息中控件间隔

#define ChatIconWH 45           //头像宽高height、width

#define ChatTimeMarginW 15      //时间文本与边框间隔宽度方向
#define ChatTimeMarginH 10      //时间文本与边框间隔高度方向

#define ChatPicWH 160           //图片宽高

#define ChatContentW SHWidth - 2*(4*ChatMargin + ChatIconWH) - 20       //文本宽度

#define ChatVoiceW 160          //语音宽度
#define ChatVoiceH 20           //语音高度

#define ChatLocationW 160      //位置宽
#define ChatLocationH 100       //位置高

#define ChatCardW 180           //名片的宽
#define ChatCardH 60            //名片的高

#define ChatVideoWH 120      //视频宽高

#define ChatPromptW  280        //提示文字宽

#define ChatRedPackageW 180     //红包的宽
#define ChatRedPackageH 60      //红包的高

#define ChatBurnW 180            //阅后即焚的宽
#define ChatBurnH 60             //阅后即焚的高

#define ChatGifWH 100           //Gif的宽高

#define ChatContentTB 5         //提示文字上下间隔
#define ChatContentLR 15        //提示文字左右间隔

#define ChatContentTop 15       //文本内容与按钮上边缘间隔
#define ChatContentLeft 25      //文本内容与按钮左边缘间隔(去除气泡角)
#define ChatContentBottom 15    //文本内容与按钮下边缘间隔
#define ChatContentRight 15     //文本内容与按钮右边缘间隔

#define ChatTimeFont [UIFont systemFontOfSize:11]           //时间字体
#define ChatNameFont [UIFont systemFontOfSize:11]           //ID字体
#define ChatContentFont [UIFont systemFontOfSize:16]        //内容字体
#define ChatPromptContentFont [UIFont systemFontOfSize:11]  //提示内容字体

@class SHMessage;

@interface SHMessageFrame : NSObject

//名字CGRect
@property (nonatomic, assign, readonly) CGRect nameF;
//头像CGRect
@property (nonatomic, assign, readonly) CGRect iconF;
//时间CGRect
@property (nonatomic, assign, readonly) CGRect timeF;
//内容CGRect
@property (nonatomic, assign, readonly) CGRect contentF;
//整体Cell高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
//聊天模型
@property (nonatomic, strong) SHMessage *message;
//是否显示时间
@property (nonatomic, assign) BOOL showTime;
//是否显示名称
@property (nonatomic, assign) BOOL showName;

@end
