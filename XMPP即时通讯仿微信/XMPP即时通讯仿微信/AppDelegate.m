//
//  AppDelegate.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/27.
//  Copyright © 2017年 谢石长. All rights reserved.
//
#define IS_IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


#import "AppDelegate.h"
// iOS10之后 推送通知;
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 登陆;
    [[XSCManageStream shareManager] loginToserver:[XMPPJID jidWithUser:@"lisi" domain:@"127.0.0.1" resource:nil] andPassword:@"123"];
    // 需要一个用户通知设置 iOS10之前;
//    UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeNone categories:nil];
//   
//    // 注册通知;
//    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0) {// iOS 10 之后
        UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge |UNAuthorizationOptionSound |UNAuthorizationOptionAlert completionHandler:^(BOOL granted,NSError *_Nullable error){
            if (! error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                XSCLog(@"推送成功");
            }
        }];
        
    }
    
    return YES;
}

#pragma mark--UNUserNotificationCenterDelegate
// ios 10 之后  推送消息接收;
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary *userInfo=response.notification.request.content.userInfo;
    /*
     UIApplicationStateActive,
     UIApplicationStateInactive,
     UIApplicationStateBackground
     */
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
        
    }else{// 在后台
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
