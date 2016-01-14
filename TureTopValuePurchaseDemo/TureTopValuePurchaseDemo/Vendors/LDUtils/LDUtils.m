//
//  LDUtils.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDUtils.h"


@implementation LDUtils

+(void)readDataWithResourceName:(NSString*)resourceName successBlock:(void(^)(NSDictionary*))successBlock failureBlock:(void(^)(LDReadResourceStateType,NSString*))failureBlock{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSError *error;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
//        if(filePath == nil){
//            failureBlock(LDReadResourceStateTypePathNoExist,@"文件不存在");
//        }
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:nil] options:NSJSONReadingMutableLeaves error:&error];
//        if(!dic){
//            failureBlock(LDReadResourceStateTypePathNoExist,[NSString stringWithFormat:@"%@",error]);
//        }
//        successBlock(dic);
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
        if(filePath == nil){
            failureBlock(LDReadResourceStateTypePathNoExist,@"文件不存在");
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:nil] options:NSJSONReadingMutableLeaves error:&error];
        if(!dic){
            failureBlock(LDReadResourceStateTypePathNoExist,[NSString stringWithFormat:@"%@",error]);
        }
        successBlock(dic);
    });
}

@end
