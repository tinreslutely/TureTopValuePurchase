//
//  MDMessageViewController.m
//  TureTopValuePurchaseDemo
//  消息控制器
//  Created by 李晓毅 on 16/2/3.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMessageViewController.h"
#import "MDMessageDetailViewController.h"
#import "MDMessageDataController.h"
#import "MDMessageTableViewCell.h"
#import "M13BadgeView.h"

@interface MDMessageViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@end

@implementation MDMessageViewController{
    MDMessageDataController *_dataController;
    UITableView *_mainTableView;
    M13BadgeView *_msgBadgeView;
    M13BadgeView *_nofityBadgeView;
    M13BadgeView *_dynamicBadgeView;
    UIView *_selectedView;
    
    NSMutableArray *_mainMessageArray;//消息列表
    NSMutableArray *_mainNotifyArray;//通知列表
    NSMutableArray *_mainTrendsArray;//动态列表
    int _pageNo;//当前分页数
    int _pageSize;//每页条数
    int _pageTotal;//总数
    int _messageNum;//消息新条数
    int _noticeNum;//通知新条数
    int _dtNum;//动态新条数
    int _messageType;//类型   1-消息  2-通知  3-动态
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark SWTableViewCellDelegate
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDMessageModel *model;
    switch (_messageType) {
        case 1:
            model = _mainMessageArray[indexPath.row];
            break;
        case 2:
            model = _mainNotifyArray[indexPath.row];
            break;
        case 3:
            model = _mainTrendsArray[indexPath.row];
            break;
    }
    if(index == 0){//删除
        [self markReadStateWithUserId:APPDATA.userId messageModel:model];
    }else if(index == 1){
        [self deleteMessageWithUserId:APPDATA.userId messageModel:model];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once  自动隐藏
    return YES;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMessageModel *model;
    switch (_messageType) {
        case 1:
            model = _mainMessageArray[indexPath.row];
            break;
        case 2:
            model = _mainNotifyArray[indexPath.row];
            break;
    }
    MDMessageDetailViewController *controller = [[MDMessageDetailViewController alloc] init];
    controller.messageType = _messageType;
    controller.messageId = [NSString stringWithFormat:@"%d",model.id];
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long count = 0;
    switch (_messageType) {
        case 1:
            count = _mainMessageArray.count;
            break;
        case 2:
            count = _mainNotifyArray.count;
            break;
        case 3:
            count = _mainTrendsArray.count;
            break;
    }
    return count == 0 ? 1 : count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL hasData = YES;
    MDMessageTableViewCell *cell;
    if((_messageType == 1 && _mainMessageArray.count == 0) || (_messageType == 2 && _mainNotifyArray.count == 0) || (_messageType == 3 && _mainTrendsArray.count == 0)){
        hasData = NO;
    }
    if(hasData){
        static NSString *cellIdentifier = @"MessageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[MDMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:78.0f];
            [cell setDelegate:self];
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }else{
        static NSString *noDataCellIdentifier = @"NoMessageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:noDataCellIdentifier];
        if(cell == nil){
            cell = [[MDMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noDataCellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel *label = [[UILabel alloc] init];
            [label setText:@"暂无数据"];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsZero);
            }];
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL hasData = YES;
    MDMessageModel *model;
    switch (_messageType) {
        case 1:
            hasData = _mainMessageArray.count > 0;
            if(hasData) model = _mainMessageArray[indexPath.row];
            break;
        case 2:
            hasData = _mainNotifyArray.count > 0;
            if(hasData) model = _mainNotifyArray[indexPath.row];
            break;
        case 3:
            hasData = _mainTrendsArray.count > 0;
            if(hasData) model = _mainTrendsArray[indexPath.row];
            break;
    }
    if(!hasData) return;
    UIImageView *imageView = [cell viewWithTag:1001];
    [imageView setImage:[UIImage imageNamed:(model.isRead == 0 ? @"msg_noread" : @"msg_read")]];
    UILabel *contentView = [cell viewWithTag:1002];
    [contentView setText:model.content];
}

#pragma mark action and event methods

-(void)refreshData{
    _pageNo = 1;
    [self.progressView show];
    [_dataController requestUnreadDataWithUserId:APPDATA.userId completion:^(BOOL state, NSString *msg, int messageNum, int noticeNum, int dtNum) {
        if(state){
            _messageNum = messageNum;
            _noticeNum = noticeNum;
            _dtNum = dtNum;
            
            [self updateMessageMenuView];
        }
    }];
    [_dataController requestDataWithUserId:APPDATA.userId pageNo:_pageNo pageSize:_pageSize messageType:_messageType  completion:^(BOOL state, NSString *msg, NSArray<MDMessageModel *> *list) {
        if(state){
            switch (_messageType) {
                case 1:
                    [_mainMessageArray removeAllObjects];
                    [_mainMessageArray addObjectsFromArray:list];
                    break;
                case 2:
                    [_mainNotifyArray removeAllObjects];
                    [_mainNotifyArray addObjectsFromArray:list];
                    break;
                case 3:
                    [_mainTrendsArray removeAllObjects];
                    [_mainTrendsArray addObjectsFromArray:list];
                    break;
                    
                default:
                    break;
            }
            [_mainTableView reloadData];
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
        [self.progressView hide];
        [_mainTableView.mj_header endRefreshing];
    }];
}

-(void)loadData{
    _pageNo ++;
    [_dataController requestDataWithUserId:APPDATA.userId pageNo:_pageNo pageSize:_pageSize messageType:_messageType completion:^(BOOL state, NSString *msg, NSArray<MDMessageModel *> *list) {
        if(state){
            switch (_messageType) {
                case 1:
                    [_mainMessageArray addObjectsFromArray:list];
                    break;
                case 2:
                    [_mainNotifyArray addObjectsFromArray:list];
                    break;
                case 3:
                    [_mainTrendsArray addObjectsFromArray:list];
                    break;
                    
                default:
                    break;
            }
            [_mainTableView reloadData];
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
        [_mainTableView.mj_footer endRefreshing];
    }];
}


-(void)messageTap:(UIButton*)button{
    _messageType = 1;
    [self refreshData];
    [self updateMessageSelectStateWithButton:button];
}

-(void)nofityTap:(UIButton*)button{
    _messageType = 2;
    [self refreshData];
    [self updateMessageSelectStateWithButton:button];
}

-(void)dynamicsTap:(UIButton*)button{
    _messageType = 3;
    [self refreshData];
    [self updateMessageSelectStateWithButton:button];
    
}
/*!
 *  删除指定的消息
 *
 *  @param userId 用户id
 *  @param model  消息模型
 */
-(void)deleteMessageWithUserId:(NSString*)userId messageModel:(MDMessageModel*)model{
    [_dataController removeDataWithUserId:userId Id:[NSString stringWithFormat:@"%d",model.id] messageType:_messageType completion:^(BOOL state, NSString *msg) {
        if(state){
            switch (_messageType) {
                case 1:
                    [_mainMessageArray removeObject:model];
                    break;
                case 2:
                    [_mainNotifyArray removeObject:model];
                    break;
                case 3:
                    [_mainTrendsArray removeObject:model];
                    break;
            }
            [self.view makeToast:@"删除成功！" duration:1 position:CSToastPositionBottom];
            [self refreshData];
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
    }];
}
/*!
 *  将未读消息标记已读
 *
 *  @param userId 用户id
 *  @param model  消息模型
 */
-(void)markReadStateWithUserId:(NSString*)userId messageModel:(MDMessageModel*)model{
    [_dataController markReadStateDataWithMessageId:userId messageType:[NSString stringWithFormat:@"%d",model.id] completion:^(BOOL state, NSString *msg) {
        if(state){
            switch (_messageType) {
                case 1:
                    [_mainMessageArray removeObject:model];
                    break;
                case 2:
                    [_mainNotifyArray removeObject:model];
                    break;
                case 3:
                    [_mainTrendsArray removeObject:model];
                    break;
            }
            [self refreshData];
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
    }];
}


#pragma mark private methods
-(void)initData{
    _dataController = [[MDMessageDataController alloc] init];
    _messageType = 1;
    _pageNo = 1;
    _pageSize = 20;
    _mainMessageArray = [[NSMutableArray alloc] init];
    _mainNotifyArray = [[NSMutableArray alloc] init];
    _mainTrendsArray = [[NSMutableArray alloc] init];
}

-(void)initView{
    UIView *navigationView = [self setupCustomNormalNavigationBar];
    [navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(108);
    }];
    [self.titleLabel setText:@"我的消息"];
    
    
    UIView *sortView = [self createViewForCustomConditionWithWidth:SCREEN_WIDTH];
    [navigationView addSubview:sortView];
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.left.equalTo(navigationView.mas_left).with.offset(0);
        make.right.equalTo(navigationView.mas_right).with.offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).with.offset(-6);
    }];
    
    _selectedView = [[UIView alloc] init];
    [_selectedView setBackgroundColor:[UIColor redColor]];
    [navigationView addSubview:_selectedView];
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(navigationView.mas_bottom).with.offset(0);
        make.left.equalTo(navigationView.mas_left).with.offset(0);
        make.right.equalTo(navigationView.mas_right).with.offset(0);
    }];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [_mainTableView setMj_footer:[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)]];
    [_mainTableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self refreshData];
}


/**
 *  添加一个自定义的排序条件的UIView
 *
 *  @param superView 父级UIView
 *  @param height    UIView的高度
 *
 *  @return UIView对象
 */
-(UIView*)createViewForCustomConditionWithWidth:(CGFloat)width{
    UIView *view = [[UIView alloc] init];
    
    float itemWidth = (width-2)/6;
    float spaceOffX = itemWidth/2;
    //消息
    UIButton *salesButton = [[UIButton alloc] init];
    [[salesButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [salesButton setTitle:@"消息" forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    salesButton.tag = 1001;
    [salesButton addTarget:self action:@selector(messageTap:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:salesButton];
    [salesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(-1);
        make.left.equalTo(view.mas_left).with.offset(spaceOffX);
    }];
    
    _msgBadgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
    _msgBadgeView.font = [UIFont systemFontOfSize:10.0];
    _msgBadgeView.hidesWhenZero = YES;
    _msgBadgeView.text = @"0";
    [salesButton addSubview:_msgBadgeView];
    
    
    UILabel *sepLabel = [[UILabel alloc] init];
    [sepLabel setBackgroundColor:UIColorFromRGBA(204, 204, 204, 1)];
    [view addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(view.mas_top).with.offset(10);
        make.bottom.equalTo(view.mas_bottom).with.offset(-5);
        make.left.equalTo(salesButton.mas_right).with.offset(spaceOffX);
    }];
    
    //价格
    UIButton *priceSortButton = [[UIButton alloc] init];
    [priceSortButton addTarget:self action:@selector(nofityTap:) forControlEvents:UIControlEventTouchDown];
    [priceSortButton setTag:1002];
    [[priceSortButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [priceSortButton setTitle:@"通知" forState:UIControlStateNormal];
    [priceSortButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [priceSortButton setImageEdgeInsets:UIEdgeInsetsMake(0, (itemWidth/2)+20, 0, 0)];
    [view addSubview:priceSortButton];
    [priceSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(-1);
        make.left.equalTo(sepLabel.mas_right).with.offset(spaceOffX);
    }];
    
    _nofityBadgeView= [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
    _nofityBadgeView.font = [UIFont systemFontOfSize:10.0];
    _nofityBadgeView.hidesWhenZero = YES;
    _nofityBadgeView.text = @"0";
    [priceSortButton addSubview:_nofityBadgeView];
    
    sepLabel = [[UILabel alloc] init];
    [sepLabel setBackgroundColor:UIColorFromRGBA(204, 204, 204, 1)];
    [view addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(view.mas_top).with.offset(10);
        make.bottom.equalTo(view.mas_bottom).with.offset(-5);
        make.left.equalTo(priceSortButton.mas_right).with.offset(spaceOffX);
    }];
    
    //最新
    UIButton *newSortButton = [[UIButton alloc] init];
    [[newSortButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [newSortButton setTitle:@"公告" forState:UIControlStateNormal];
    [newSortButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [newSortButton addTarget:self action:@selector(dynamicsTap:) forControlEvents:UIControlEventTouchDown];
    newSortButton.tag = 1003;
    [view addSubview:newSortButton];
    [newSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(-1);
        make.left.equalTo(sepLabel.mas_right).with.offset(spaceOffX);
    }];
    
    _dynamicBadgeView= [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 16.0, 16.0)];
    _dynamicBadgeView.font = [UIFont systemFontOfSize:10.0];
    _dynamicBadgeView.hidesWhenZero = YES;
    _dynamicBadgeView.text = @"0";
    [newSortButton addSubview:_dynamicBadgeView];
    
    return view;
}


/**
 *  设置cell隐藏的按钮
 *
 *  @return 数组
 */
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"标记已读"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

-(void)updateMessageMenuView{
    [_msgBadgeView setText:[NSString stringWithFormat:@"%d",_messageNum]];
    [_nofityBadgeView setText:[NSString stringWithFormat:@"%d",_noticeNum]];
    [_dynamicBadgeView setText:[NSString stringWithFormat:@"%d",_dtNum]];
}


-(void)updateMessageSelectStateWithButton:(UIButton*)button{
    UIView *superView = [button superview];
    int tag = 1000;
    for (UIButton *view in [superView subviews]) {
        if([view isKindOfClass:[UIButton class]]){
            [view setTitleColor:(view == button ? [UIColor redColor] : [UIColor grayColor]) forState:UIControlStateNormal];
        }
    }
}

@end
