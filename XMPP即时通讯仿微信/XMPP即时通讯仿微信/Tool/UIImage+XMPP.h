//
//  UIImage+XMPP.h
//  XMPP即时通讯仿微信
//
//  Created by 谢石长 on 17/3/30.
//  Copyright © 2017年 谢石长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XMPP)

-(UIImage*)ciircleImage;

/** 把图片缩小到指定的宽度范围内为止 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width;
@end
