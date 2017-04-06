//
//  NSDate+satinWordDate.h
//  学习编：百思不得姐
//
//  Created by XSC on 16/9/4.
//  Copyright © 2016年 XieYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (satinWordDate)
//比较frome与self的时间差;
-(NSDateComponents*)deltaFrom:(NSDate*)from;

//是否为今年
-(BOOL)isThisYear;
//是否为今天
-(BOOL)isToday;
//是否为昨天;
-(BOOL)isYesterday;
@end
