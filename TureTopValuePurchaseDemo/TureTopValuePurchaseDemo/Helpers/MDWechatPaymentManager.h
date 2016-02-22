//
//  MDWechatPaymentManager.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/31.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface MDWechatPaymentManager : NSObject<WXApiDelegate>
+(instancetype)sharedWechatPaymentManager;
@end
