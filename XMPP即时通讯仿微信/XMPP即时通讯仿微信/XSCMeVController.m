//
//  XSCMeVController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/31.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCMeVController.h"

@interface XSCMeVController ()<XMPPvCardTempModuleDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *describeLa;

// 获取昵称存储;
@property(nonatomic,strong)XMPPvCardTemp *myvCarTemp;



@end

@implementation XSCMeVController

-(XMPPvCardTemp*)myvCarTemp{
    if (_myvCarTemp==nil) {
        _myvCarTemp=[XSCManageStream shareManager].xmppvCarTempM.myvCardTemp;
    }
    return _myvCarTemp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置多播代理;
    [[XSCManageStream shareManager].xmppvCarTempM addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 设置参数;
    [self updata];
}

-(void)updata{
    self.icon.image=[UIImage imageWithData:self.myvCarTemp.photo];
    
    self.name.text=[XSCManageStream shareManager].xmppStream.myJID.bare;
    
    self.nickName.text=self.myvCarTemp.nickname;
    
    self.describeLa.text=self.myvCarTemp.desc;
    
    
}

#pragma maek-多播代理  
-(void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    
    // 清除之前的内存存储;
    self.myvCarTemp=nil;
    
    // 重新赋值  ;
    [self updata];
}
@end
