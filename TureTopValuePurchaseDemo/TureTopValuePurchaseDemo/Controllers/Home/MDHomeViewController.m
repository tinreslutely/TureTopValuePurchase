//
//  MDHomeViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeDataController.h"
#import "MDNavigationController.h"
#import "MDSearchViewController.h"
#import "LDSearchViewController.h"

#import "MDHomeBannerFoundationTableViewCell.h"
#import "MDHomeLikeProductTableViewCell.h"
#import "MDHomeRedClassesTableViewCell.h"
#import "MDHomeRedShopTableViewCell.h"
#import "MDHomeLikeProductTipTableViewCell.h"

#import "LDSearchBar.h"

@interface MDHomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,ImageCarouselViewDelegate,LDSearchBarDelegate>

@end

@implementation MDHomeViewController{
    
    UITableView *_mainTableView;
    MDHomeDataController *_dataController;
    NSArray<MDHomeRenovateChannelModel*> *_channelList;
    
    
    NSString *_type;
    float _bannerHeight;
    float _imageHeight;
    float _proImageHeight;
    float _rmShopHeight;
    
    int _pageIndex;
    int _pageSize;
    int _pageTotal;
    BOOL _isLast;
    BOOL _isDragging;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initData];
    [self initView];
    [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:YES];
    [self refreshData];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:NO];
    //[self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark LDSearchBarDelegate
-(void)searchBar:(LDSearchBar *)searchBar willStartEditingWithTextField:(UITextField *)textField{
    [textField resignFirstResponder];
    MDNavigationController *navigationController = [[MDNavigationController alloc] initWithRootViewController:[[MDSearchViewController alloc] init]];
    [self presentViewController:[[LDSearchViewController alloc] init] animated:NO completion:nil];
}

#pragma mark UIScrollViewDelegate
// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isDragging = YES;
}

// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _isDragging = NO;
    
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    MDNavigationController *navigationController = (MDNavigationController*)self.navigationController;
    float scrollY = scrollView.contentOffset.y;
    if(scrollY == 0){
        [navigationController setAlpha:0.0001];
        [navigationController setNavigationBarHidden:NO animated:NO];
    }
    NSLog(@"%f",scrollY);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float scrollY = scrollView.contentOffset.y;
    NSLog(@"%f,%hhd",scrollY,_isDragging);
    [self makeNavigationBarAlphaForScrollWithscrollY:scrollView.contentOffset.y isFirst:NO];
}


#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.001 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = _imageHeight + _proImageHeight + 45;
    if(_channelList.count > 0){
        MDHomeRenovateChannelModel *model = _channelList[indexPath.section];
        switch (model.columnType) {
            case 0:
                height = _bannerHeight + 156;
                break;
            case 2:
                height = _rmShopHeight + 30;
                break;
            default:
                break;
        }
    }
    return height;
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 1;
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _channelList.count;
    //return _mainModules.count + (_mainModules.count > 0 ? 1 : 0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *likeProductTitleCellIdentifier = @"LikeProductTitleCell";//likeProductTitle
    static NSString *likeProductCellIdentifier = @"LikeProductCell";//likeProduct
    UITableViewCell *cell = nil;
    if(indexPath.section < _channelList.count){
        MDHomeRenovateChannelModel *model = _channelList[indexPath.section];
        switch (model.columnType) {
            case 0://焦点图类型
                cell = [self bringBannerFunctionCellWithTableView:tableView];
                break;
            case 1://一个标题、一张图片、三个推荐产品
                cell = [self bringProductRMCellWithTableView:tableView];
                break;
            case 2://推荐店铺
                cell = [self bringShopRMCellWithTableView:tableView];
                break;
        }
    }else{
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < _channelList.count){
        MDHomeRenovateChannelModel *model = _channelList[indexPath.section];
        switch (model.columnType) {
            case 0://焦点图类型
                [self entrustdBannerFunctionWithCell:(MDHomeBannerFoundationTableViewCell*)cell channelModel:model];
                break;
            case 1://一个标题、一张图片、三个推荐产品
                [self entrustdProductRMCell:(MDHomeRedClassesTableViewCell*)cell channelModel:model];
                break;
            case 2://推荐店铺
                [self entrustdShopRMCell:(MDHomeRedShopTableViewCell*)cell channelModel:model];
                break;
        }
    }else{
    }
}


#pragma mark action and event methods
-(void)refreshData{
    [_dataController requestDataWithType:@"0" completion:^(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel *> *list) {
        if(state){
            _channelList = [list copy];
            [_mainTableView reloadData];
        }
        [_mainTableView.mj_header endRefreshing];
    }];
}

-(void)loadData{
    
}

-(void)functionTap:(UIControl*)control{
    
}

#pragma mark private methods
/**
 *  初始化数据
 */
-(void)initData{
    _isDragging = NO;
    _channelList = [[NSArray alloc] init];
    _type = 0; //0-超值购  1-快乐购
    _bannerHeight = SCREEN_WIDTH*300/640;
    _imageHeight = SCREEN_WIDTH*200/640;
    _proImageHeight = (SCREEN_WIDTH*260)/(214*3);
    _rmShopHeight = SCREEN_WIDTH/3;
    _pageIndex = 1;
    _pageSize = 10;
    _isLast = NO;
    _dataController = [[MDHomeDataController alloc] init];
}

-(void)initView{
    LDSearchBar *searchBar = [[LDSearchBar alloc] initWithNavigationItem:self.navigationItem];
    [searchBar setDelegate: self];
    [searchBar.leftButton setImage: [UIImage imageNamed:@"valuepurchase-logo"] forState:UIControlStateNormal];
    [searchBar.rightButton setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setShowsVerticalScrollIndicator:NO];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}


-(void)makeNavigationBarAlphaForScrollWithscrollY:(float)scrollY isFirst:(BOOL)isFirst{
    MDNavigationController *navigationController = (MDNavigationController*)self.navigationController;
    if(scrollY == 0){
        if(_isDragging || isFirst || navigationController.navigationBarHidden){
            [navigationController setAlpha:0.0001];
            [navigationController setNavigationBarHidden:NO animated:NO];
        }
    }else if(scrollY > 0 && scrollY < 94){
        [navigationController setAlpha:(scrollY * 0.01)];
        [navigationController setNavigationBarHidden:NO animated:NO];
    }else if(scrollY >= 94){
        [navigationController setAlpha:0.94];
    }else if(scrollY < 0){
        [navigationController setAlpha:0.0001];
        if(_isDragging)[navigationController setNavigationBarHidden:YES animated:NO];
    }
}


#pragma mark bring cell methods
-(UITableViewCell*)bringBannerFunctionCellWithTableView:(UITableView*)tableView{
    static NSString *bannerFunctionCellIdentifier = @"BannerFunctionCell";//banner
    MDHomeBannerFoundationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerFunctionCellIdentifier];
    if(cell == nil){
        cell = [[MDHomeBannerFoundationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerFunctionCellIdentifier bannerHeight:_bannerHeight delegate:self target:self action:@selector(functionTap:)];
    }
    return cell;
}

-(UITableViewCell*)bringProductRMCellWithTableView:(UITableView*)tableView{
    static NSString *productRMCellIdentifier = @"ProductRMCell";//productRM
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productRMCellIdentifier];
    if(cell == nil){
        cell = [[MDHomeRedClassesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productRMCellIdentifier imageHeight:_imageHeight proImageHeight:_proImageHeight target:self rmMoreAction:nil rmImageAction:nil rmProductDetailAction:nil];
    }
    return cell;
}

-(UITableViewCell*)bringShopRMCellWithTableView:(UITableView*)tableView{
    static NSString *rmShopCellIdentifier = @"RMShopCell";//likeProduct
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rmShopCellIdentifier];
    if(cell == nil){
        cell = [[MDHomeRedShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rmShopCellIdentifier delegate:self];
    }
    return cell;
}


-(void)bringLikeProductCell{
}

#pragma mark entrust value methods
-(void)entrustdBannerFunctionWithCell:(MDHomeBannerFoundationTableViewCell*)cell  channelModel:(MDHomeRenovateChannelModel*)model{
    NSMutableArray *imageURLStrings = [[NSMutableArray alloc] init];
    for (MDHomeRenovateChannelDetailModel *detailModel in model.channelColumnDetails) {
        [imageURLStrings addObject:detailModel.picAddr];
    }
    [cell.bannerView setImageURLStringsGroup:imageURLStrings];
}


-(void)entrustdProductRMCell:(MDHomeRedClassesTableViewCell*)cell  channelModel:(MDHomeRenovateChannelModel*)model{
    [cell.navTitleLabel setText:model.columnName];
    if(model.channelColumnDetails.count > 0){
        [cell.bannerButtonView sd_setImageWithURL:[NSURL URLWithString:((MDHomeRenovateChannelDetailModel *)model.channelColumnDetails[0]).picAddr] forState:UIControlStateNormal];
    }
    for(int i = 1;i< model.channelColumnDetails.count && i < cell.productsView.subviews.count + 1;i++){
        MDHomeRenovateChannelDetailModel *item = model.channelColumnDetails[i];
        UIButton *button = cell.productsView.subviews[i-1];
        if(button != nil){
            [button sd_setImageWithURL:[NSURL URLWithString:item.picAddr] forState:UIControlStateNormal];
        }
    }
}


-(void)entrustdShopRMCell:(MDHomeRedShopTableViewCell*)cell  channelModel:(MDHomeRenovateChannelModel*)model{
    NSArray * array = model.channelColumnDetails;
    NSMutableArray *imageURLArray = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (MDHomeRenovateChannelDetailModel *item in array) {
        [imageURLArray addObject:item.picAddr];
        [titleArray addObject:item.content];
    }
    [cell.titleLabel setText:model.columnName];
    [cell.imageScrollView setImageURLStringsGroup:imageURLArray];
    [cell.imageScrollView setTitlesGroup:titleArray];
}

@end
