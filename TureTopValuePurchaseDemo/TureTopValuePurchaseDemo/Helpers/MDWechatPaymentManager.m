//
//  MDWechatPaymentManager.m
//  MicroValuePurchase
//  微信支付协议扩展类
//  Created by 李晓毅 on 15/12/31.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDWechatPaymentManager.h"
#import "MDPaymentDataController.h"

@implementation MDWechatPaymentManager{
    MDPaymentDataController *_dataController;
}


+(instancetype)sharedWechatPaymentManager{
    static dispatch_once_t onceToken;
    static MDWechatPaymentManager *instance;
    dispatch_once(&onceToken,^{
        instance = [[MDWechatPaymentManager alloc] init];
        
    });
    return instance;
}

#pragma mark WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        NSString *strMsg,*strTitle = @"支付结果";
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功!";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeUserCancel:
                [self cancelPay];
                strMsg = [NSString stringWithFormat:@"支付取消!"];
                break;
            default:
                [self cancelPay];
                strMsg = [NSString stringWithFormat:@"支付失败!"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        if(__IPHONE_SYSTEM_VERSION >= 8.0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle message:strMsg preferredStyle:UIAlertControllerStyleAlert];
            __weak id weakself = self;
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakself backBasePage:APPDELEGATE];
            }]];
            [[APPDELEGATE.window rootViewController] presentViewController:alertController animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self backBasePage:APPDELEGATE];
    }
}

#pragma mark private methods
/*! @brief
 *  支付页返回到首页
 *
 *  @param delegate AppDelegate
 */
-(void)backBasePage:(AppDelegate*)delegate{
    BOOL hasPage = NO;
    NSArray *array = ((UITabBarController*)[[delegate window] rootViewController]).viewControllers;
    for(UINavigationController *navigationController in array){
        for(UINavigationItem *item in navigationController.navigationBar.items){
            if([item.title isEqualToString:@"在线支付"] || [item.title isEqualToString:@"卡包充值"]){
                hasPage = YES;
                break;
            }
        }
        if(hasPage){
            [navigationController popToRootViewControllerAnimated:YES];
            break;
        }
    }
}
/*! @brief
 *  取消支付
 */
-(void)cancelPay{
    if(_dataController == nil){
        _dataController = [[MDPaymentDataController alloc] init];
    }
    [_dataController cancelPaymentWithUserId:APPDATA.userId mergeCode:APPDATA.mergeCode completion:^(BOOL state, NSString * _Nullable msg) {
        if(state){
            APPDATA.mergeCode = @"";
            NSLog(@"取消支付成功");
        }else{
            NSLog(@"取消支付失败");
        }
    }];
}
@end
