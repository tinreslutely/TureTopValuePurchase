//
//  LDCombobxView.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/31.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDCombobxView.h"

@implementation LDCombobxView{
    
}

-(void)drawRect:(CGRect)rect{
    
    //CGContextStrokePath((ctx);
    
}

-(CGContextRef)drawRect:(CGRect)rect radius:(CGFloat)radius{
    CGFloat pointX;
    CGFloat pointY;
    CGFloat tw = rect.size.width/5;
    CGFloat th = tw * sin(2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetRGBStrokeColor(ctx, 189, 189, 189, 1);
    //开始
    CGContextBeginPath(ctx);
    
    //起始点
    pointX = rect.origin.x + rect.size.width/2;
    pointY = rect.origin.y;
    CGContextMoveToPoint(ctx, pointX, pointY);
    
    //o2点
    pointX += tw/2;
    pointY -= th;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    //b1
    pointX = rect.origin.x + rect.size.width - radius;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    //b1 - b2
    pointX += radius;
    CGContextAddArcToPoint(ctx, pointX - radius, pointY, pointX, pointY + radius, radius);
    
    //c1
    pointY += rect.size.height - radius;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    
    //c1 - c2
    pointY += radius;
    pointX -= radius;
    CGContextAddArcToPoint(ctx, pointX + radius, pointY - radius, pointX, pointY, radius);
    
    
    //d1
    pointX -= rect.size.width - radius;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    
    //d1 - d2
    pointX = rect.origin.x;
    CGContextAddArcToPoint(ctx, pointX - radius, pointY, pointX, pointY - radius, radius);
    
    
    //a2
    pointY -= rect.size.height - radius;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    //a2 - a1
    CGContextAddArcToPoint(ctx, pointX, pointY, pointX + radius, pointY - radius, radius);
    
    
    //o1
    pointX = rect.origin.x + rect.size.width/2 - tw/2;
    pointY = rect.origin.y + th;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    
    //起始点
    pointX += tw/2;
    pointY -= th;
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    
    
    //结束
    CGContextStrokePath(ctx);
    return ctx;
}

@end
