//
//  XSCManageStream.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/28.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSCManageStream : NSObject
// 创建 XMPPStream流
@property(nonatomic,strong)XMPPStream *xmppStream;

// 保存密码;
@property(nonatomic,copy)NSString *password;

// 1.自动重连;
@property(nonatomic,strong)XMPPReconnect *xmReconnect;

// 2.心跳检测功能
@property(nonatomic,strong)XMPPAutoPing *xmAutoPing;

// 3好友花名册;
@property(nonatomic,strong)XMPPRoster *xmRoster;

/**
 *  消息归档处理类
 *  程序关闭后，下次打开还可以再次查看以前的聊天记录
 */
@property(nonatomic, strong) XMPPMessageArchiving * xmppMessageArchiving;

// 4 照片模块  别人的个人资料模块;;
@property(nonatomic,strong)XMPPvCardAvatarModule *xmppvCardAvatarModule;

// 5. 电子名片模块   个人资料模块;
@property(nonatomic,strong)XMPPvCardTempModule *xmppvCarTempM;

// 6文件接收;
@property(nonatomic,strong)XMPPIncomingFileTransfer *xmppIncomingFileTransfer;










+(instancetype)shareManager;



/**
 *  coredata 上下文，用来获取通过messageArchiving归档后存储起来的消息
 */
@property(nonatomic, strong) NSManagedObjectContext * context;


@property(nonatomic,strong)XMPPMessageArchivingCoreDataStorage *storage;




// 连接到服务器方法;
-(void)loginToserver:(XMPPJID*)myJid andPassword:(NSString*)password;
@end
