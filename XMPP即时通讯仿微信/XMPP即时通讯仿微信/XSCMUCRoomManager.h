//
//  XSCMUCRoomManager.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/3.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSCMUCRoomManager : NSObject
// 群聊功能;
@property(nonatomic,strong)XMPPMUC *xmppMUC;

// 聊天室的功能类;
@property(nonatomic,strong)XMPPRoom *xmppRoom;



// 实例一个单例
+(instancetype)shareMUCRoom;

-(void)jionOrCreateWithRoomJid:(XMPPJID*)roomJid andNickName:(NSString*)nickName;
@end
