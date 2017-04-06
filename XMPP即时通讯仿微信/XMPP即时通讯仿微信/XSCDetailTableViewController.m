//
//  XSCDetailTableViewController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/31.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCDetailTableViewController.h"

@interface XSCDetailTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,XMPPvCardTempModuleDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *describela;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;

// 获取内存存储;
@property(nonatomic,strong)XMPPvCardTemp *myvCarTemp;



@end

@implementation XSCDetailTableViewController

-(XMPPvCardTemp*)myvCarTemp{
    if (_myvCarTemp==nil) {
        _myvCarTemp=[XSCManageStream shareManager].xmppvCarTempM.myvCardTemp;
    }
    return _myvCarTemp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.icon.userInteractionEnabled=YES;
    
    //设置多播代理;
   [[XSCManageStream shareManager].xmppvCarTempM addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self updata];
    
}

-(void)updata{
    self.icon.image=[UIImage imageWithData:self.myvCarTemp.photo];
    
    self.nickName.text=self.myvCarTemp.nickname;
    
    self.describela.text=self.myvCarTemp.desc;
    
    self.nameLa.text=[XSCManageStream shareManager].xmppStream.myJID.bare;
}
- (IBAction)TapUpdataImage:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    
    // 参数设置;
    picker.allowsEditing=YES;
    
    // 设置代理;
    picker.delegate=self;
    
    // 弹出控制器;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}


#pragma mark--相册代理方法;
// 选中哪个图片;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   // XSCLog(@"%@",info);
    
    // 获取图片;
    UIImage *image=info[UIImagePickerControllerEditedImage];
    NSData *data=UIImageJPEGRepresentation(image, 0.2);
    
    // 内存存储;
    self.myvCarTemp.photo=data;
    
    // 数据更新;
    [[XSCManageStream shareManager].xmppvCarTempM updateMyvCardTemp:self.myvCarTemp];
    
    self.icon.image=image;
    // 取消控制器;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}
// 取消选中哪个图片;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark--多播代理;
-(void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    // 数据重新赋值;
    
    // 1.清除之前的内存存储;
    self.myvCarTemp=nil;
    
    // 2. 重新获取内存存储;
    [self updata];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"des"]) {
        segue.destinationViewController.title=@"个性签名";
        
    }else{
        segue.destinationViewController.title=@"昵称";
    }
}

@end
