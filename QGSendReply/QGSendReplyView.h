//
//  SendReplyView.h
//  QGSendReply
//
//  Created by Xuqigang on 2017/5/14.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QGSendReplyViewBlock)(NSString * content);
@interface QGSendReplyView : UIView <UITextViewDelegate>

@property (nonatomic, strong) NSString * placeholder;  //设置占位符
@property (nonatomic, strong) QGSendReplyViewBlock block;

- (instancetype) initWithFrame:(CGRect)frame;

@end
