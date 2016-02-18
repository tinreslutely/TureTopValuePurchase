//
//  MDShopManageDataController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/17.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDShopInformationModel.h"
#import "MDUploadPicModel.h"

@interface MDShopManageDataController : NSObject

-(void)requestDataWithUserId:(NSString* _Nullable)userId completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDShopInformationModel*  _Nullable model))completion;

-(void)uploadImageWithImage:(UIImage* _Nullable)image userId:(NSString* _Nullable)userId token:(NSString* _Nullable)token completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg, MDUploadPicModel*  _Nullable model))completion;

-(void)submitShopInformationDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token shopNavigationPic:(NSString* _Nullable) shopNavigationPic shopLogo:(NSString* _Nullable)shopLogo shopName:(NSString* _Nullable)shopName businessHours:(NSString* _Nullable)businessHours serviceQq:(NSString* _Nullable)serviceQq serviceTel:(NSString* _Nullable)serviceTel street:(NSString* _Nullable)street isModified:(int)isModified area:(NSString* _Nullable)area completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;

-(void)submitMemberAreaDataWithUserId:(NSString* _Nullable)userId token:(NSString* _Nullable)token province:(NSString* _Nullable)province city:(NSString* _Nullable)city district:(NSString* _Nullable)district completion:(void(^ _Nullable)(BOOL state, NSString* _Nullable msg))completion;
@end
