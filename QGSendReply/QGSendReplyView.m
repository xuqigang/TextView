//
//  SendReplyView.m
//  QGSendReply
//
//  Created by Xuqigang on 2017/5/14.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import "QGSendReplyView.h"

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
        
        [self.backgroundView addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-8);
            make.bottom.mas_equalTo(-17);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(16);
            
        }];
        
        [self.backgroundView addSubview:self.careButton];
        [self.careButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.shareButton.mas_left).mas_offset(-5);
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
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.userInteractionEnabled = YES;
        
        
    }
    return _backgroundView;
}
- (UITextView *) textView
{
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8 , self.frame.size.width - 110, 36)];
        _textView.textColor = UIColorFromRGB(0x666666);
        _textView.font = UIFont(16);
        _textView.delegate = self;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 10;
    }
    return _textView;
}

- (UIButton *) careButton
{
    if (!_careButton) {
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.tag = 0;
        _careButton.titleLabel.font = UIFont(15);
        [_careButton setTitle:@"关注" forState:UIControlStateNormal];
        [_careButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    return _careButton;
}

- (UIButton *) shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.tag = 0;
        _shareButton.titleLabel.font = UIFont(15);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    return _shareButton;
}
- (void) setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    placeholderLabel.text = placeholder;
}
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
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
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