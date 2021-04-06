# 两种方式创建聊天界面
* 第一种是不同聊天类型一种cell，控制控件的显隐
* 第二种是不同聊天类型多种cell，继承一个基类cell，不同消息控制cell标示
* 考虑到性能，扩展消息、代码可读性方面推荐第二种，本人也在不定期维护第二种
> 使用中如果有其他问题可以[`告诉我`](https://github.com/CCSH/SHChatMessageUI/issues/new)

**另外附上**
[`朋友圈界面`](https://github.com/CCSH/SHFriendTimeLineUI)
[`录制小视频`](https://github.com/CCSH/SHShortVideo)
[`表情键盘`](https://github.com/CCSH/SHEmotionKeyboard)

## 消息格式
- [x] 文本
- [x] 语音
- [x] 图片
- [x] 位置
- [x] 拍照
- [x] 视频
- [x] 名片
- [x] 通知
- [x] 红包
- [x] 表情
- [x] Gif
- [x] 文件
## 功能
- [x] 消息长按与点击
- [x] 头像长按与点击
- [x] 消息发送状态
- [x] 消息重发
- [x] 消息点击
- [x] 语音播放与暂停
- [x] 消息发送状态
- [x] 输入框随着输入自增高
- [x] 文本消息网页，手机号识别跳转

## 效果
![image](https://github.com/CCSH/SHChatMessageUI/blob/master/QQ20180702-183212-HD.gif)

## 版本更新
#### 2.1.2
- 录音细节优化
- 去除多余字段、简化内部逻辑增加注释

#### 2.1.1
- fixbug 处理语音消息动画问题(语音播放状态存到数据源中否则刷新界面时打断动画)

#### 2.1.0
- 新增客服模式（头像显示控制）
- 微调消息布局 更美观

#### 2.0.0
- 新增文件消息
- 交互动画细节优化
- 部分ui细节优化
