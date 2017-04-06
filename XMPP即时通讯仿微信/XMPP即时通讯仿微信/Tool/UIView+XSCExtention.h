//
//  UIView+XSCExtention.h
//  学习编：百思不得姐
//
//  Created by XSC on 16/4/17.
//  Copyright © 2016年 XieYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XSCExtention)
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat heigth;
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;
-(void)setWidth:(CGFloat)width;
-(void)setHeigth:(CGFloat)heigth;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;
-(void)setCenterX:(CGFloat)centerX;
-(void)setCenterY:(CGFloat)centerY;
/**  在分类中声明@property ,只会生成方法的声明，不会生成方法的实现_下划线的成员变量*/
-(BOOL)isShowingOnKeyWindow;
@end
