//
//  XSCXMPPChatKeyBoardView.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCXMPPChatKeyBoardView.h"

@implementation XSCXMPPChatKeyBoardView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        NSArray *arr=@[@"图片",@"语音",@"视频"];
        for (int i=0;i<arr.count;i++) {
            UIButton *btn=[[UIButton alloc]init];
            [btn setTitle:arr[i] forState:UIControlStateNormal ];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:16];
            [self addSubview:btn];
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
+(instancetype)showKeyBoard{
    return [[self alloc]init];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    int count=(int)self.subviews.count;
    for (int i=0;i<count;i++) {
        UIButton *btn=self.subviews[i];
        CGFloat W=self.width/self.subviews.count;
        CGFloat H=self.heigth;
        btn.frame=CGRectMake(W*i, 0, W, H);
    }
    

}
-(void)clickBtn:(UIButton*)send{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickXSCXMPPChatKeyBoardViewWithBtn:)]) {
        
        [self.delegate clickXSCXMPPChatKeyBoardViewWithBtn:send];
    }
}
@end
