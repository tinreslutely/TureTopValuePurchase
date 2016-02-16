//
//  MDMemberDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMemberInfomationModel.h"
#import "MDUploadPicModel.h"

@interface MDMemberDataController : NSObject
-(void)requestDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token completion:(void(^ _Nullable)(BOOL state, NSString*  _Nullable msg,  MDMemberInfomationModel* _Nullable model))completion;

-(void)uploadImageWithImage:(UIImage* _Nullable)image userId:(NSString* _Nullable)userId token:(NSString* _Nullable)token name:(NSString* _Nullable)name  completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDUploadPicModel*  _Nullable model))completion;

-(void)submitMemberInformationDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token name:(NSString* _Nullable)name value:(NSString* _Nullable)value completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;

-(void)submitMemberAreaDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token province:(NSString* _Nullable)province city:(NSString* _Nullable)city district:(NSString* _Nullable)district completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;
@end
