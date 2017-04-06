//
//  XSCChatCell.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCChatCell.h"

@implementation XSCChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    XSCLog(@"播放语音---%@",self.audioData);
    // 如果有音频数据,直接播放音频;
    if (self.audioData !=nil) {
        self.messageLa.textColor=[UIColor redColor];
        
        // 如果单例的代码块包含self  一定适用weakSelf；
        __weak XSCChatCell *weakSelf=self;
        //NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"12328.caf"]];
        [[XSCRecordTools shareRecorder] playdata:self.audioData completion:^{
            weakSelf.messageLa.textColor=[UIColor blackColor];
        }];
    }
}
@end
