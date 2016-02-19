//
//  ImageCarouselViewCell.m
//  SDCycleScrollView
//
//  Created by 李晓毅 on 15/12/1.
//  Copyright © 2015年 GSD. All rights reserved.
//

#import "ImageCarouselViewCell.h"

@implementation ImageCarouselViewCell

@synthesize imageCarouselButtons;


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        imageCarouselButtons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)setContentWithImages:(NSArray*)images titles:(NSArray*)titles tags:(NSArray*)tags target:(id)target action:(SEL)action{
    float pointX = 0;
    float width = self.frame.size.width/3;
    ImageCarouselButton *button;
    for (int i = 0; i < images.count; i++) {
        button = [[ImageCarouselButton alloc] initWithFrame:CGRectMake(pointX, 0, width, self.frame.size.height)];
        [button.imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        if(titles.count > i){
            [button.titleLabel setText:titles[i]];
        }
        if(tags.count > i){
            [button setTag:[tags[i] intValue]];
        }
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [imageCarouselButtons addObject:button];
        pointX += width;
    }
}

@end

