//
//  MDDropdownMenuController.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/11.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDropdownMenuModel.h"

typedef NS_ENUM(NSInteger,DropdownMenuStyle){
    DropdownMenuStyleNumAndNum = 1,
    DropdownMenuStyleImageNoNum
};

@class MDDropdownMenu;

@protocol  MDDropdownMenuDelegate<NSObject>

@optional
-(void)dropdownMenu:(MDDropdownMenu*)dropdownMenu didSelectleftRowAtIndex:(NSInteger)index menuItem:(MDDropdownMenuModel*)menuItem;
-(void)dropdownMenu:(MDDropdownMenu*)dropdownMenu didSelectrightRowAtIndex:(NSInteger)index menuItem:(MDDropdownMenuModel*)menuItem parentMenuItem:(MDDropdownMenuModel*)parentMenuItem;

@end

@interface MDDropdownMenu : UIView

@property(assign,nonatomic) id<MDDropdownMenuDelegate> delegate;
-(id)initWIthLeftArray:(NSArray*)leftArray rightArray:(NSArray*)rightArray style:(DropdownMenuStyle)style selectCode:(NSString*)selectCode;
-(void)show;
-(void)reloadAtLeftDataWithArray:(NSArray*)array;
-(void)reloadAtRightDataWithArray:(NSArray*)array;

@end


