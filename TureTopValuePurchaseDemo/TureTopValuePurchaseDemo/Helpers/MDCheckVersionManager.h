//
//  MDCheckVersionManager.h
//  TureTopValuePurchaseDemo
//  检查版本类
//  Created by 李晓毅 on 16/2/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCheckVersionManager : NSObject<UIAlertViewDelegate>

+(instancetype)sharedManager;

-(void)checkedVersionForApp;

@end
