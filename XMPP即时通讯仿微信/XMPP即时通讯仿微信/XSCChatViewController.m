//
//  XSCChatViewController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/28.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCChatViewController.h"

@interface XSCChatViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,XMPPvCardAvatarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarbottomLayoutConstraint;

// 查询聊天控制器;
@property(nonatomic,strong)NSFetchedResultsController *FetchedResultsController;

// 聊天记录模型;
@property(nonatomic,strong)NSArray *messageS;


@end

@implementation XSCChatViewController

#pragma mark--懒加载
-(NSArray*)messageS{
    if (_messageS==nil) {
        _messageS=[NSArray array];
    }
    return _messageS;
}
-(NSFetchedResultsController*)FetchedResultsController{
    if (_FetchedResultsController==nil) {
        // 创建一个查询请求;
        NSFetchRequest *fetRequest=[[NSFetchRequest alloc]init];
        
        // 实体  XMPPMessageArchiving_Message_CoreDataObject 为message对象;
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage  sharedInstance].mainThreadManagedObjectContext];
        fetRequest.entity=entity;
        
        // 谓词;
        NSPredicate *pre=[NSPredicate predicateWithFormat:@"bareJidStr=%@",self.userJid.bare];
        fetRequest.predicate=pre;
        
        // 排序   timestamp 是XMPPJid（好友）类的属性;
        NSSortDescriptor *sorted=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        fetRequest.sortDescriptors=@[sorted];
        
        // NSFetchedResultsController 创建对象  @"messages";
        _FetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"messages"];
        
        // 设置代理;
        _FetchedResultsController.delegate=self;
    }
    return _FetchedResultsController;
}


#pragma mark--消息查询
#pragma mark--NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 获取新的数据;
    
    // 排序  yes 为升序;
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    
    // 获取排序后的数据;
    self.messageS=[self.FetchedResultsController.fetchedObjects sortedArrayUsingDescriptors:@[sort]];
   
    // 刷新;
    [self.tableview reloadData];
    
    // 滚动到最后一条消息;
    [self setTableviewScrollviewToBottom];
 
}
-(void)setTableviewScrollviewToBottom{
    if (self.messageS.count>5) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.messageS.count-1 inSection:0];
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        // 刷新;
        [self.tableview reloadData];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title=self.userJid.user;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setUpbasic];
    
    // 设置更新别人头像的代理;
    [[XSCManageStream shareManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 主动删除缓存;
    [NSFetchedResultsController deleteCacheWithName:@"messages"];
    
    
   
    // 查询聊天记录;
    NSError *error=nil;
    
    if ([self.FetchedResultsController performFetch:&error]) {
        XSCLog(@"读取成功");
         self.messageS=self.FetchedResultsController.fetchedObjects;
    }else{
         XSCLog(@"%@",error);
    }
    XSCLog(@"viewDidLoad获取排序后的数据---%@",self.messageS);
    [self setTableviewScrollviewToBottom];
   
   
}
-(void)setUpbasic{
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.textFiled.delegate=self;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.allowsSelection=NO;
    // 注册键盘即将弹出通知;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 注册键盘退出通知;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark---键盘处理
-(void)keyBoardWillShow:(NSNotification*)noti{
    
    //1  获取键盘高度;
    CGRect KbFrame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat Height=KbFrame.size.height;
    // 获取键盘弹出时间;
    CGFloat time=[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    // 2 更改底部约束;
    self.toolBarbottomLayoutConstraint.constant=Height;
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyBoardWillHide:(NSNotification*)noti{
    self.toolBarbottomLayoutConstraint.constant=0;
}
// 取消键盘;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textFiled endEditing:YES];
}
#pragma mark--- 发送消息;

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 发消息;
    [self sendMessage:textField.text];
    // 刷新数据;
    
    // 键盘清空;
    textField.text=@"";
    return YES;
}
-(void)sendMessage:(NSString*)text{
    // 发消息  chat 为单聊类型;
    XMPPMessage *message=[XMPPMessage messageWithType:@"chat" to:self.userJid];
    [message addBody:text];
    
    [[XSCManageStream shareManager].xmppStream sendElement:message];
    XSCLog(@"单聊类型%@",message);
    // 刷新数据;
    [self.tableview reloadData];
}

#pragma mark--UItableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageS.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1 获取数据;
    XMPPMessageArchiving_Message_CoreDataObject *mgr=self.messageS[indexPath.row];
    
   // XMPPvCardTemp *vCartemp=[XSCManageStream shareManager].xmppvCarTempM.myvCardTemp;
    // 2 创建cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:mgr.isOutgoing?@"right_cell":@"left_cell"];
    
    // 3 给cell赋值;
    UILabel *messageLa=[cell viewWithTag:1002];
    messageLa.text=mgr.body;
    
    UIImageView *imagev=[cell viewWithTag:1001];
    imagev.clipsToBounds=YES;
    
    if (mgr.isOutgoing) {// 自己的头像
        
       imagev.image=[UIImage imageWithData:[XSCManageStream shareManager].xmppvCarTempM.myvCardTemp.photo] ;
    }else{
        // 别人的头像;
        imagev.image=[UIImage imageWithData:[[XSCManageStream shareManager].xmppvCardAvatarModule photoDataForJID:mgr.bareJid]];
    }
    imagev.layer.cornerRadius=imagev.bounds.size.width/2;
    // 4 返回cell;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark--XMPPvCardAvatarDelegate--更新别人头像
-(void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid{
    [self.tableview reloadData];
}

















//- (void)getChatHistory
//{
//   
//    //查询的时候要给上下文
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:[XMPPMessageArchivingCoreDataStorage sharedInstance].messageEntityName inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
//    [fetchRequest setEntity:entity];
//    // Specify criteria for filtering which objects to fetch
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.userJid.bare];
//    [fetchRequest setPredicate:predicate];
//    // Specify how the fetched objects should be sorted
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
//                                                                   ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//    
//    NSError *error = nil;
//    NSArray *fetchedObjects = [[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
//    XSCLog(@"方法三－－超级无奈了%@",fetchedObjects);
//   
//}
//// 加载所有信息(通过单例类的上下文获取)
//- (void)reloadAllMessage{
//    // 获取上下文信息
//    NSManagedObjectContext *context = [XSCManageStream shareManager].context;
//    // xmppMessageArchving : 把接收到得消息归档,归档后的数据类型是：XMPPMessageArchiving_Message_CoreDataObject
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
//    // 设置断言
//    // 查找所有的和当前聊天对象的聊天记录
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@",self.userJid.bare];
//    // 让断言生效
//    [fetchRequest setPredicate:predicate];
//    // 获取数据
//    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
//    XSCLog(@"方法二聊天消息%@",array);
//   
//}
//
//
//-(void)getRecords:(NSString*)friendsName{
//    
//    // 设置查询条件;
//    // 实体;
//    NSFetchRequest *requeset=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
//    
//    
//    // 谓词;
//    NSString *selfDomain=@"127.0.0.1";
//    NSString *userInfo=[NSString stringWithFormat:@"%@@%@",friendsName,selfDomain];
//    NSString *friendinfo = [NSString stringWithFormat:@"%@@%@",self.userJid.user,self.userJid.domain];
//    NSPredicate *preDi=[NSPredicate predicateWithFormat:@" streamBareJidStr = %@ and bareJidStr = %@",userInfo,friendinfo];
//    requeset.predicate=preDi;
//    
//    
//    // 排序;
//    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
//    requeset.sortDescriptors=@[sort];
//    
//    NSFetchedResultsController *fetMsgRecord=[[NSFetchedResultsController alloc]initWithFetchRequest:requeset managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"messages"];
//    
//    
//    fetMsgRecord.delegate=self;
//    
//    // 开始查询聊天消息;
//    [fetMsgRecord performFetch:nil];
//    
//    //   返回的值类型 XMPPMessageArchiving_Message_CoreDataObject
//    NSArray *arr=[NSArray array];
//    arr=fetMsgRecord.fetchedObjects;
//    
//    XSCLog(@"新竹之路%@",arr);
//}
//

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar setHidden:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
