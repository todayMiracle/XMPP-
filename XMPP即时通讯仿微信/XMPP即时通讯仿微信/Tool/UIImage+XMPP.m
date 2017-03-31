//
//  UIImage+XMPP.m
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/30.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import "UIImage+XMPP.h"

@implementation UIImage (XMPP)

-(UIImage*)ciircleImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGRect rect=CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [self drawInRect:rect];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
    
}
@end
