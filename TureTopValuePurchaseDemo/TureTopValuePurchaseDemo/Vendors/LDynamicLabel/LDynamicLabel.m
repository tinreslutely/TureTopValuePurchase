//
//  LDynamicLabel.m
//  TureTopValuePurchaseDemo
//  动态UILabel控件
//  根据修改显示的文本，动态修改UILabel的大小（设置文本建议放在设置frame的后面）
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDynamicLabel.h"

@implementation LDynamicLabel{
    LDLabelDirectionType directionType;//显示内容的方向
    BOOL isForce;//是否强制修改控件frame
}

-(instancetype)init{
    isForce = YES;
    directionType = LDLabelDirectionTypeCrossWise;
    return [super init];
}


#pragma mark getters and setters

-(void)setText:(NSString *)text{
    [super setText:[text copy]];
     [self setFrame:[self updateFrame]];
}

/*!
 *  设置显示内容的方向参数
 *
 *  @param type 方向参数
 */
-(void)setDirectionType:(LDLabelDirectionType)type{
    directionType = type;
}

/*!
 *  设置是否强制修改控件frame
 *
 *  @param force 是否强制参数
 */
-(void)setForce:(BOOL)force{
    isForce = force;
}

#pragma mark private methods
-(CGRect)updateFrame{
    CGRect frame = self.frame;
    if(self.text.length > 0){
        CGSize maxSize;
        if(directionType == LDLabelDirectionTypeCrossWise){
            maxSize = CGSizeMake(MAXFLOAT, (frame.size.height == 0 && isForce ? 20 : frame.size.height ));
        }else{
            maxSize = CGSizeMake((frame.size.width == 0 && isForce ? 20 : frame.size.width ),MAXFLOAT);
        }
        if(__IPHONE_SYSTEM_VERSION >= 8.0){
            frame.size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        }else{
            frame.size = directionType == LDLabelDirectionTypeCrossWise ? [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping] : [self.text sizeWithFont:self.font constrainedToSize:maxSize];
        }
    }
    return frame;
}

@end
