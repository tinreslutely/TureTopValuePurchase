//
//  MDDropDown.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/10/29.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDDropDown;
@protocol MDDropDownDelegate
- (void) niDropDownDelegateMethod: (MDDropDown *) sender;
@end

@interface MDDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
}
@property (nonatomic, retain) id <MDDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
-(id)showDropDownWithView:(UIView*)view button:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr direction:(NSString *)direction;
@end
