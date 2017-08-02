//
//  SendReplyView.m
//  QGSendReply
//
//  Created by Xuqigang on 2017/5/14.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import "QGSendReplyView.h"

@interface QGSendReplyView ()

{
    UILabel * placeholderLabel;
}
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UIButton * sendButton;

@end
@implementation QGSendReplyView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        
        [self.backgroundView addSubview:self.textView];
        
        
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = UIFont(16);
        placeholderLabel.textColor = [UIColor grayColor];
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.enabled = YES;
        [self.textView addSubview:placeholderLabel];
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(8);
            
            
        }];
        
        [self.backgroundView addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-17);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(15);
            
        }];
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}

- (UIView *) backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.frame.size.width + 2, 50)];
        _backgroundView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _backgroundView.layer.borderColor = UIColorFromRGB(0x000000).CGColor;
        _backgroundView.layer.borderWidth = 0.5;
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}
- (UITextView *) textView
{
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8 , self.frame.size.width - 60, 36)];
        _textView.textColor = UIColorFromRGB(0x666666);
        _textView.font = UIFont(16);
        _textView.delegate = self;
        _textView.text = @"";
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.borderColor = UIColor(98, 172, 193, 1).CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 15;
        
    }
    return _textView;
}

- (UIButton *) sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.tag = 0;
        _sendButton.titleLabel.font = UIFont(15);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void) setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    placeholderLabel.text = placeholder;
}

- (void) sendButtonClicked:(UIButton *) button
{
    if (_block) {
        _block(self.textView.text);
    }
    self.textView.text = @"";
    [self.textView resignFirstResponder];
    placeholderLabel.hidden = NO;

}
#pragma mark---------------UITextViewDelegate-------------
- (void)textViewDidChange:(UITextView *)textView
{
    textView.scrollEnabled = NO;
    if (textView.text.length == 0) {
        placeholderLabel.hidden = NO;
    }
    else if(!placeholderLabel.hidden){
        placeholderLabel.hidden = YES;
    }
    static CGFloat maxHeight =80.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<frame.size.height) {
        frame.origin.y = frame.origin.y + (frame.size.height - size.height);
        textView.frame = CGRectMake(frame.origin.x, 8, frame.size.width, size.height);
        self.backgroundView.frame = CGRectMake(0, self.backgroundView.frame.origin.y + (frame.size.height - size.height), self.backgroundView.frame.size.width, self.backgroundView.frame.size.height - (frame.size.height - size.height));
    }
    else if(size.height>frame.size.height){
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            frame.origin.y = frame.origin.y - (size.height - frame.size.height);
            textView.scrollEnabled = NO;    // 不允许滚动
        }
        textView.frame = CGRectMake(frame.origin.x, 8, frame.size.width, size.height);
        self.backgroundView.frame = CGRectMake(0, self.backgroundView.frame.origin.y - (size.height - frame.size.height), self.backgroundView.frame.size.width, self.backgroundView.frame.size.height + (size.height - frame.size.height));
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = self.frame.size.height - frame.size.height - height;
    self.backgroundView. frame = frame;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = 0;
    self.backgroundView.frame = frame;
    
    self.frame = CGRectMake(0, SCREENHEIGHT - self.backgroundView.frame.size.height, self.frame.size.width, self.backgroundView.frame.size.height);
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
- (void)dealloc
{
    NSLog(@"%@已经释放", [NSString stringWithUTF8String:object_getClassName(self)]);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
