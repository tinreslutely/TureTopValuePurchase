//
//  MDMemberDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMemberDataController.h"

@implementation MDMemberDataController
-(void)requestDataWithUserId:(NSString*)userId token:(NSString*)token completion:(void(^)(BOOL state, NSString *msg,  MDMemberInfomationModel *model))completion{
    [MDHttpManager GET:APICONFIG.memberInfoApiURLString parameters:@{@"userId":userId,@"token":token} sucessBlock:^(id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *dic = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject : [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(dic == nil){
            completion(NO,[NSString stringWithFormat:@"%@",error],nil);
            return;
        }
        NSString *stateCode = [dic objectForKey:@"state"];
        if(![stateCode isEqualToString:@"200"]){
            completion(NO,[dic objectForKey:@"result"],nil);
            return;
        }
        MDMemberInfomationModel *model = [MDMemberInfomationModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
        completion(YES,nil,model);
    } failureBlock:^(NSError * _Nonnull error) {
        completion(NO,[NSString stringWithFormat:@"%@",error],nil);
    }];
}
@end
