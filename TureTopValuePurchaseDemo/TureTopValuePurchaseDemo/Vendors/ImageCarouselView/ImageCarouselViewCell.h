//
//  ImageCarouselViewCell.h
//  SDCycleScrollView
//
//  Created by 李晓毅 on 15/12/1.
//  Copyright © 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCarouselButton.h"

@interface ImageCarouselViewCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableArray<ImageCarouselButton*> *imageCarouselButtons;
-(void)setContentWithImages:(NSArray*)images titles:(NSArray*)titles tags:(NSArray*)tags target:(id)target action:(SEL)action;
@end
