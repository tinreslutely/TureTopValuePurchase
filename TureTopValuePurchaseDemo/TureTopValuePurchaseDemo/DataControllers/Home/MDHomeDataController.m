//
//  MDHomeDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeDataController.h"


@implementation MDHomeDataController

#pragma mark public methods
-(void)requestDataWithType:(NSString*)type completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel*> *list))completion{
    [LDUtils readDataWithResourceName:@"data-home" successBlock:^(NSDictionary *returnData) {
        MDHomeRenovateModel *renovateModel = [[MDHomeRenovateModel alloc] init];
        renovateModel.stateCode = [returnData objectForKey:@"state"];
        if(![renovateModel.stateCode isEqualToString:@"200"]){
            renovateModel.state = NO;
            renovateModel.message = [returnData objectForKey:@"result"];
            completion(renovateModel.state,renovateModel.message,@[]);
            return;
        }
        renovateModel.state = YES;
        renovateModel.list = [MDHomeRenovateChannelModel mj_objectArrayWithKeyValuesArray:[[returnData objectForKey:@"result"] objectForKey:@"list"]];
        for (MDHomeRenovateChannelModel *channelModel in renovateModel.list) {
            channelModel.channelColumnDetails = [MDHomeRenovateChannelDetailModel mj_objectArrayWithKeyValuesArray:channelModel.channelColumnDetails];
        }
        completion(renovateModel.state,renovateModel.message,renovateModel.list);
    } failureBlock:^(LDReadResourceStateType stateType, NSString *msg) {
        completion(NO,msg,@[]);
    }];
}

@end
