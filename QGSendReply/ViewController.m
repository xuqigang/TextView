//
//  ViewController.m
//  QGSendReply
//
//  Created by Xuqigang on 2017/5/14.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import "ViewController.h"
#import "QGSendReplyView.h"
@interface ViewController ()
@property (nonatomic, strong) QGSendReplyView * sendReplyView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.sendReplyView];
}

#pragma mark-----------------实例化对象-----------------

- (QGSendReplyView *) sendReplyView
{
    if (!_sendReplyView) {
        _sendReplyView = [[QGSendReplyView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50)];
        _sendReplyView.placeholder = @"发表评论...";
        _sendReplyView.block = ^(NSString *content) {
            
            NSLog(@"要发表的内容：%@",content);
            
        };

    }
    return _sendReplyView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
