//
//  LDynamicLabel.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDynamicLabel.h"
#define __SYSTEM_VERSION_IOS7_LATER ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0)
@implementation LDynamicLabel

-(void)setText:(NSString *)text{
    [super setText:text];
#if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0)
    
#else
    
#endif
}

@end
