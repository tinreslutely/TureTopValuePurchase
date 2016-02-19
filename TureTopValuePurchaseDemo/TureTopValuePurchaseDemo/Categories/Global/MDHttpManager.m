//
//  MDHttpManager.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/20.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHttpManager.h"
#import "AFNetworking.h"

@implementation MDHttpManager


+(void)GET:(NSString*)URLString parameters:(NSDictionary*)params sucessBlock:(void(^)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^)(NSError * _Nonnull error))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(sucessBlock) sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock) failureBlock(error);
    }];
}

+(void)POST:(NSString*)URLString parameters:(NSDictionary*)params sucessBlock:(void(^)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^)(NSError * _Nonnull error))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(sucessBlock) sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock) failureBlock(error);
    }];
}

+(void)POST:(NSString* _Nullable)URLString parameters:(NSDictionary* _Nullable)params image:(UIImage* _Nullable)image sucessBlock:(void(^ _Nullable)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:@"img" fileName:@"img.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(sucessBlock) sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock) failureBlock(error);
    }];
}

@end
