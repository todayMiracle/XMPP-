//
//  XSCManageStream.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/28.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCManageStream.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPLogging.h"  // 如果需要打印登陆信息日志就导入此头文件

@interface XSCManageStream ()<XMPPStreamDelegate,XMPPRosterDelegate>

@end

@implementation XSCManageStream

static XSCManageStream *share; // 控制器流  socket
// (1)
+(instancetype)shareManager{
    static dispatch_once_t onceTaken;// 创建一个单例
    dispatch_once(&onceTaken, ^{
        share=[XSCManageStream new];
        
        
        
     // 打印设置的日志;
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV]; //等级;
    });
    
    return share;
}
//-(instancetype)init{
//    
//    
//    // xmppMessageArchiving的主要功能：1、通过通讯管道获取到服务器发送过来的消息。2、将消息存储到指定的XMPPMessageArchivingCoreStorage
//    // xmpp为我们提供的一个存储聊天消息的coredata仓库
//    XMPPMessageArchivingCoreDataStorage *xmacds = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    // 初始化时，需要给这个归档类指定一个存储仓库
//    self.messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmacds dispatchQueue:dispatch_get_main_queue()];
//    // 在通讯管道中激活
//    [self.messageArchiving activate:self.xmppStream];
//    // 获取消息归档类提供的上下文信息
//    self.context = xmacds.mainThreadManagedObjectContext;
//    
//    return self;
//}
//(2)
// 配置stream流
-(XMPPStream*)xmppStream{
    if (_xmppStream==nil) {
        // 创建流;
        _xmppStream=[[XMPPStream alloc]init];
        // 设置属性;
        _xmppStream.hostName=@"127.0.0.1";  // 服务器
        _xmppStream.hostPort=5222;       // 端口
        // 设置代理  多播代理  ;
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // 连接到服务器;
        
        
        /**
         * Connects to the configured hostName on the configured hostPort.
         * The timeout is optional. To not time out use XMPPStreamTimeoutNone.
         * If the hostName or myJID are not set, this method will return NO and set the error parameter.
         **/
        //连接到服务器 需要一个  myJID
       // [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
    }
    
    return _xmppStream;
}

// (3)
//连接到服务器并登陆;
-(void)loginToserver:(XMPPJID *)myJid andPassword:(NSString *)password{
    // 设置myJid；
    [self.xmppStream setMyJID:myJid];
    
    // 保存密码;
    
    self.password=password;
    // 连接;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:nil];
    
    // 激活自动重连功能;
    [self activity];
}
// (6) 自动重连;
-(XMPPReconnect*)xmReconnect{
    if (_xmReconnect==nil) {
        // 1.创建功能对象;
        _xmReconnect=[[XMPPReconnect alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        
        // 2. 设置对象参数 代理;  重连时间间隔;
        _xmReconnect.reconnectTimerInterval=2;
        
       // 3.激活功能;
    }
    return _xmReconnect;
}

//(7)心跳检测功能
-(XMPPAutoPing*)xmAutoPing{
    if (_xmAutoPing==nil) {
        // 创建检测对象;
        _xmAutoPing=[[XMPPAutoPing alloc]initWithDispatchQueue:dispatch_get_global_queue(0, 0)];
        
        // 设置参数代理;
        _xmAutoPing.pingInterval=3;
        
        // 激活检测功能;
        
    }
    return _xmAutoPing;
}

// (8)好友花名册
-(XMPPRoster*)xmRoster{
    if (_xmRoster==nil) {
        // 1 创建对象;
        _xmRoster=[[XMPPRoster alloc]initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        // 2 设置参数;
        // 设置是否自动查找新的好友数据;
        _xmRoster.autoFetchRoster=YES;
        
        // 设置是否自动清除用户存储的数据;
        _xmRoster.autoClearAllUsersAndResources=NO;
        
        // 是否自动执行XMPP 会自动帮我们执行加好友操作  不会执行加好友代理方法;
        _xmRoster.autoAcceptKnownPresenceSubscriptionRequests=NO;
        
        // 设置代理  ;
        [_xmRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        
        // 激活功能;
        
    }
    return _xmRoster;
}

-(XMPPMessageArchiving*)xmppMessageArchiving{
    if (_xmppMessageArchiving==nil) {
        _xmppMessageArchiving=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:[XMPPMessageArchivingCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        // 设置代理;
        
    }
    return _xmppMessageArchiving;
}

-(XMPPvCardTempModule*)xmppvCarTempM{
    if (_xmppvCarTempM==nil) {
        _xmppvCarTempM=[[XMPPvCardTempModule alloc]initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        // 设置代理;
        
    }
    return _xmppvCarTempM;
}

-(XMPPvCardAvatarModule*)xmppvCardAvatarModule{
    if (_xmppvCardAvatarModule==nil) {
        _xmppvCardAvatarModule=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.xmppvCarTempM dispatchQueue:dispatch_get_global_queue(0, 0)];
    }
    return _xmppvCardAvatarModule;
}

-(void)activity{
    // 自带重连;
    [self.xmReconnect activate:self.xmppStream];
    // 心跳检测;
    [self.xmAutoPing activate:self.xmppStream];
    
    // 查询好友花名册;
    [self.xmRoster activate:self.xmppStream];
    
    // 激活消息模块;
    [self.xmppMessageArchiving activate:self.xmppStream];
    
    // 激活别人的个人资料模块;
    [self.xmppvCardAvatarModule activate:self.xmppStream];
    
    // 激活自己的个人资料模块;
    [self.xmppvCarTempM activate:self.xmppStream];
}
//(4)
#pragma mark--XMPPStreamDelegate
// 通过代理方法告诉我们连接是否成功;
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    // 一个出席认证;
    [self.xmppStream authenticateWithPassword:self.password error:nil];
    
    // 还可以注册  匿名登陆;
//    [self.xmppStream authenticateAnonymously:nil];
//    
//    [self.xmppStream registerWithPassword:nil error:nil];
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    // 如果认证成功 则可以出席;
    XMPPPresence *presence=[XMPPPresence presence];
    
    // 添加出席状态  show  status-> ;
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"dnd"]];
    [presence addChild:[DDXMLElement elementWithName:@"status" stringValue:@"别来烦我啊！"]];
    
    // 通过stream 告诉服务器我要出席;
    [self.xmppStream sendElement:presence];
    
}

// (5)通过代理接收消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    XSCLog(@"接收消息====%@",message.body);
    
    // 弹出本地通知;
//    UILocalNotification *noti=[[UILocalNotification alloc]init];
//    //[noti setAlertTitle:[NSString stringWithFormat:@"来自－－%@ 的消息--%@",message.from,message.body]];
//    [noti setAlertBody:[NSString stringWithFormat:@"来自－－%@ 的消息--%@",message.from,message.body]];
//    [noti setApplicationIconBadgeNumber:1];
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
    
    //iOS10 之后;
    // 1 创建一个本地通知;
    UNMutableNotificationContent *content_1=[[UNMutableNotificationContent alloc]init];
    // 设置主标题;
    content_1.title=message.body;
    content_1.subtitle=[NSString stringWithFormat:@"%@",message.from];
    content_1.body=[NSString stringWithFormat:@"%@",message.body];
    content_1.badge=@3;
    
    // 2.设置触发时间;
    UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    // 3 创建一个发送请求;
    UNNotificationRequest  *notiRequest=[UNNotificationRequest requestWithIdentifier:@"my_notification" content:content_1 trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notiRequest withCompletionHandler:^(NSError * _Nullable error){
        XSCLog(@"推送❌%@",error);
    }];
    
    
}
@end
