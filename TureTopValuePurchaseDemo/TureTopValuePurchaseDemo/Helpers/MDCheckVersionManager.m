//
//  MDCheckVersionManager.m
//  TureTopValuePurchaseDemo
//  检查版本类
//  Created by 李晓毅 on 16/2/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDCheckVersionManager.h"

@implementation MDCheckVersionManager{
    int _alertType;//1-更新提示类型  2-支付提示类型
}

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static MDCheckVersionManager *instance;
    dispatch_once(&onceToken,^{
        instance = [[MDCheckVersionManager alloc] init];
        
    });
    return instance;
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(_alertType == 1 && buttonIndex == 1){
        [MDCommon UpdateVersion];
    }
}

/*!
 *  检查app版本
 */
-(void)checkedVersionForApp{
    //推送更新
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *query = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", AppID];
        query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
        if(results != nil){
            NSDictionary *dic = [[results objectForKey:@"results"] firstObject];
            float version = [[dic objectForKey:@"version"] floatValue];
            if(version > APP_VERSION){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertMessage:[NSString stringWithFormat:@"最新版本%.1f已经发布！",version]];
                });
            }
        }
        
    });
}

-(void)showAlertMessage:(NSString*)message{
    _alertType = 1;
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MDCommon UpdateVersion];
        }]];
        [[APPDELEGATE.window rootViewController] presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"前往更新",nil];
        [alertView show];
    }
}

@end
