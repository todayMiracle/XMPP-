//
//  XSCChatCell.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSCChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLa;
@property(nonatomic,strong)NSData *audioData;

@property(nonatomic,strong)XMPPMessageArchiving_Message_CoreDataObject *message_CoreDataOb;




@end
