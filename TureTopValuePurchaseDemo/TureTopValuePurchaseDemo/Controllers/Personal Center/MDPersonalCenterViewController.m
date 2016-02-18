//
//  MDPersonalCenterViewController.m
//  TureTopValuePurchaseDemo
//  个人中心（我的）控制器
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPersonalCenterViewController.h"
#import "MDPersonCenterDataController.h"

#import "MDPersonCenterNormalTableViewCell.h"
#import "MDPersonCenterInformationTableViewCell.h"
#import "MDPersonCenterOrderTableViewCell.h"
#import "MDPersonCenterAccountTableViewCell.h"

#import "MDTabBarController.h"

@interface MDPersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MDPersonalCenterViewController{
    MDPersonCenterDataController *_dataController;
    UITableView *_mainTableView;
    MDPersonCenterModel *_mainPersonCenterModel;
    
    float _headInformationHeight;//会员信息高度，顶部
    float _rowItemGroupHeight;//订单或金额信息高度
    NSArray *_comositionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(APPDATA.isLogin){
        [self refreshData];
    }else{
        [_mainTableView reloadData];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rowNumber = 1;
    switch (section) {
        case 0:
            rowNumber = 3;
            break;
        case 1:
            rowNumber = 2;
            break;
        case 4:
            rowNumber = APPDATA.isLogin ? 2 : 1;
            break;
        case 5:
            rowNumber = 3;
            break;
    }
    return rowNumber;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == 0 && indexPath.row == 0){
        static NSString *headCellIdentifier = @"HeadCell";
        cell = [tableView dequeueReusableCellWithIdentifier:headCellIdentifier];
        if(cell == nil){
            cell = [[MDPersonCenterInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headCellIdentifier];
            [((MDPersonCenterInformationTableViewCell*)cell).roleButton addTarget:self action:@selector(roleTap) forControlEvents:UIControlEventTouchDown];
            [((MDPersonCenterInformationTableViewCell*)cell).nameButton addTarget:self action:@selector(userTap) forControlEvents:UIControlEventTouchDown];
            [((MDPersonCenterInformationTableViewCell*)cell).detailButton addTarget:self action:@selector(userTap) forControlEvents:UIControlEventTouchDown];
            [((MDPersonCenterInformationTableViewCell*)cell).consigneeProductControl addTarget:self action:@selector(collectProductTap:) forControlEvents:UIControlEventTouchDown];
            [((MDPersonCenterInformationTableViewCell*)cell).consigneeShopControl addTarget:self action:@selector(collectShopTap:) forControlEvents:UIControlEventTouchDown];
        }
    }else if(indexPath.section == 0 && indexPath.row == 2){
        static NSString *orderCellIdentifier = @"OrderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
        if(cell == nil){
            cell = [[MDPersonCenterOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
            for (UIControl *control in cell.contentView.subviews) {
                if([control isKindOfClass:[UIControl class]]){
                    [control addTarget:self action:@selector(orderStatusTap:) forControlEvents:UIControlEventTouchDown];
                }
            }
        }
    }else if(indexPath.section == 1 && indexPath.row == 1){
        static NSString *accountCellIdentifier = @"AccountCell";
        cell = [tableView dequeueReusableCellWithIdentifier:accountCellIdentifier];
        if(cell == nil){
            cell = [[MDPersonCenterAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accountCellIdentifier];
        }
    }else{
        static NSString *normalCellIdentifier = @"NormalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        if(cell == nil){
            cell = [[MDPersonCenterNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.0001 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 40;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            height = _headInformationHeight;
        }else if(indexPath.row == 2){
            height = _rowItemGroupHeight;
        }
    }else if(indexPath.section == 1 && indexPath.row == 1){
        height = _rowItemGroupHeight;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        MDPersonCenterInformationTableViewCell *headCell = (MDPersonCenterInformationTableViewCell*)cell;
        if(APPDATA.isLogin){
            [headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:_mainPersonCenterModel.headPortrait] placeholderImage:[UIImage imageNamed:@"activity_main_mylinli_bannerhead"]];
            [headCell.nameButton setTitle:_mainPersonCenterModel.nickName forState:UIControlStateNormal];
            [headCell.roleButton setTitle:_mainPersonCenterModel.userRoles forState:UIControlStateNormal];
            [headCell.roleImageView setHidden:NO];
            [headCell.consigneeProductLabel setText:[NSString stringWithFormat:@"%ld",_mainPersonCenterModel.productCollectionCount]];
            [headCell.consigneeShopLabel setText:[NSString stringWithFormat:@"%ld",_mainPersonCenterModel.shopCollectionCount]];
        }else{
            [headCell.headImageView setImage:[UIImage imageNamed:@"activity_main_mylinli_bannerhead"]];
            [headCell.nameButton setTitle:@"您尚未登录超值购，请" forState:UIControlStateNormal];
            [headCell.roleButton setTitle:@"[登录/注册]" forState:UIControlStateNormal];
            [headCell.roleImageView setHidden:YES];
            [headCell.consigneeProductLabel setText:@"0"];
            [headCell.consigneeShopLabel setText:@"0"];
        }
    }else if(indexPath.section == 0 && indexPath.row == 2){//订单状态快捷按钮
        MDPersonCenterOrderTableViewCell *orderCell = (MDPersonCenterOrderTableViewCell*)cell;
        [orderCell.noPaidBadge setText:[NSString stringWithFormat:@"%ld",APPDATA.isLogin ? _mainPersonCenterModel.orderUnpaid : 0]];
        [orderCell.noDispatchBadge setText:[NSString stringWithFormat:@"%ld",APPDATA.isLogin ? _mainPersonCenterModel.orderPaid: 0]];
        [orderCell.noConsigneeBadge setText:[NSString stringWithFormat:@"%ld",APPDATA.isLogin ? _mainPersonCenterModel.orderDelivered: 0]];
        [orderCell.noEvalBadge setText:[NSString stringWithFormat:@"%ld",APPDATA.isLogin ? _mainPersonCenterModel.notComment: 0]];
        
    }else if(indexPath.section == 1 && indexPath.row == 1){//账户余额
        MDPersonCenterAccountTableViewCell *accountCell = (MDPersonCenterAccountTableViewCell*)cell;
        [accountCell.freezeMoneyLabel setText:[NSString stringWithFormat:@"%.2f",APPDATA.isLogin ? _mainPersonCenterModel.balance : 0.0f]];
        [accountCell.noneFreezeMoneyLabel setText:[NSString stringWithFormat:@"%.2f",APPDATA.isLogin ? _mainPersonCenterModel.frozeAmount : 0.0f]];
    }else{
        MDPersonCenterNormalTableViewCell *normalCell = (MDPersonCenterNormalTableViewCell*)cell;
        NSDictionary *dic;
        switch (indexPath.section) {
            case 4:
                dic = APPDATA.isLogin ? _comositionArray[indexPath.section + indexPath.row] : _comositionArray[indexPath.section + 1];
                break;
            case 5:
                dic = _comositionArray[indexPath.section + indexPath.row + 1];
                break;
            case 6:
                dic = _comositionArray[_comositionArray.count - 1];
                break;
            default:
                dic = _comositionArray[indexPath.section];
                break;
        }
        if(dic){
            [normalCell.iconImageView setImage:[UIImage imageNamed:[dic objectForKey:@"image"]]];
            [normalCell.titleLabel setText:[dic objectForKey:@"title"]];
        }
        switch (indexPath.section) {
            case 2:
                [normalCell.subLabel setText:[NSString stringWithFormat:@"%.2f",(APPDATA.isLogin ? _mainPersonCenterModel.cardBalance : 0)]];
                break;
            case 3:
                [normalCell.subLabel setText:[NSString stringWithFormat:@"%.2f",(APPDATA.isLogin ? _mainPersonCenterModel.pointBalance : 0)]];
                break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDPersonCenterNormalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(![cell isKindOfClass:[MDPersonCenterNormalTableViewCell class]]){
        return;
    }
    int purchaseType = -1;
    NSString *title = cell.titleLabel.text;
    if([cell.titleLabel.text isEqualToString:@"我的订单"]){
        [self rotorOrderWithType:nil];
        return;
    }else if([cell.titleLabel.text isEqualToString:@"我的钱包"]){
        purchaseType = MDWebPageURLTypeWallet;
    }else if([cell.titleLabel.text isEqualToString:@"我的卡包"]){
        purchaseType = MDWebPageURLTypeCardBalance;
    }else if([cell.titleLabel.text isEqualToString:@"我的积分"]){
        purchaseType = MDWebPageURLTypePoint;
    }else if([cell.titleLabel.text isEqualToString:@"面对面支付"]){
        purchaseType = MDWebPageURLTypeFaceOrder;
    }else if([cell.titleLabel.text isEqualToString:@"我的商机卡"]){
        purchaseType = MDWebPageURLTypeBusinessCardNavg;
    }else if([cell.titleLabel.text isEqualToString:@"商家中心"]){
        if(![self validLogined]){
            return;
        }
        [self.tabBarController setSelectedIndex:tab_shop_index];
        return;
    }else if([cell.titleLabel.text isEqualToString:@"我的人脉"]){
        purchaseType = MDWebPageURLTypeContacts;
    }else if([cell.titleLabel.text isEqualToString:@"我的消息"]){
        if(![self validLogined]){
            return;
        }
        [self.navigationController pushViewController:[[NSClassFromString(@"MDMessageController") alloc] init] animated:YES];
        return;
    }else if([cell.titleLabel.text isEqualToString:@"设置"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"MDSettingsViewController") alloc] init] animated:YES];
        return;
    }
    if(purchaseType == -1 || ![self validLogined]) return;
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:purchaseType title:title parameters:nil isNeedLogin:YES loginTipBlock:nil];
}

#pragma mark action and event methods
-(void)refreshData{
    if(![self validLogined]){
        [_mainTableView.mj_header endRefreshing];
        return;
    }
    [self.progressView show];
    [_dataController requestDataWithUserId:APPDATA.userId token:APPDATA.token completion:^(BOOL state, NSString *msg, MDPersonCenterModel *model) {
        if(state){
            _mainPersonCenterModel = model;
            [_mainTableView reloadData];
        }else{
            [self.view makeToast:@"网络正在开小差，请耐心等候~~" duration:1 position:CSToastPositionBottom];
        }
        [self.progressView hide];
        [_mainTableView.mj_header endRefreshing];
    }];
}

/*!
 *  用户角色事件
 */
-(void)roleTap{
    if(!APPDATA.isLogin){
        [self.navigationController pushViewController:[[NSClassFromString(@"MDLoginViewController") alloc] init] animated:YES];
        return;
    }
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeOpenCertificate title:@"开通资格" parameters:nil isNeedLogin:YES loginTipBlock:nil];
}
/*!
 *  用户信息事件
 */
-(void)userTap{
    if(![self validLogined]){
        return;
    }
    [self.navigationController pushViewController:[[NSClassFromString(@"MDMemberInformationViewController") alloc] init] animated:YES];
}
/*!
 *  订单状态查询订单列表事件
 */
-(void)orderStatusTap:(UIControl*)control{
    UIView *view = [control superview];
    int index = (int)[view.subviews indexOfObject:control];
    if(view && index >= 0){
        [self rotorOrderWithType:[NSString stringWithFormat:@"%d",index + 1]];
    }
}
/*!
 *  收藏商品点击触发事件
 *
 *  @param control 触发对象
 */
-(void)collectProductTap:(UIControl*)control{
    if(![self validLogined]){
        return;
    }
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeCollection title:@"我的收藏" parameters:@{@"tab":@"0"} isNeedLogin:YES loginTipBlock:nil];
}

/*!
 *  收藏店铺点击触发事件
 *
 *  @param control 触发对象
 */
-(void)collectShopTap:(UIControl*)control{
    if(![self validLogined]){
        return;
    }
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeCollection title:@"我的收藏" parameters:@{@"tab":@"1"} isNeedLogin:YES loginTipBlock:nil];
}

#pragma mark private methods
/*!
 *  初始化数据
 */
-(void)initData{
    _mainPersonCenterModel = [[MDPersonCenterModel alloc] init];
    _dataController = [[MDPersonCenterDataController alloc] init];
    _headInformationHeight = SCREEN_WIDTH * 370 / 640;
    _rowItemGroupHeight = 60;
    
    _comositionArray = @[
                             @{@"title":@"我的订单",@"image":@"center_1"},
                             @{@"title":@"我的钱包",@"image":@"center_2"},
                             @{@"title":@"我的卡包",@"image":@"center_3"},
                             @{@"title":@"我的积分",@"image":@"center_11"},
                             @{@"title":@"面对面支付",@"image":@"center_4"},
                             @{@"title":@"我的商机卡",@"image":@"center_5"},
                             @{@"title":@"商家中心",@"image":@"center_6"},
                             @{@"title":@"我的人脉",@"image":@"center_7"},
                             @{@"title":@"我的消息",@"image":@"center_8"},
                             @{@"title":@"设置",@"image":@"center_10"}
                         ];
}

/*!
 *  初始化界面
 */
-(void)initView{
    [self.navigationItem setTitle:@"会员中心"];
    [self.leftButton setHidden:YES];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

/*!
 *  跳转订单界面
 *
 *  @param type 订单状态类型  1-未付款  2-未发货  3-未收货  4-未评价
 */
-(void)rotorOrderWithType:(NSString*)type{
    NSDictionary *dic = type ? @{@"type":type} : nil;
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeOrderList title:@"我的订单" parameters:dic isNeedLogin:YES loginTipBlock:nil];
}


@end
