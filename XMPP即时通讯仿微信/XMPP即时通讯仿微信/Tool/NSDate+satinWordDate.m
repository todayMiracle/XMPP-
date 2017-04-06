//
//  NSDate+satinWordDate.m
//  学习编：百思不得姐
//
//  Created by XSC on 16/9/4.
//  Copyright © 2016年 XieYuan. All rights reserved.
//

#import "NSDate+satinWordDate.h"

@implementation NSDate (satinWordDate)
-(NSDateComponents*)deltaFrom:(NSDate *)from{
    //日历;
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //比较时间;
    NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

//是否为今年
-(BOOL)isThisYear{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSInteger nowYear=[calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear=[calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear==selfYear;
}
//是否为今天

//方法一

/*-(BOOL)isToday{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSCalendarUnit units=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *nowComps=[calendar components:units fromDate:[NSDate date]];
    NSDateComponents *selfComp=[calendar components:units fromDate:[NSDate date]];
    
    return nowComps.year==selfComp.year && nowComps.month==selfComp.month && nowComps.day==selfComp.day;
    
}*/
//  方法二
-(BOOL)isToday{
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    
    NSString *nowString=[fmt stringFromDate:[NSDate date]];
    NSString *selfString=[fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
    
    
}
//是否为昨天;
-(BOOL)isYesterday{
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    
    NSDate *nowDate=[fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate=[fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return comps.year==0
    && comps.month==0
    && comps.day==0;
}

@end
