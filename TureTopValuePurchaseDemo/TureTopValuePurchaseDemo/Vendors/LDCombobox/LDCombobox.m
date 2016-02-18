//
//  LDCombobox.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/29.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDCombobox.h"
@interface LDCombobox()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LDCombobox{
    UIView *_superView;
    UILabel *_typeLabel;
    UIImageView *_typeImageView;
    UIImage *_dropStateImage;
    
    NSMutableArray *_comboItems;//key  value
    float _comboViewPointX;
    float _comboViewPointY;
    float _comboViewHeight;
    
    id _selectValue;
    int _selectIndex;
}

@synthesize dropState,comboboxView;

-(instancetype)initWithFrame:(CGRect)frame comboSuperView:(UIView*)superView items:(NSArray*)items{
    if(self = [super initWithFrame:frame]){
        _superView = superView;
        dropState = NO;
        _selectIndex = 0;
        _selectValue = [[items firstObject] objectForKey:@"value"];
        _comboItems = [[NSMutableArray alloc] initWithArray:items];
        _dropStateImage = [UIImage imageNamed:@"arrow_bottom_b"];
        [self addTarget:self action:@selector(drop) forControlEvents:UIControlEventTouchDown];
        [self initView];
    }
    return self;
}

-(void)drop{
    dropState = !dropState;
    if(dropState){
        [self dropDown];
    }else{
        [self dropUpWithAnimation:YES];
    }
}

-(void)dropDown{
    if(comboboxView == nil){
        _comboViewPointX = self.frame.origin.x;
        _comboViewPointY = self.frame.size.height + self.frame.origin.y;
        UIView *view = [self superview];
        for (;;) {
            if(view == nil || view == _superView) break;
            _comboViewPointX += view.frame.origin.x;
            _comboViewPointY += view.frame.origin.y;
            view = [view superview];
        }
        [self setupComboboxViewWithFrame:CGRectMake(_comboViewPointX, _comboViewPointY, self.frame.size.width, _comboItems.count * 30)];
        [_superView addSubview:comboboxView];
        [_superView bringSubviewToFront:comboboxView];
    }
    
    UITableView *tableView = (UITableView*)[comboboxView viewWithTag:1001];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [_typeImageView setImage:[UIImage imageWithCGImage:_dropStateImage.CGImage scale:1 orientation:UIImageOrientationDown]];
    [UIView animateWithDuration:0.2 animations:^{
        [comboboxView setFrame:CGRectMake(comboboxView.frame.origin.x, comboboxView.frame.origin.y, comboboxView.frame.size.width, _comboViewHeight)];
        [comboboxView.contentView setAlpha:1];
    }];
}

-(void)dropUpWithAnimation:(BOOL)animation{
    [_typeImageView setImage:[UIImage imageWithCGImage:_dropStateImage.CGImage scale:1 orientation:UIImageOrientationUp]];
    if(animation){
        [UIView animateWithDuration:0.2 animations:^{
            [comboboxView setFrame:CGRectMake(comboboxView.frame.origin.x, comboboxView.frame.origin.y, comboboxView.frame.size.width, 0)];
            [comboboxView.contentView setAlpha:0];
        }];
    }else{
        [comboboxView setFrame:CGRectMake(comboboxView.frame.origin.x, comboboxView.frame.origin.y, comboboxView.frame.size.width, 0)];
        [comboboxView.contentView setAlpha:0];
    }
    //dropState = !dropState;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =_comboItems[indexPath.row];
    _selectIndex = (int)indexPath.row;
    _selectValue = [dic objectForKey:@"value"];
    [_typeLabel setText:[dic objectForKey:@"key"]];
    [self dropUpWithAnimation:YES];
    dropState = !dropState;
    if([self.delegate respondsToSelector:@selector(combobox:didSelectedRowValue:)]){
        [self.delegate combobox:self didSelectedRowValue:dic];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comboItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *comboCellIdentifier = @"ComboCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:comboCellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:comboCellIdentifier];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(__IPHONE_SYSTEM_VERSION >=8){
        if([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if([cell respondsToSelector:@selector(setLayoutMargins:)]){
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    NSDictionary *dic = _comboItems[indexPath.row];
    [cell.textLabel setText:[dic objectForKey:@"key"]];
}

#pragma mark public methods
-(void)setComboItems:(NSArray*)items{
    [_comboItems removeAllObjects];
    [_comboItems addObjectsFromArray:items];
}

#pragma mark private methods
-(void)initView{
    
    _typeLabel = [[UILabel alloc] init];
    [_typeLabel setText:@"商品"];
    [_typeLabel setTextColor:UIColorFromRGB(161, 161, 161)];
    [_typeLabel setTextAlignment:NSTextAlignmentCenter];
    [_typeLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_typeLabel];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 30));
        make.left.equalTo(self.mas_left).with.offset(8);
        make.centerY.equalTo(self);
    }];
    
    UILabel *spaceLabel = [[UILabel alloc] init];
    [spaceLabel setBackgroundColor:UIColorFromRGB(161, 161, 161)];
    [self addSubview:spaceLabel];
    [spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
    _typeImageView = [[UIImageView alloc] init];
    [_typeImageView setImage:_dropStateImage];
    [self addSubview:_typeImageView];
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 5));
        make.right.equalTo(spaceLabel.mas_left).with.offset(-8);
        make.centerY.equalTo(self);
    }];
    
}

-(void)setupComboboxViewWithFrame:(CGRect)frame{
    comboboxView = [[LDCombobxView alloc] initWithFrame:frame];
    
    UITableView *comboboxTableView = [[UITableView alloc] initWithFrame:comboboxView.contentView.bounds style:UITableViewStylePlain];
    [comboboxTableView setTag:1001];
    [comboboxTableView setDataSource:self];
    [comboboxTableView setDelegate:self];
    [comboboxTableView setShowsHorizontalScrollIndicator:NO];
    [comboboxView.contentView addSubview:comboboxTableView];
    
    if(__IPHONE_SYSTEM_VERSION >=8){
        if([comboboxTableView respondsToSelector:@selector(setSeparatorInset:)]){
            [comboboxTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([comboboxTableView respondsToSelector:@selector(setLayoutMargins:)]){
            [comboboxTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if([comboboxTableView respondsToSelector:@selector(separatorInset)]){
            [comboboxTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
    _comboViewHeight = comboboxView.frame.size.height;
    [comboboxView setFrame:CGRectMake(comboboxView.frame.origin.x, comboboxView.frame.origin.y, comboboxView.frame.size.width, 0)];
    [comboboxView.contentView setAlpha:0];
}

@end
