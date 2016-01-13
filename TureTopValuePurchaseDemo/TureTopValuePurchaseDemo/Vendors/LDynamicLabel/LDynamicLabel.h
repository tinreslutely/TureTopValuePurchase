//
//  LDynamicLabel.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LDLabelDirectionType){
    LDLabelDirectionTypeCrossWise,//横向
    LDLabelDirectionTypeLengthWise//纵向
};

@interface LDynamicLabel : UILabel

-(void)setDirectionType:(LDLabelDirectionType)type;
-(void)setForce:(BOOL)force;

@end
