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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/json",@"text/html",@"text/plain"]];
    [manager GET:URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(sucessBlock) sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock) failureBlock(error);
    }];
}

+(void)POST:(NSString*)URLString parameters:(NSDictionary*)params sucessBlock:(void(^)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^)(NSError * _Nonnull error))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/json",@"text/html",@"text/plain"]];
    [manager POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(sucessBlock) sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureBlock) failureBlock(error);
    }];
}

+(void)POST:(NSString* _Nullable)URLString parameters:(NSDictionary* _Nullable)params image:(UIImage* _Nullable)image sucessBlock:(void(^ _Nullable)(id  _Nullable responseObject))sucessBlock failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/json",@"text/html",@"text/plain"]];
        [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:@"img" fileName:@"img.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(sucessBlock) sucessBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(failureBlock) failureBlock(error);
        }];
    }else{
        NSString* tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
        NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
        NSMutableURLRequest *multipartRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            NSData *data = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:data name:@"img" fileName:@"img.png" mimeType:@"image/png"];
        } error:nil];
        [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:multipartRequest writingStreamContentsToFile:tmpFileUrl completionHandler:^(NSError *error) {
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:multipartRequest fromFile:tmpFileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl error:nil];
                if (error) {
                    if(failureBlock) failureBlock(error);
                } else {
                    if(sucessBlock) sucessBlock(responseObject);
                }
            }];
            [uploadTask resume];
        }];
    }
}

@end
