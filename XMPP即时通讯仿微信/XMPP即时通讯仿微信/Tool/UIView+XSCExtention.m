//
//  UIView+XSCExtention.m
//  学习编：百思不得姐
//
//  Created by XSC on 16/4/17.
//  Copyright © 2016年 XieYuan. All rights reserved.
//

#import "UIView+XSCExtention.h"
//Objiective-C File设置的文件
@implementation UIView (XSCExtention)
//实现 set方法；
-(void)setSize:(CGSize)size{
    CGRect frame=self.frame;
    frame.size=size;
    self.frame=frame;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
    
}
-(void)setHeigth:(CGFloat)heigth{
    CGRect frame=self.frame;
    frame.size.height=heigth;
    self.frame=frame;
}
-(void)setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(void)setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}
// 设置精华顶部titlesView里button位置
-(void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}
-(CGSize)size{
    return self.frame.size;
}
-(CGFloat)centerY{
    return self.center.y;
}
-(CGFloat)centerX{
    return self.center.x;
}
//实现  get方法；
-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat )heigth{
    return self.frame.size.height;
}
-(CGFloat)x{
    return self.frame.origin.x;
    
}
-(CGFloat)y{
    return self.frame.origin.y;
    
}
// 判断view 是否在当前主窗口中;
-(BOOL)isShowingOnKeyWindow{
    
    UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
    
    CGRect newFrame=[keyWindow convertRect:self.frame fromView:self.superview];
    CGRect windowFrame=keyWindow.bounds;
    
    // 判断该View 是否与当前主窗口的有重合 frame;
    BOOL intersects=CGRectIntersectsRect(newFrame, windowFrame);
    return !self.hidden && self.alpha>0.01 &&self.window==keyWindow&& intersects;
}
// 加载Xibview;
+(instancetype)ViewFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
