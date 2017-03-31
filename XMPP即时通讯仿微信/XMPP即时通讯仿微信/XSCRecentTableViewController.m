//
//  XSCRecentTableViewController.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/30.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCRecentTableViewController.h"
#import "XSCChatViewController.h"
@interface XSCRecentTableViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,XMPPvCardAvatarDelegate>

@property(nonatomic,strong)NSFetchedResultsController *FetchedResultsController;


@property(nonatomic,strong)NSMutableArray *recentContacts;



@end

@implementation XSCRecentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:82/255.f green:149/255.f  blue:255/255.f  alpha:1.0];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 更新别人头像的代理;
    [[XSCManageStream shareManager].xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 删除缓存文件;
   // [NSFetchedResultsController deleteCacheWithName:@"Recently"];
    
    // 查询操作;
    [self.FetchedResultsController performFetch:nil];
    
    NSArray *arr=self.FetchedResultsController.fetchedObjects;
    
    [self.recentContacts addObjectsFromArray:arr];
    // 刷新数据;
    [self.tableView reloadData];


    
}
#pragma mark--NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
//    [self refreshRecentContacts];
    
    [self.recentContacts removeAllObjects];
    NSArray *recentS=self.FetchedResultsController.fetchedObjects;
    
    [self.recentContacts addObjectsFromArray:recentS];
    // 刷新数据;
    [self.tableView reloadData];

}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentContacts.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // recent_cell
    // 获取数据;
    XMPPMessageArchiving_Contact_CoreDataObject *recent=self.recentContacts[indexPath.row];
    
    // 创建cell；
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"recent_cell"];
    // 给cell赋值;
    UILabel *nameLa=[cell viewWithTag:1002];
    nameLa.text=recent.bareJidStr;
    
    UILabel *messageLa=[cell viewWithTag:1003];
    messageLa.text=recent.mostRecentMessageBody;
    
    UIImageView *imageview=[cell viewWithTag:1001];
    imageview.clipsToBounds=YES;
    imageview.image=[UIImage imageWithData:[[XSCManageStream shareManager].xmppvCardAvatarModule photoDataForJID:recent.bareJid]];
    imageview.layer.cornerRadius=imageview.bounds.size.width/2;
     //[imageview.image ciircleImage];

 
    // 返回cell；
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark--XMPPvCardAvatarDelegate 
-(void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid{
    [self.tableView reloadData];
}
-(NSMutableArray*)recentContacts{
    if (_recentContacts==nil) {
        _recentContacts=[NSMutableArray array];
    }
    return _recentContacts;
}

-(NSFetchedResultsController*)FetchedResultsController{
    if (_FetchedResultsController==nil) {
        
        NSFetchRequest *fetRequest=[[NSFetchRequest alloc]init];
        
        // 实体;
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext ];
        [fetRequest setEntity:entity];
        
        // 谓词;
        // NSPredicate *pre=[NSPredicate predicateWithFormat:@""];
        // 排序；
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
        [fetRequest setSortDescriptors:[NSArray arrayWithObjects:sort ,nil]];
        // 创建查询控制器;
        _FetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // 设置代理;
        _FetchedResultsController.delegate=self;
    }
    return _FetchedResultsController;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)cell{
    
    // 获取数据;
    XMPPMessageArchiving_Contact_CoreDataObject *contact=self.recentContacts[[self.tableView indexPathForCell:cell].row ];
    
    XSCChatViewController *chat=segue.destinationViewController;
    
    chat.userJid=contact.bareJid;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
