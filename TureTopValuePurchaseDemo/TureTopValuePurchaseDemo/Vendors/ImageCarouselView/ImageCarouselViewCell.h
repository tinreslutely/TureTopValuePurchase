//
//  ImageCarouselViewCell.h
//  SDCycleScrollView
//
//  Created by 李晓毅 on 15/12/1.
//  Copyright © 2015年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCarouselViewCell : UICollectionViewCell

@property (strong, nonatomic) UIControl *imageCarouseControl;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSString *imageCarouseId;

@end
