//
//  XSCRecordTools.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface XSCRecordTools : NSObject
+(instancetype)shareRecorder;



// 开始录音;
-(void)startRecord;

-(void)stopRecordSuccess:(void(^)(NSURL *url,NSTimeInterval timer))success andFail:(void (^)())failed;

-(void)playdata:(NSData*)data completion:(void(^)())completion;

-(void)playVoice:(XMPPMessageArchiving_Message_CoreDataObject*)xmppMessageArchiving_Message_CoreDataObject completion:(void(^)())completion;






@end
