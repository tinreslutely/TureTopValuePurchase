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
    CGFloat halfWidth = rect.size.width/2;
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
    CGContextAddArcToPoint(ctx, pointX - radius, pointY, pointX + radius, pointY + radius, radius);
    
    //c1
    CGContextAddLineToPoint(ctx, pointX, pointY);
    
    
    //c1 - c2
    
    
    //d1
    
    
    
    
    return ctx;
}

@end
