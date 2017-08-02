//
//  SendReplyView.h
//  QGSendReply
//
//  Created by Xuqigang on 2017/5/14.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGSendReplyView : UIView <UITextViewDelegate>
{
    UILabel * placeholderLabel;
}
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) NSString * placeholder;  //设置占位符
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UIButton * careButton;
@property (nonatomic, strong) UIButton * shareButton;

- (instancetype) initWithFrame:(CGRect)frame;
@end
