//
//  XSCMUCRoomManager.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/3.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCMUCRoomManager.h"
@interface XSCMUCRoomManager ()<XMPPMUCDelegate,XMPPRoomDelegate>

@property(nonatomic,strong)NSMutableDictionary *roomDic;




@end
@implementation XSCMUCRoomManager

static XSCMUCRoomManager *MUCShare;
-(NSMutableDictionary*)roomDic{
    if (_roomDic==nil) {
        _roomDic=[NSMutableDictionary dictionary];
    }
    return _roomDic;
}

+(instancetype)shareMUCRoom{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MUCShare=[[XSCMUCRoomManager alloc]init];
    });
    return MUCShare;
}

// 通过get方法实现功能类;
-(XMPPMUC*)xmppMUC{
    if (_xmppMUC==nil) {
        
        // 创建对象;
        _xmppMUC=[[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        
        // 设置代理;
        [_xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppMUC;
}

-(void)jionOrCreateWithRoomJid:(XMPPJID *)roomJid andNickName:(NSString *)nickName{
    // 创建房间;
    XMPPRoom *room=[[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:roomJid dispatchQueue:dispatch_get_main_queue()];
    
    // 激活;
    [room activate:[XSCManageStream shareManager].xmppStream];
    
    // 存放数组里;
    self.roomDic[roomJid]=room;
    
    // 加入房间,如果房间不存在就创建一个房间并加入;
    [room joinRoomUsingNickname:nickName history:nil];
    
    // 设置代理;
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark--XMPPRoomdelegate
-(void)xmppRoomDidJoin:(XMPPRoom *)sender{
    // 需要对房间进行配置;
    [sender configureRoomUsingOptions:nil];
    
    [sender inviteUser:[XMPPJID jidWithUser:@"xiaoliu" domain:@"ios.127.0.0.1" resource:nil] withMessage:@"来一起交流即时通讯开发！"];
    
}
@end
