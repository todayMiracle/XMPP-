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
/** 把图片缩小到指定的宽度范围内为止 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width{
    if (self.size.width <width || width <= 0) {
        return self;
    }
    CGFloat scale = self.size.width/width;
    CGFloat height = self.size.height/scale;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // 开始上下文 目标大小是 这么大
    UIGraphicsBeginImageContext(rect.size);
    
    // 在指定区域内绘制图像
    [self drawInRect:rect];
    
    // 从上下文中获得绘制结果
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文返回结果
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
