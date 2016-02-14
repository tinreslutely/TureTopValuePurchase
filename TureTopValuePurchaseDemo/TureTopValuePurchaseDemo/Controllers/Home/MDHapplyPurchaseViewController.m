//
//  MDHapplyPurchaseViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/7.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHapplyPurchaseViewController.h"
#import "MDHomeDataController.h"
#import "MDNavigationController.h"
#import "ImageCarouselView.h"
#import "MDGoodsViewController.h"
#import "LDSearchBar.h"
#import "LDSearchPopTransition.h"

@interface MDHapplyPurchaseViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,ImageCarouselViewDelegate,LDSearchBarDelegate,UINavigationControllerDelegate>

@end

@implementation MDHapplyPurchaseViewController{
    UITableView *_mainTableView;
    MDHomeDataController *_dataController;
    LDSearchBar *_searchBar;
    NSMutableArray *_mainModules;
    NSMutableArray *_likeProductArray;
    LDSearchPopTransition *_popAnimation;
    
    float _bannerHeight;
    float _imageHeight;
    float _proImageHeight;
    float _rmShopHeight;
    
    int _pageIndex;
    int _pageSize;
    int _pageTotal;
    BOOL _isLast;
    BOOL _isDragging;//是否滑动（手指尚未离开屏幕）
}


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeNavigationBarAlphaForScrollWithscrollY:_mainTableView.contentOffset.y isFirst:YES];
    if(APPDATA.isLogin){
        [self makeNoReadState];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if([toVC isKindOfClass:[MDHapplyPurchaseViewController class]] || [toVC isKindOfClass:NSClassFromString(@"MDHomeViewController")]){
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
    [self.navigationController pushViewController:[[NSClassFromString(@"MDSearchViewController") alloc] init] animated:NO];
    
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


#pragma mark ImageCarouselViewDelegate
-(void)imageCarouselView:(ImageCarouselView *)imageCarouselView didSelectItemAtIndex:(NSInteger)index{
    MDHomeRenovateChannelDetailModel *model = ((MDHomeRenovateChannelModel*)_mainModules[1]).channelColumnDetails[index];
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeShopList title:model.content parameters:@{@"shopId":[NSString stringWithFormat:@"%d",model.contentId]} isNeedLogin:YES loginTipBlock:nil];
}


#pragma mark SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MDHomeRenovateChannelDetailModel *model = ((MDHomeRenovateChannelModel*)_mainModules[0]).channelColumnDetails[index];
    if([model.contentAddr extensionWithContainsString:@"http://"]){
        [self navigatePageForBannerTapWithDetailModel:model];
    }
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.navigationController pushViewController:[[NSClassFromString(@"MDSearchViewController") alloc] init] animated:YES];
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
    if(indexPath.section == _mainModules.count){
        if(indexPath.row == 0){
            height = 30;
        }else{
            height = _proImageHeight + 80;
        }
    }else{
        MDHomeRenovateChannelModel *model = _mainModules[indexPath.section];
        switch (model.columnType) {
            case 0:
                height = _bannerHeight;
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
    if(section == _mainModules.count && _mainModules.count > 0){
        number = _likeProductArray.count/2 + 1;
    }
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainModules.count + (_mainModules.count > 0 ? 1 : 0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bannerFunctionCellIdentifier = @"BannerFunctionCell";//banner
    static NSString *productRMCellIdentifier = @"ProductRMCell";//productRM
    static NSString *likeProductTitleCellIdentifier = @"LikeProductTitleCell";//likeProductTitle
    static NSString *likeProductCellIdentifier = @"LikeProductCell";//likeProduct
    static NSString *rmShopCellIdentifier = @"RMShopCell";//likeProduct
    UITableViewCell *cell = nil;
    if(indexPath.section < _mainModules.count){
        MDHomeRenovateChannelModel *model = _mainModules[indexPath.section];
        switch (model.columnType) {
            case 0://焦点图类型
            {
                cell = [tableView dequeueReusableCellWithIdentifier:bannerFunctionCellIdentifier];
                if(cell == nil){
                    cell = [self bringBannerAndIconButtonForCellWithIdentifier:bannerFunctionCellIdentifier array:model.channelColumnDetails];
                }
            }
                break;
            case 1://一个标题、一张图片、三个推荐产品
            {
                cell = [tableView dequeueReusableCellWithIdentifier:productRMCellIdentifier];
                if(cell == nil){
                    cell = [self bringProductRecommendForCellWithIdentifier:productRMCellIdentifier];
                }
                UILabel *label = [cell viewWithTag:1001];
                [label setText:model.columnName];
                if(model.channelColumnDetails.count > 0){
                    UIButton *button = [cell viewWithTag:1002];
                    [button sd_setImageWithURL:[NSURL URLWithString:((MDHomeRenovateChannelDetailModel *)model.channelColumnDetails[0]).picAddr] forState:UIControlStateNormal];
                }
                UIView *productsView = [cell viewWithTag:1003];
                for(int i = 1;i< model.channelColumnDetails.count && i < productsView.subviews.count + 1;i++){
                    MDHomeRenovateChannelDetailModel *item = model.channelColumnDetails[i];
                    UIButton *button = productsView.subviews[i-1];
                    if(button != nil){
                        [button sd_setImageWithURL:[NSURL URLWithString:item.picAddr] forState:UIControlStateNormal];
                    }
                }
            }
                break;
            case 2://推荐店铺
            {
                NSArray * array = model.channelColumnDetails;
                NSMutableArray *imageURLArray = [[NSMutableArray alloc] init];
                NSMutableArray *titleArray = [[NSMutableArray alloc] init];
                for (MDHomeRenovateChannelDetailModel *item in array) {
                    [imageURLArray addObject:item.picAddr];
                    [titleArray addObject:item.content];
                }
                cell = [tableView dequeueReusableCellWithIdentifier:rmShopCellIdentifier];
                if(cell == nil){
                    cell = [self bringRMShopCellWidthIdentifier:rmShopCellIdentifier];
                }
                UILabel *label = [cell viewWithTag:1001];
                [label setText:model.columnName];
                ImageCarouselView *view = [cell viewWithTag:1002];
                [view setImageURLStringsGroup:imageURLArray];
                [view setTitlesGroup:titleArray];
            }
                break;
        }
    }else{
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:likeProductTitleCellIdentifier];
            if(cell == nil){
                cell = [self bringLikeProductTitleCellWidthIdentifier:likeProductTitleCellIdentifier];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:likeProductCellIdentifier];
            if(cell == nil){
                cell = [self bringLikeProductCellWidthIdentifier:likeProductCellIdentifier];
            }
            MDHomeLikeProductModel *model;
            UIImageView *imageView;// = [cell viewWithTag:1001];
            UILabel *titleLabel;// = [cell viewWithTag:1002];
            UILabel *priceLabel;// = [cell viewWithTag:1003];
            int index = ((int)indexPath.row - 1) * 2;
            NSArray *array = cell.subviews;
            for(UIControl *view in array){
                if(![view isKindOfClass:[UIControl class]]) continue;
                imageView = [view viewWithTag:1001];
                titleLabel = [view viewWithTag:1002];
                priceLabel = [view viewWithTag:1003];
                if( index < _likeProductArray.count){
                    model = _likeProductArray[index];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
                    [titleLabel setText:model.title];
                    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.sellPirce]];
                }
                index ++;
            }
        }
    }
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
    }
    
    return cell;
}



#pragma mark action methods

/**
 *  刷新数据
 */
-(void) refreshData{
    [_dataController requestDataWithType:APPDATA.appFunctionType completion:^(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel *> *list) {
        if(state){
            [_mainModules removeAllObjects];
            [_mainModules addObjectsFromArray:list];
            [_mainTableView reloadData];
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
        [_mainTableView.mj_header endRefreshing];
    }];
    _isLast = NO;
    _pageIndex = 1;
}


/**
 *  加载数据
 */
-(void)loadData{
    if(_isLast) return;
    [_dataController requestDataWithType:APPDATA.appFunctionType pageIndex:_pageIndex pageSize:_pageSize completion:^(BOOL state, NSString *msg, NSArray<MDHomeLikeProductModel *> *list) {
        if(state){
            [_likeProductArray addObjectsFromArray:list];
            [_mainTableView reloadData];
            _pageIndex ++;
        }else{
            _isLast = YES;
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
        [_mainTableView.mj_footer endRefreshing];
    }];
}

-(void)makeNoReadState{
    [_dataController requestTotalDataWithUserId:APPDATA.userId completion:^(BOOL state, NSString *msg, int total) {
        if(state){
            [_searchBar.rightButton setImage:[UIImage imageNamed:(total > 0 ? @"hasmessage" : @"message")] forState:UIControlStateNormal];
        }
    }];
}

-(void)switchPurchaseTap{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *  消息 事件
 */
-(void)messageTap{
    if(!APPDATA.isLogin){
        [self.navigationController pushViewController:[[NSClassFromString(@"MDLoginViewController") alloc] init] animated:YES];
        return;
    }
    [self.navigationController pushViewController:[[NSClassFromString(@"MDMessageViewController") alloc] init] animated:YES];
}
/**
 *  推荐更多  事件
 *
 *  @param button 点击的按钮
 */
-(void)rmMoreTap:(UIButton*)button{
    UITableViewCell *cell = (UITableViewCell*)[[button superview] superview];
    if(cell == nil) return;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDHomeRenovateChannelModel *model = _mainModules[indexPath.section];
    [self navigatePageWithChannelModel:model];
}

/**
 *  推荐模块图片  事件
 *
 *  @param button 点击的按钮
 */
-(void)rmImageDetailTap:(UIButton*)button{
    UITableViewCell *cell = (UITableViewCell*)[button superview];
    if(cell == nil) return;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDHomeRenovateChannelModel *model = _mainModules[indexPath.section];
    [self navigatePageWithChannelModel:model];
}
/**
 *  推荐产品详情  事件
 *
 *  @param button 点击的按钮
 */
-(void)rmProductDetailTap:(UIButton*)button{
    UIView *view = [button superview];
    if(view == nil) return;
    UITableViewCell * cell = (UITableViewCell*)[view superview];
    if(cell == nil) return;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    int index = (int)[view.subviews indexOfObject:button];
    NSLog(@"点击产品推荐的数据位置为%ld，%d",(unsigned long)indexPath.section,index);
    MDHomeRenovateChannelDetailModel *model = ((MDHomeRenovateChannelModel*)_mainModules[indexPath.section]).channelColumnDetails[index+1];
//    MDPageCommon *common = [[MDPageCommon alloc] init];
//    UIViewController *controller = [common controllerForPagePathWithURL:model.contentAddr currentController:self token:USER_GLOBAL.token];
//    if(controller != nil){
//        [controller setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    
}

-(void)likeProductDetailTap:(UIControl*)control{
    UITableViewCell * cell = (UITableViewCell*)[control superview];
    if(cell == nil) return;
    int index = (int)[cell.subviews indexOfObject:control];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDHomeLikeProductModel *model = _likeProductArray[(indexPath.row-1)*2 + index-1];
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeProductDetail title:@"商品详情" parameters:@{@"productId":[NSString stringWithFormat:@"%d",model.productId]} isNeedLogin:NO loginTipBlock:nil];
}


#pragma mark private methods
/**
 *  初始化数据
 */
-(void)initData{
    _dataController = [[MDHomeDataController alloc] init];
    _likeProductArray = [[NSMutableArray alloc] init];
    _mainModules = [[NSMutableArray alloc] init];
    _bannerHeight = SCREEN_WIDTH*300/640;
    _imageHeight = SCREEN_WIDTH*200/640;
    _proImageHeight = SCREEN_WIDTH*260/214/3;
    _rmShopHeight = SCREEN_WIDTH/3;
    _pageIndex = 1;
    _pageSize = 10;
    _isLast = NO;
    _isDragging = NO;
}

/**
 *  初始化界面
 */
-(void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _searchBar = [[LDSearchBar alloc] initWithNavigationItem:self.navigationItem];
    [_searchBar setDelegate: self];
    [_searchBar.leftButton setImage: [UIImage imageNamed:@"happlepurchase-logo"] forState:UIControlStateNormal];
    [_searchBar.leftButton addTarget:self action:@selector(switchPurchaseTap) forControlEvents:UIControlEventTouchDown];
    [_searchBar.rightButton setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
    [_searchBar.rightButton addTarget:self action:@selector(messageTap) forControlEvents:UIControlEventTouchDown];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [_mainTableView setShowsVerticalScrollIndicator:NO];
    _mainTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark bring cell methods
/**
 *  生成一个包含导航标题和一个按钮图片轮播控件的UITableViewCell
 *  用于铭道好店模块
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell *)bringProductRecommendForCellWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //添加一个导航标题
    UIView *navView = [[UIView alloc] init];
    [cell addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"更多>" forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(rmMoreTap:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView.mas_right).with.offset(-8);
        make.centerY.equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTag:1001];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(moreButton.mas_left).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    //添加一个图片
    UIButton *imageButton = [[UIButton alloc] init];
    imageButton.tag = 1002;
    [imageButton addTarget:self action:@selector(rmImageDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview: imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_imageHeight);
        make.top.equalTo(navView.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    //添加一个推荐产品行
    UIView *productsView = [[UIView alloc] init];
    [productsView setTag:1003];
    [cell addSubview: productsView];
    [productsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageButton.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
    }];
    
    float width = SCREEN_WIDTH/3;
    float point_x = 0;
    UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    
    return cell;
}

/**
 *  生成一个包含banner控件和由五个功能按钮组成的UIView的UITableViewCell
 *
 *  @param identifier cell 的 identifier
 *  @param array      banner控件的数据模型
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell *)bringBannerAndIconButtonForCellWithIdentifier:(NSString*)identifier array:(NSArray*)array{
    //获取图片路径集合
    NSMutableArray *imageURLStrings = [[NSMutableArray alloc] init];
    for (MDHomeRenovateChannelDetailModel *model in array) {
        [imageURLStrings addObject:model.picAddr];
        NSLog(@"BANNER图片：%@",model.picAddr);
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerHeight) imageURLStringsGroup:imageURLStrings];
    cycleScrollView.infiniteLoop = YES;
    //cycleScrollView.tag = _tagForBanner;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.autoScrollTimeInterval = 4.0;
    cycleScrollView.delegate = self;
    [cell addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*300/640));
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
    }];
    
    UIView *view = [[UIView alloc] init];
    [cell addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView.mas_bottom).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    return cell;
}

/**
 *  生成一个包含标题的UITableViewCell
 *  用于显示您可能喜欢的商品模块
 *
 *  @param identifier cell 的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell*)bringLikeProductTitleCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *bglabel = [[UILabel alloc] init];
    [bglabel.layer setBorderWidth:0.5];
    [bglabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [cell addSubview:bglabel];
    [bglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [titlelabel setFont:[UIFont systemFontOfSize:14]];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    [titlelabel setText:@"您可能喜欢的商品"];
    [titlelabel setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:titlelabel];
    [cell bringSubviewToFront:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.center.equalTo(cell);
    }];
    
    return cell;
}

/**
 *  生成一个包含两个产品显示信息的UIControl的UITableViewCell
 *  你可能喜欢模块
 *
 *  @param identifier Cell的identifier
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell*)bringLikeProductCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    float width = SCREEN_WIDTH/2 - 15;
    float pointX = 10;
    [self createImageAndTwoTextForControlWithSuperView:cell pointX:pointX width:width height:width+80];
    pointX += width + 10;
    [self createImageAndTwoTextForControlWithSuperView:cell pointX:pointX width:width height:width+80];
    
    return cell;
}

/**
 *  生成一个包含一个导航标题、一个轮播控件的UITableViewCell
 *  用于铭道好店模块
 *
 *  @param identifier cell的identifier
 *
 *  @return 返回UITableViewCell对象
 */
-(UITableViewCell*)bringRMShopCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //添加一个导航标题
    UIView *navView = [[UIView alloc] init];
    [cell addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTag:1001];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(navView.mas_right).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    ImageCarouselView *cycleScrollView = [[ImageCarouselView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    [cycleScrollView setTag:1002];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.pageControlStyle = ImageCarouselViewPageContolStyleAnimated;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.delegate = self;
    [cell addSubview:cycleScrollView];
    return cell;
}

/**
 *  创建一个包含图片和一个标题，一个价格的产品信息UIControl
 *  用于可能喜欢商品模块的商品显示
 *
 *  @param superView 所属父级
 *  @param pointX    x坐标
 *  @param width     控件宽度
 *  @param height    控件高度
 */
-(void)createImageAndTwoTextForControlWithSuperView:(UIView*)superView pointX:(float)pointX width:(float)width height:(float)height{
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(pointX, 0, width, height)];
    [control addTarget:self action:@selector(likeProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setTag:1001];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control.mas_top).with.offset(15);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(width);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTag:1002];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setTag:1003];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setTextColor:[UIColor redColor]];
    [control addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    
}


#pragma mark bring control methods

/**
 *  创建一个包含一个UIImageView和一个UILabel，上下层级的UIControl
 *
 *  @param superView 所属父级
 *  @param title     显示的文本内容
 *  @param icon      图标路径
 *  @param target    目标
 *  @param action    事件
 *  @param rect      CGRect属性
 *  @param iconSize  图标大小
 */
-(void)createIconAndTitleForControlWithSuperView:(UIView*)superView title:(NSString*)title icon:(NSString*)icon target:(_Nullable id)target action:(SEL)action rect:(CGRect)rect iconSize:(float)iconSize {
    UIControl *control = [[UIControl alloc] initWithFrame:rect];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    //添加一个imageview
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:icon]];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        make.top.equalTo(control.mas_top).with.offset(0);
        make.centerX.equalTo(control);
    }];
    //添加一个文本label
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.top.equalTo(imageView.mas_bottom).with.offset(5);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
    }];
}

/**
 *  一般用于跳转产品列表，或者是web界面
 *
 *  @param model MDHomeRenovateChannelModel模型数据
 */
-(void)navigatePageWithChannelModel:(MDHomeRenovateChannelModel *)model{
    if([model.columnLink extensionWithContainsString:PAGECONFIG.productsPageURLString]){
        NSDictionary *dic = [MDCommon urlParameterConvertDictionaryWithURL:model.columnLink];
        MDGoodsViewController *productsController = [[MDGoodsViewController alloc] init];
        productsController.hidesBottomBarWhenPushed = YES;
        if(dic != nil){
            productsController.keyword = [dic objectForKey:@"keywords"];
            if([dic objectForKey:@"typeId"] != nil){
                productsController.categoryId = [[dic objectForKey:@"typeId"] intValue];
            }
            if([dic objectForKey:@"type"] != nil){
                
            }
        }
        [self.navigationController pushViewController:productsController animated:YES];
    }else{
//        MDPageCommon *common = [[MDPageCommon alloc] init];
//        UIViewController *controller = [common controllerForPagePathWithURL:model.columnLink currentController:self token:USER_GLOBAL.token];
//        [controller setHidesBottomBarWhenPushed:YES];
//        if(controller != nil){
//            [self.navigationController pushViewController:controller animated:YES];
//        }
    }
}
/**
 *  banner图点击跳转
 *
 *  @param model banner图数据模型
 */
-(void)navigatePageForBannerTapWithDetailModel:(MDHomeRenovateChannelDetailModel *)model{
//    MDPageCommon *common = [[MDPageCommon alloc] init];
//    UIViewController *controller = [common controllerForPagePathWithURL:model.contentAddr currentController:self token:USER_GLOBAL.token];
//    [controller setHidesBottomBarWhenPushed:YES];
//    if(controller != nil){
//        [self.navigationController pushViewController:controller animated:YES];
//    }
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

#pragma mark getters and setters

-(LDSearchPopTransition *)popAnimation
{
    if (!_popAnimation) {
        _popAnimation = [[LDSearchPopTransition alloc] init];
    }
    return _popAnimation;
}
@end

