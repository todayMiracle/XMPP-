//
//  XSCXMPPChatKeyBoardView.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  XSCXMPPChatKeyBoardViewDelegate<NSObject>
-(void)clickXSCXMPPChatKeyBoardViewWithBtn:(UIButton*)btn;
@end
@interface XSCXMPPChatKeyBoardView : UIView

@property(nonatomic,strong)id <XSCXMPPChatKeyBoardViewDelegate>delegate;



+(instancetype)showKeyBoard;
@end
