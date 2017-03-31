//
//  XSCUpdataTableViewController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/31.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCUpdataTableViewController.h"

@interface XSCUpdataTableViewController ()
// 内存存储;
@property(nonatomic,strong)XMPPvCardTemp *myvCardTemp;

@property (weak, nonatomic) IBOutlet UITextField *textMessage;



@end

@implementation XSCUpdataTableViewController

-(XMPPvCardTemp*)myvCardTemp{
    if (_myvCardTemp==nil) {
        _myvCardTemp=[XSCManageStream shareManager].xmppvCarTempM.myvCardTemp;
    }
    return _myvCardTemp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)determineCornect:(id)sender {
    
    // 更新数据;
    if ([self.title isEqualToString:@"昵称"]) {
        // 对昵称做一个更新;
        self.myvCardTemp.nickname=self.textMessage.text;
    }else{
        // 个性签名;
        self.myvCardTemp.desc=self.textMessage.text;
    }
    
    // 更新数据;
    [[XSCManageStream shareManager].xmppvCarTempM updateMyvCardTemp:self.myvCardTemp];
    
    // pop出这个控制器;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
