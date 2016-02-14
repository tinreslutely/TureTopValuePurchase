//
//  MDDropdownMenuController.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/11.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDDropdownMenu.h"




@interface  MDDropdownMenu()<UITableViewDataSource,UITableViewDelegate>{
    DropdownMenuStyle _style;
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSInteger _selectRow;
    NSString *_selectCode;
}

@end

@implementation MDDropdownMenu

//@synthesize delegate;

#pragma mark life cycle

-(id)initWIthLeftArray:(NSArray*)leftArray rightArray:(NSArray*)rightArray style:(DropdownMenuStyle)style selectCode:(NSString*)selectCode{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)]){
        _selectCode = selectCode;
        _selectRow = 0;
        _leftArray =  [[NSMutableArray alloc] initWithArray:leftArray];
        _rightArray = [[NSMutableArray alloc] initWithArray:rightArray];
        _style = style;
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]];
        [self initView];
    }
    return self;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(tableView == _leftTableView){
        UILabel *spacetorLabel;
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_selectRow inSection:0]];
        if(cell != nil){
            spacetorLabel = [cell viewWithTag:1001];
            [spacetorLabel setBackgroundColor:[UIColor whiteColor]];
        }
        
        cell = [tableView cellForRowAtIndexPath:indexPath];
        spacetorLabel = [cell viewWithTag:1001];
        [spacetorLabel setBackgroundColor:[UIColor redColor]];
        
        _selectRow = indexPath.row;
        MDDropdownMenuModel *model = _leftArray[_selectRow];
        _selectCode = model.code;
        if([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectleftRowAtIndex:menuItem:)]){
            [self.delegate dropdownMenu:self didSelectleftRowAtIndex:_selectRow menuItem:model];
        }
        if(_selectRow == 0) [self hide];
    }else if(tableView == _rightTableView){
        if([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectrightRowAtIndex:menuItem:parentMenuItem:)]){
            [self.delegate dropdownMenu:self didSelectrightRowAtIndex:_selectRow menuItem:_rightArray[indexPath.row] parentMenuItem:_leftArray[_selectRow]];
        }
        [self hide];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}



#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _leftTableView){
        return _leftArray.count;
    }
    return _rightArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(tableView == _leftTableView){
        static NSString *cellIdentifier = @"leftTableViewCellNumAndNum";
        if(_style == DropdownMenuStyleImageNoNum){
            cellIdentifier = @"leftTableViewCellImageNoNum";
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [self createLeftTableViewCellWithIdentifier:cellIdentifier];
        }
        MDDropdownMenuModel *model = _leftArray[indexPath.row];
        UILabel *spacetorLabel = [cell viewWithTag:1001];
        if((([_selectCode isEqualToString:@""] || [_selectCode isEqualToString:@"-1"] ) && _selectRow == 0 && indexPath.row == 0 ) || _selectCode == model.code ){
            _selectRow = indexPath.row;
            [spacetorLabel setBackgroundColor:[UIColor redColor]];
        }else{
            [spacetorLabel setBackgroundColor:[UIColor whiteColor]];
        }
        UILabel *titleLabel = [cell viewWithTag:1002];
        titleLabel.text = model.title;
        if(_style == DropdownMenuStyleImageNoNum){
            UIImageView *imageView = [cell viewWithTag:1003];
            model.isNetworking ? [imageView sd_setImageWithURL:[NSURL URLWithString:model.expand] placeholderImage:[UIImage imageNamed:@"loading"]] : [imageView setImage:[UIImage imageNamed:model.expand]];
        }else{
            UILabel *numberLabel = [cell viewWithTag:1003];
            [numberLabel setText:model.expand];
        }
        
    }else{
        static NSString *cellIdentifier = @"rightTableViewCellNumAndNum";
        if(_style == DropdownMenuStyleImageNoNum){
            cellIdentifier = @"rightTableViewCellImageNoNum";
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [self createRightTableViewCellWithIdentifier:cellIdentifier];
        }
        MDDropdownMenuModel *model = _rightArray[indexPath.row];
        UILabel *titleLabel = [cell viewWithTag:1001];
        titleLabel.text = model.title;
        if(_style == DropdownMenuStyleNumAndNum){
            UILabel *numberLabel = [cell viewWithTag:1002];
            [numberLabel setText:model.expand];
        }
    }
    return cell;
}

#pragma mark action methods
-(void)tapGesture:(UITapGestureRecognizer*)recognizer{
    //[self hide];
}

#pragma mark public methods
-(void)show{
    [APPDELEGATE.window addSubview:self];
    [APPDELEGATE.window bringSubviewToFront:self];
}

-(void)hide{
    [self removeFromSuperview];
}

-(void)reloadAtLeftDataWithArray:(NSArray*)array{
    [_leftArray addObjectsFromArray:array];
    [_leftTableView reloadData];
}

-(void)reloadAtRightDataWithArray:(NSArray*)array{
    [_rightArray removeAllObjects];
    [_rightArray addObjectsFromArray:array];
    [_rightTableView reloadData];
}

#pragma mark private methods
-(void)initView{
    float leftWidth = SCREEN_WIDTH*0.4;
    float height = SCREEN_HEIGHT-64;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    
    UILabel *spactorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [spactorLabel.layer setBorderColor:[UIColorFromRGBA(154, 154, 154, 1) CGColor]];
    [spactorLabel.layer setBorderWidth:0.25];
    [view addSubview:spactorLabel];
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, leftWidth, height) style:UITableViewStyleGrouped];
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    [view addSubview:_leftTableView];
    
    spactorLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftWidth, 1, 0.5, height)];
    [spactorLabel.layer setBorderColor:[UIColorFromRGBA(154, 154, 154, 1) CGColor]];
    [spactorLabel.layer setBorderWidth:0.25];
    [view addSubview:spactorLabel];
    
    _rightTableView = [[UITableView alloc]  initWithFrame:CGRectMake(leftWidth+1, 1, SCREEN_WIDTH*0.6, height) style:UITableViewStyleGrouped];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    [view addSubview:_rightTableView];
}

-(UITableViewCell*)createLeftTableViewCellWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *spacetorLabel = [[UILabel alloc] init];
    [spacetorLabel setTag:1001];
    [cell addSubview:spacetorLabel];
    [spacetorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(2, 20));
    }];
    if(_style == DropdownMenuStyleImageNoNum){
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setTag:1003];
        [cell addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(cell);
            make.left.equalTo(spacetorLabel.mas_right).with.offset(8);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTag: 1002];
        [cell addSubview: titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(imageView.mas_right).with.offset(8);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.height.mas_equalTo(20);
        }];
    }else if(_style == DropdownMenuStyleNumAndNum){
        UILabel *numLabel = [[UILabel alloc] init];
        [numLabel setFont:[UIFont systemFontOfSize:10]];
        [numLabel setTextAlignment:NSTextAlignmentRight];
        [numLabel setTag: 1003];
        [cell addSubview: numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTag: 1002];
        [cell addSubview: titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(numLabel.mas_left).with.offset(0);
            make.left.equalTo(spacetorLabel.mas_right).with.offset(8);
            make.height.mas_equalTo(20);
        }];
        
    }
    return cell;
}

-(UITableViewCell*)createRightTableViewCellWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(_style == DropdownMenuStyleImageNoNum){
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTag: 1001];
        [cell addSubview: titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell.mas_left).with.offset(16);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.height.mas_equalTo(20);
        }];
    }else if(_style == DropdownMenuStyleNumAndNum){
        UILabel *numLabel = [[UILabel alloc] init];
        [numLabel setFont:[UIFont systemFontOfSize:10]];
        [numLabel setTextAlignment:NSTextAlignmentRight];
        [numLabel setTag: 1002];
        [cell addSubview: numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTag: 1001];
        [cell addSubview: titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(numLabel.mas_left).with.offset(0);
            make.left.equalTo(cell.mas_left).with.offset(16);
            make.height.mas_equalTo(20);
        }];
        
    }
    return cell;
}
@end
