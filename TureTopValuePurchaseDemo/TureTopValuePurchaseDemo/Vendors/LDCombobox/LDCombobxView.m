//
//  LDCombobxView.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/31.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDCombobxView.h"

@implementation LDCombobxView{
    float _tw;
    float _th;
    float _radius;
    float _borderWidth;
    UIColor *_borderColor;
    BOOL _hasShadow;
    
}

@synthesize contentView;

-(instancetype)initWithFrame:(CGRect)frame{
    _tw = frame.size.width/10;
    _th = _tw * sin(2);
    
    if(self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + _th)]){
        [self setBackgroundColor:[UIColor clearColor]];
        _radius = 2;
        _borderWidth = 0.5;
        _hasShadow = YES;
        _borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(1.5, _th + 0.5, self.frame.size.width-3, self.frame.size.height - _th-3)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        [contentView.layer setCornerRadius:_radius];
        [contentView.layer setMasksToBounds:YES];
        [contentView setClipsToBounds:YES];
        [self addSubview:contentView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self drawRect:CGRectMake(rect.origin.x + 1, rect.origin.y, rect.size.width - 2, rect.size.height - _th - 2) radius:_radius];
    
}
#pragma mark public methods
/*!
 *  边框颜色
 *
 *  @param color 颜色
 */
-(void)setBorderColor:(UIColor*)color{
    _borderColor = color;
    [self setNeedsDisplay];
}
/*!
 *  存在阴影
 *
 *  @param show 值
 */
-(void)setHasShadow:(BOOL)show{
    _hasShadow = show;
    [self setNeedsDisplay];
}


#pragma mark private methods
-(CGContextRef)drawRect:(CGRect)rect radius:(CGFloat)radius{
    CGFloat pointX;
    CGFloat pointY;
    //配置
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawPath(ctx,kCGPathFill);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    [_borderColor setFill];
    
    //开始
    CGContextBeginPath(ctx);
    
    //A点坐标
    pointX = rect.origin.x;
    pointY = rect.origin.y + _th;
    //A2点
    CGContextMoveToPoint(ctx, pointX, pointY + radius);
    //A点-A1点 圆角
    CGContextAddArcToPoint(ctx, pointX, pointY, pointX + radius, pointY, radius);
    
    
    //O点坐标
    pointX = rect.origin.x + rect.size.width/2;
    pointY = rect.origin.y;
    //O1点
    CGContextAddLineToPoint(ctx, pointX - _tw/2, pointY + _th);
    //O点
    CGContextAddLineToPoint(ctx, pointX, pointY);
    //O2点
    CGContextAddLineToPoint(ctx, pointX + _tw/2, pointY + _th);
    
    
    //B点坐标
    pointX = rect.origin.x + rect.size.width;
    pointY = rect.origin.y + _th;
    //B1点
    CGContextAddLineToPoint(ctx, pointX - radius, pointY);
    //B点-B2点 圆角
    CGContextAddArcToPoint(ctx, pointX, pointY, pointX, pointY + radius, radius);
    
    
    //C点坐标
    pointX = rect.origin.x + rect.size.width;
    pointY = rect.origin.y + rect.size.width + _th;
    //C1点
    CGContextAddLineToPoint(ctx, pointX, pointY - radius);
    //C点-C2点 圆角
    CGContextAddArcToPoint(ctx, pointX, pointY, pointX - radius, pointY, radius);
    
    //D点坐标
    pointX = rect.origin.x;
    pointY = rect.origin.y + rect.size.width + _th;
    //D1点
    CGContextAddLineToPoint(ctx, pointX + radius, pointY);
    //D点-D2点 圆角
    CGContextAddArcToPoint(ctx, pointX , pointY, pointX, pointY - radius, radius);
    
    if(_hasShadow) CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 2, [UIColor grayColor].CGColor);
    //结束
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    return ctx;
}

@end
