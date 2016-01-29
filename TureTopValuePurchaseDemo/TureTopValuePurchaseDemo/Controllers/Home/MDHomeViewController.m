//
//  MDHomeViewController.m
//  TureTopValuePurchaseDemo
//  首页控制器
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeDataController.h"
#import "MDNavigationController.h"
#import "MDSearchViewController.h"

#import "MDHomeBannerFoundationTableViewCell.h"
#import "MDHomeLikeProductTableViewCell.h"
#import "MDHomeRedClassesTableViewCell.h"
#import "MDHomeRedShopTableViewCell.h"
#import "MDHomeLikeProductTipTableViewCell.h"


#import "MDLoginViewController.h"

#import "LDSearchBar.h"
#import "LDSearchPopTransition.h"

@interface MDHomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,ImageCarouselViewDelegate,LDSearchBarDelegate,UINavigationControllerDelegate>

@end

@implementation MDHomeViewController{
    
    UITableView *_mainTableView;
    MDHomeDataController *_dataController;
    NSArray<MDHomeRenovateChannelModel*> *_channelList;
    NSMutableArray<MDHomeLikeProductModel*> *_likeProductList;
    
    LDSearchPopTransition *_popAnimation;
    
    float _bannerHeight;//广告图的高度
    float _imageHeight;//推荐产品模块的广告图高度
    float _proImageHeight;//推荐产品模块的产品图高度
    float _rmShopHeight;//推荐店铺模块的店铺图高度
    
    int _pageIndex;//当前页
    int _pageSize;//每页显示条数
    int _pageTotal;//总页数
    BOOL _isLast;//你可能喜欢的模块数据最后一条
    BOOL _isDragging;//是否滑动（手指尚未离开屏幕）
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setDelegate:self];
    [self initData];
    [self initView];
    [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:YES];
    [self refreshData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:NO];
    
    //[self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if([toVC isKindOfClass:[MDHomeViewController class]]){
        [((MDNavigationController*)navigationController) setAlphaBar];
        [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:NO];
        if(operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:NSClassFromString(@"MDSearchViewController")]){
            return self.popAnimation;
        }
    }else{
        [((MDNavigationController*)navigationController) setNormalBar];
    }
    return nil;
}

#pragma mark LDSearchBarDelegate
-(void)searchBar:(LDSearchBar *)searchBar willStartEditingWithTextField:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.navigationController pushViewController:[[MDSearchViewController alloc] init] animated:NO];
    
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
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
    if(indexPath.section == _channelList.count){
        if(indexPath.row == 0){
            height = 30;
        }else{
            height = _proImageHeight + 90;
        }
    } else {
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
    if(section == _channelList.count && _channelList.count > 0){
        number = _likeProductList.count/2 + 1;
    }
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _channelList.count + (_channelList.count > 0 ? 1 : 0);
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
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:likeProductTitleCellIdentifier];
            if(cell == nil){
                cell = [[MDHomeLikeProductTipTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:likeProductTitleCellIdentifier];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:likeProductCellIdentifier];
            if(cell == nil){
                cell = [[MDHomeLikeProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:likeProductCellIdentifier target:self action:nil];
            }
        }
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
        if(indexPath.row > 0){
            MDHomeLikeProductModel *model;
            int index = ((int)indexPath.row - 1) * 2;
            for(MDLikeProductControl *view in cell.contentView.subviews){
                if(![view isKindOfClass:[UIControl class]]) continue;
                if( index < _likeProductList.count){
                    model = _likeProductList[index];
                    [view.imageView  sd_setImageWithURL:[NSURL URLWithString:[MDCommon imageURLStringForNetworkStatus:model.imageURL width:300 height:300]]];
                    [view.titleLabel setText:model.title];
                    [view.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.sellPirce]];
                }
                index ++;
            }
        }
    }
}


#pragma mark action and event methods
/*!
 *  刷新数据
 */
-(void)refreshData{
    [_dataController requestDataWithType:@"0" completion:^(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel *> *list) {
        if(state){
            _channelList = [list copy];
            [_mainTableView reloadData];
        }
        [_mainTableView.mj_header endRefreshing];
    }];
}

/*!
 *  加载你可能喜欢模块的数据
 */
-(void)loadData{
    if(_isLast) return;
    _pageIndex ++;
    [_dataController requestDataWithType:@"0" pageIndex:_pageIndex pageSize:_pageSize completion:^(BOOL state, NSString *msg, NSArray<MDHomeLikeProductModel *> *list) {
        if(state){
            [_likeProductList addObjectsFromArray: [list copy]];
            [_mainTableView reloadData];
        }else{
            _isLast = YES;
        }
        [_mainTableView.mj_footer endRefreshing];
    }];
}

/*!
 *  功能区域的点击触发事件
 *
 *  @param control 触发控件对象
 */
-(void)functionTap:(UIControl*)control{
    [self.navigationController pushViewController:[[MDLoginViewController alloc] init] animated:YES];
    
}

-(void)switchPurchaseTap{
    APPDATA.appFunctionType = @"1";
}

#pragma mark private methods
/**
 *  初始化数据
 */
-(void)initData{
    _isDragging = NO;
    _channelList = [[NSArray alloc] init];
    _likeProductList = [[NSMutableArray alloc] init];
    _bannerHeight = SCREEN_WIDTH*300/640;
    _imageHeight = SCREEN_WIDTH*200/640;
    _proImageHeight = (SCREEN_WIDTH*260)/(214*3);
    _rmShopHeight = SCREEN_WIDTH/3;
    _pageIndex = 1;
    _pageSize = 10;
    _isLast = NO;
    _dataController = [[MDHomeDataController alloc] init];
}
/*!
 *  初始化界面
 */
-(void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    LDSearchBar *searchBar = [[LDSearchBar alloc] initWithNavigationItem:self.navigationItem];
    [searchBar setDelegate: self];
    [searchBar.leftButton setImage: [UIImage imageNamed:@"valuepurchase-logo"] forState:UIControlStateNormal];
    [searchBar.leftButton addTarget:self action:@selector(switchPurchaseTap) forControlEvents:UIControlEventTouchDown];
    [searchBar.rightButton setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setShowsVerticalScrollIndicator:NO];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [_mainTableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

/*!
 *  根据滚动的Y轴的数值改变导航栏的透明度
 *
 *  @param scrollY 滚动的Y轴的数值
 *  @param isFirst 是否第一次加载控制器
 */
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
/*!
 *  在重用池中获取指定的广告功能区的UITableViewCell对象，如果该对象不存在，则创建
 *
 *  @param tableView UITableView对象
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell*)bringBannerFunctionCellWithTableView:(UITableView*)tableView{
    static NSString *bannerFunctionCellIdentifier = @"BannerFunctionCell";//banner
    MDHomeBannerFoundationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerFunctionCellIdentifier];
    if(cell == nil){
        cell = [[MDHomeBannerFoundationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerFunctionCellIdentifier bannerHeight:_bannerHeight delegate:self target:self action:@selector(functionTap:)];
    }
    return cell;
}

/*!
 *  在重用池中获取指定推荐产品的UITableViewCell对象，如果该对象不存在，则创建
 *
 *  @param tableView UITableView对象
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell*)bringProductRMCellWithTableView:(UITableView*)tableView{
    static NSString *productRMCellIdentifier = @"ProductRMCell";//productRM
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:productRMCellIdentifier];
    if(cell == nil){
        cell = [[MDHomeRedClassesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:productRMCellIdentifier imageHeight:_imageHeight proImageHeight:_proImageHeight target:self rmMoreAction:nil rmImageAction:nil rmProductDetailAction:nil];
    }
    return cell;
}

/*!
 *  在重用池中获取指定推荐店铺的UITableViewCell对象，如果该对象不存在，则创建
 *
 *  @param tableView UITableView对象
 *
 *  @return UITableViewCell对象
 */
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
/*!
 *  广告功能区的UITableViewCell对象的banner控件元素赋值
 *
 *  @param cell  UITableViewCell对象
 *  @param model MDHomeRenovateChannelModel数据模型
 */
-(void)entrustdBannerFunctionWithCell:(MDHomeBannerFoundationTableViewCell*)cell  channelModel:(MDHomeRenovateChannelModel*)model{
    NSMutableArray *imageURLStrings = [[NSMutableArray alloc] init];
    for (MDHomeRenovateChannelDetailModel *detailModel in model.channelColumnDetails) {
        [imageURLStrings addObject:[MDCommon imageURLStringForNetworkStatus:detailModel.picAddr width:SCREEN_WIDTH height:_bannerHeight]];
    }
    [cell.bannerView setImageURLStringsGroup:imageURLStrings];
}

/*!
 *  推荐产品的UITableViewCell对象的UIButton控件元素赋值
 *
 *  @param cell  UITableViewCell对象
 *  @param model MDHomeRenovateChannelModel数据模型
 */
-(void)entrustdProductRMCell:(MDHomeRedClassesTableViewCell*)cell  channelModel:(MDHomeRenovateChannelModel*)model{
    [cell.navTitleLabel setText:model.columnName];
    if(model.channelColumnDetails.count > 0){
        [cell.bannerButtonView sd_setImageWithURL:[NSURL URLWithString:[MDCommon imageURLStringForNetworkStatus:((MDHomeRenovateChannelDetailModel *)model.channelColumnDetails[0]).picAddr width:SCREEN_WIDTH height:_imageHeight]] forState:UIControlStateNormal];
    }
    for(int i = 1;i< model.channelColumnDetails.count && i < cell.productsView.subviews.count + 1;i++){
        MDHomeRenovateChannelDetailModel *item = model.channelColumnDetails[i];
        UIButton *button = cell.productsView.subviews[i-1];
        if(button != nil){
            [button sd_setImageWithURL:[NSURL URLWithString:[MDCommon imageURLStringForNetworkStatus:item.picAddr width:_proImageHeight height:_proImageHeight]] forState:UIControlStateNormal];
        }
    }
}

/*!
 *  推荐店铺的UITableViewCell对象的控件元素赋值
 *
 *  @param cell  UITableViewCell对象
 *  @param model MDHomeRenovateChannelModel数据模型
 */
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

#pragma mark getters and setters

-(LDSearchPopTransition *)popAnimation
{
    if (!_popAnimation) {
        _popAnimation = [[LDSearchPopTransition alloc] init];
    }
    return _popAnimation;
}

@end
