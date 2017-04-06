//
//  XSCRecordTools.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/4/4.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "XSCRecordTools.h"
@interface  XSCRecordTools()<AVAudioPlayerDelegate>
/** 录音器*/
@property(nonatomic,strong)AVAudioRecorder *recorder;
/** 录音地址*/
@property(nonatomic,strong) NSURL *recordURL;


/** 播放器 */
@property(nonatomic,strong) AVAudioPlayer *player;

/** 播放完成时回调 */
@property(nonatomic,copy) void (^palyCompletion)();
@end
@implementation XSCRecordTools

static XSCRecordTools *RecordT;
//-(NSURL*)recordURL{
//    if (_recordURL==nil) {
//        int a=arc4random_uniform(30);
//        // 存储录音文件的地址
//        _recordURL=[NSURL URLWithString:[NSString stringWithFormat:@"/Users/xieshichang/Desktop/123%zi.caf",a]];
//    }
//    return _recordURL;
//}

-(AVAudioRecorder*)recorder{
    if (_recorder==nil) {
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path=[path stringByAppendingPathComponent:[XMPPStream generateUUID]];
        path=[path stringByAppendingPathExtension:@"wav"];
        NSURL *url=[NSURL fileURLWithPath:path];
        self.recordURL=url;
        _recorder=[[AVAudioRecorder alloc]initWithURL:url settings:nil error:nil];
    }
    return _recorder;
}

+(instancetype)shareRecorder{
    static dispatch_once_t onceToken;// 创建一个单例;
    dispatch_once(&onceToken, ^{
        RecordT=[[XSCRecordTools alloc]init];
    });
    return RecordT;
}
/**开始录音*/
-(void)startRecord{
    [self.recorder prepareToRecord];
    
    [self.recorder record];
}

/**停止录音*/
-(void)stopRecordSuccess:(void(^)(NSURL *url,NSTimeInterval timer))success andFail:(void (^)())failed{
    // 只有这里才能取到 currentTime
    NSTimeInterval time=self.recorder.currentTime;
    
    [self.recorder stop];
    
    
    
    
    if (time<1.5) {
        if (failed) {
            failed();
        }
    }else{
        if (success) {
            success(self.recorder.url,time);
        }
    }
}

-(void)playdata:(NSData*)data completion:(void(^)())completion{
    // 判断是否正在播放;
    if (self.player.isPlaying) {
        [self.player stop];
    }
    
    // 记录代码块;
    self.palyCompletion=completion;
    
    // 监听播放器的播放状态;
    XSCLog(@"监听播放器的播放状态%@",data);
    self.player=[[AVAudioPlayer alloc]initWithData:data error:NULL];
    
    self.player.delegate=self;
    
    [self.player play];
}
-(void)playVoice:(XMPPMessageArchiving_Message_CoreDataObject*)xmppMessageArchiving_Message_CoreDataObject completion:(void(^)())completion{
    
    // 判断是否正在播放;
    if (self.player.isPlaying) {
        [self.player stop];
    }
    
    // 记录代码块;
    self.palyCompletion=completion;
    

    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path=[path stringByAppendingPathComponent:xmppMessageArchiving_Message_CoreDataObject.message.body];
    NSURL *url=[NSURL URLWithString:path];
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    self.player.delegate=self;
    
    [self.player play];
 

}
// 工具类中的方法写完了之后，可以去外面调用了。给自己这个自定义的SXChatCell添加一个点击方法。默认情况下按钮是默认颜色的，点击时颜色变成红色，然后播放完成时的回调代码再把颜色恢复成默认颜色。
#pragma mark--录音播放完成代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.palyCompletion) {
        self.palyCompletion();
    }
}
@end
