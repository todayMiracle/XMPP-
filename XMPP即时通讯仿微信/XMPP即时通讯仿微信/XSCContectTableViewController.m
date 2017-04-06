//
//  XSCContectTableViewController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/28.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCContectTableViewController.h"
#import "XSCChatViewController.h"
@interface XSCContectTableViewController ()<NSFetchedResultsControllerDelegate,XMPPRosterDelegate>

// 创建查询控制器;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

// 好友数组;
@property(nonatomic,strong)NSArray *contactArrs;




@end

@implementation XSCContectTableViewController

static NSString *ID=@"contact_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:82/255.f green:149/255.f  blue:255/255.f  alpha:1.0];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
   
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 登陆;
    [[XSCManageStream shareManager] loginToserver:[XMPPJID jidWithUser:@"lisi" domain:@"127.0.0.1" resource:nil] andPassword:@"123"];
    
    // 添加请求好友代理方法;
    [[XSCManageStream shareManager].xmRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    //执行查询操作 the fetched objects can be accessed with the property 'fetchedObjects'
    [self.fetchedResultsController performFetch:nil];
    
    // 获取数据;
    self.contactArrs=self.fetchedResultsController.fetchedObjects;
    //XSCLog(@"好友列表%@",self.contactArrs);

    // 刷新数据;
    [self.tableView reloadData];
    
    
}
#pragma mark- --查询好友列表-NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    // 最新的消息;
    self.contactArrs=controller.fetchedObjects;
   // XSCLog(@"好友列表%@",self.contactArrs);
    // 刷新数据;
    [self.tableView reloadData];
}

- (IBAction)addFriend:(id)sender {
    [[XSCManageStream shareManager].xmRoster addUser:[XMPPJID jidWithUser:@"wenlianghua" domain:@"127.0.0.1" resource:@"xsc"] withNickname:@"你好，我是你室友，带你飞"];
    
  
    
}


#pragma mark--XMPPRosterDelegate 
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    // 同意添加对方为好友;
    // 执行请求加好友代理方法  不然只会在一方有好友  另一个可能没有该好友;
    [[XSCManageStream shareManager].xmRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithUser:@"wenlianghua" domain:@"127.0.0.1" resource:@"xsc"] andAddToRoster:YES];
    
}
#pragma mark--懒加载

-(NSArray*)contactArrs{
    if (_contactArrs==nil) {
        _contactArrs=[NSArray array];
    }
    return _contactArrs;
}

-(NSFetchedResultsController*)fetchedResultsController{
    if (_fetchedResultsController==nil) {
        // 创建一个查询请求;
        NSFetchRequest *fetRequest=[[NSFetchRequest alloc]init];
        
        // 实体  XMPPUserCoreDataStorageObject 为用户对象;
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        fetRequest.entity=entity;
        
        // 谓词;
        NSPredicate *pre=[NSPredicate predicateWithFormat:@"subscription=%@",@"both"];
        fetRequest.predicate=pre;
        
        // 排序   jidStr 是XMPPJid（好友）类的属性;
        NSSortDescriptor *sorted=[NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
        fetRequest.sortDescriptors=@[sorted];
        
        // NSFetchedResultsController 创建对象;
        _fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"contacts"];
        
        // 设置代理;
        _fetchedResultsController.delegate=self;
    }
    return _fetchedResultsController;
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactArrs.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取数据;
    XMPPUserCoreDataStorageObject *contact=self.contactArrs[indexPath.row];
    
    // 创建cell；
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    // 给cell赋值;
    UILabel *nameLa=[cell viewWithTag:1001];
    nameLa.text=contact.jidStr;
    
    UIImageView *imageV=[cell viewWithTag:1000];
    imageV.clipsToBounds=YES;
    
    imageV.image=[UIImage imageWithData:[[XSCManageStream shareManager].xmppvCardAvatarModule photoDataForJID:contact.jid]] ;
    imageV.layer.cornerRadius=imageV.bounds.size.width/2;
    //[imageV.image ciircleImage];
    
    // 返回cell；
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
       UIStoryboard *storyB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XSCChatViewController *ch=(XSCChatViewController*)[storyB instantiateViewControllerWithIdentifier:@"chatview"];
   // XSCChatViewController *ch=[[XSCChatViewController alloc]init];
    // 获取聊天对象;
   // ch.userJid=contact.jid;
    ch.userJid=[self.contactArrs[indexPath.row] jid];
    
    //self.hidesBottomBarWhenPushed=YES;
    //[self.navigationController pushViewController:ch animated:YES];
    
}
#pragma mark-删除好友
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取数据;
    XMPPUserCoreDataStorageObject *contact=self.contactArrs[indexPath.row];
    
    // 删除好友;
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [[XSCManageStream shareManager].xmRoster removeUser:contact.jid];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
