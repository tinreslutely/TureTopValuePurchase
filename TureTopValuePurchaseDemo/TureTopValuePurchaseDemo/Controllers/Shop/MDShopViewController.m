//
//  MDShopViewController.m
//  TureTopValuePurchaseDemo
//  店铺首页控制器
//  Created by 李晓毅 on 16/1/23.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopViewController.h"
#import "MDShopDataController.h"
#import "UIImage+ImageEffects.h"

@interface MDShopViewController ()

@end

@implementation MDShopViewController{
    UIControl *_mainFirstItemTapView;
    UIControl *_mainSecondItemTapView;
    UIScrollView *_mainFirstItemGroupView;
    UIScrollView *_mainSecondItemGroupView;
    UIImageView *_logoImageView;
    UILabel *_nameLabel;
    float _headHeight;//顶部的view的高度
    
    MDShopModel *_mainShopModel;
    MDShopDataController *_dataController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action and event methods
-(void)itemGroupTap:(UIControl*)control{
    UILabel *lastSpaceLabel;
    UILabel *curSpaceLabel = [control viewWithTag:1001];
    [curSpaceLabel setHidden:NO];
    [control setBackgroundColor:[UIColor whiteColor]];
    if(control == _mainFirstItemTapView){
        [_mainFirstItemGroupView setHidden:NO];
        [_mainSecondItemGroupView setHidden:YES];
        [_mainSecondItemTapView setBackgroundColor:UIColorFromRGB(222, 222, 222)];
        lastSpaceLabel = [_mainSecondItemTapView viewWithTag:1001];
        [lastSpaceLabel setHidden:YES];
    }else if(control == _mainSecondItemTapView){
        [_mainFirstItemGroupView setHidden:YES];
        [_mainSecondItemGroupView setHidden:NO];
        [_mainFirstItemTapView setBackgroundColor:UIColorFromRGB(222, 222, 222)];
        lastSpaceLabel = [_mainFirstItemTapView viewWithTag:1001];
        [lastSpaceLabel setHidden:YES];
    }
}
/*!
 *  功能按钮触发事件
 *
 *  @param control 触发的对象
 */
-(void)functionItemTap:(UIControl*)control{
    if(![self validLogined]) return;
    if(!_mainShopModel.hasShop){
        [self.view makeToast:@"尚未开通店铺" duration:1 position:CSToastPositionBottom];
        return;
    }
    UILabel *label = [control viewWithTag:1001];
    int purchaseType = -1;
    NSString *title = label.text;
    NSDictionary *dic;
    if([label.text isEqualToString:@"面对面收款"]){
        dic = @{@"id":[NSString stringWithFormat:@"%d",_mainShopModel.shopId]};
        purchaseType = MDWebPageURLTypeFaceDetail;
    }else if([label.text isEqualToString:@"店铺编辑"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"MDShopManageViewController") alloc] init] animated:YES];
        return;
    }else if([label.text isEqualToString:@"面对面订单"]){
        purchaseType = MDWebPageURLTypeFaceOrder;
    }else if([label.text isEqualToString:@"店铺证照"]){
        purchaseType = MDWebPageURLTypeFaceShopPermit;
    }else if([label.text isEqualToString:@"进入店铺"]){
        purchaseType = MDWebPageURLTypeShopList;
    }else if([label.text isEqualToString:@"商品管理"]){
        purchaseType = MDWebPageURLTypeProdManage;
    }else if([label.text isEqualToString:@"发布商品"]){
        purchaseType = MDWebPageURLTypePublishProduct;
    }else if([label.text isEqualToString:@"店铺订单"]){
        purchaseType = MDWebPageURLTypeFaceOrder;
    }else if([label.text isEqualToString:@"店铺管理"]){
        [self.navigationController pushViewController:[[NSClassFromString(@"MDShopManageViewController") alloc] init] animated:YES];
        return;
    }else if([label.text isEqualToString:@"商机卡"]){
        purchaseType = MDWebPageURLTypeBusinessCardNavg;
    }else if([label.text isEqualToString:@"我的账户"]){
        purchaseType = MDWebPageURLTypeWallet;
    }
    if(purchaseType == -1 || ![self validLogined]) return;
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:purchaseType title:title parameters:dic isNeedLogin:YES loginTipBlock:nil];
}

-(void)refreshData{
    if(!APPDATA.isLogin) return;
    [self.progressView show];
    [_dataController requestDataWithUserId:APPDATA.userId completion:^(BOOL state, NSString *msg, MDShopModel *model) {
        if(state){
            _mainShopModel = model;
            if(model.hasShop){
                [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_mainShopModel.shopLogo] placeholderImage:[UIImage imageNamed:@"shop_logo_d"]];
                [_nameLabel setText:_mainShopModel.shopName];
            }else{
                [_nameLabel setText:@"您尚未开通店铺"];
            }
        }else{
            [self showAlertDialog:msg];
        }
        [self.progressView hide];
    }];
}

#pragma mark private methods
/*!
 *  初始化数据
 */
-(void)initData{
    _headHeight = SCREEN_WIDTH*220/625;
    _dataController = [[MDShopDataController alloc] init];
}

/*!
 *  初始化界面
 */
-(void)initView{
    [self.navigationItem setTitle:@"店铺"];
    [self.leftButton setHidden:YES];
    //头部
    UIView *headView = [[UIView alloc] init];
    [headView.layer setContents:(id)[[UIImage imageNamed:@"shop_bg"] applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil].CGImage];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_headHeight);
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    float height = _headHeight / 2;
    UIView *logoView = [[UIView alloc] init];
    [headView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(height, height));
        make.left.equalTo(headView.mas_left).with.offset(40);
        make.centerY.equalTo(headView);
    }];
    [logoView.layer addSublayer:[self setImageViewShadowLayerWithSize:CGSizeMake(height, height)]];
    
    _logoImageView = [[UIImageView alloc] init];
    [_logoImageView setImage:[UIImage imageNamed:@"shop_logo_d"]];
        [_logoImageView setClipsToBounds:YES];
    [_logoImageView.layer setBorderWidth:2];
    [_logoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_logoImageView.layer setCornerRadius:height/2];
    [_logoImageView.layer setMasksToBounds:YES];
    [logoView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(logoView).with.insets(UIEdgeInsetsZero);
    }];
    
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setText:@"您尚未登录"];
    [_nameLabel setTextColor:[UIColor grayColor]];
    [headView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.centerY.equalTo(headView);
        make.left.equalTo(logoView.mas_right).with.offset(10);
        
    }];
    
    //中部
    UIView *centerView = [[UIView alloc] init];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_headHeight-20);
        make.top.equalTo(headView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    float controlWidth = SCREEN_WIDTH/2;
    _mainFirstItemTapView = [self bringTabItemWithImageName:@"store_item1" title:@"面对面商家店铺" imageheight:_headHeight - 51];
    [_mainFirstItemTapView addTarget:self action:@selector(itemGroupTap:) forControlEvents:UIControlEventTouchDown];
    [centerView addSubview:_mainFirstItemTapView];
    [_mainFirstItemTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(controlWidth);
        make.left.equalTo(centerView.mas_left).with.offset(0);
        make.top.equalTo(centerView.mas_top).with.offset(0);
        make.bottom.equalTo(centerView.mas_bottom).with.offset(0);
    }];
    
    _mainSecondItemTapView = [self bringTabItemWithImageName:@"store_item2" title:@"线上商家店铺" imageheight:_headHeight - 51];
    [_mainSecondItemTapView addTarget:self action:@selector(itemGroupTap:) forControlEvents:UIControlEventTouchDown];
    [centerView addSubview:_mainSecondItemTapView];
    [_mainSecondItemTapView setBackgroundColor:UIColorFromRGB(222, 222, 222)];
    [_mainSecondItemTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(controlWidth);
        make.right.equalTo(centerView.mas_right).with.offset(0);
        make.top.equalTo(centerView.mas_top).with.offset(0);
        make.bottom.equalTo(centerView.mas_bottom).with.offset(0);
    }];
    [[_mainSecondItemTapView viewWithTag:1001] setHidden:YES];
    
    
    //底部
    NSArray *array = @[@"item1_1",@"item1_2",@"item1_3",@"item1_4"];
    NSArray *titleArray = @[@"面对面收款",@"店铺编辑",@"面对面订单",@"店铺证照"];
    _mainFirstItemGroupView = [self bringFunctionItemsForTapWithImageArray:array titleArray:titleArray];
    [_mainFirstItemGroupView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_mainFirstItemGroupView];
    [_mainFirstItemGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    array = @[@"item2_1",@"item2_2",@"item2_3",@"item2_4",@"item2_5",@"item2_6",@"item2_7"];
    titleArray = @[@"进入店铺",@"商品管理",@"发布商品",@"店铺订单",@"店铺管理",@"商机卡",@"我的账户"];
    _mainSecondItemGroupView = [self bringFunctionItemsForTapWithImageArray:array titleArray:titleArray];
    [_mainSecondItemGroupView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_mainSecondItemGroupView];
    [_mainSecondItemGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [_mainSecondItemGroupView setHidden:YES];
    
}

/*!
 *  根据imageArray图标组和titleArray标题组创建功能区
 *
 *  @param imageArray 图标数组
 *  @param titleArray 标题数组
 *
 *  @return UIScrollView对象
 */
-(UIScrollView *)bringFunctionItemsForTapWithImageArray:(NSArray*)imageArray titleArray:(NSArray*)titleArray{
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] init];
    
    UIView *bottomContentView = [[UIView alloc] init];
    [bottomScrollView addSubview: bottomContentView];
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomScrollView).insets(UIEdgeInsetsZero);
        make.width.equalTo(bottomScrollView.mas_width);
    }];
    
    float pointX = 0,ponintY = 0,functionWidth = SCREEN_WIDTH/3,imageHeight = (functionWidth/3)*2;
    UIControl *control;
    for(int i = 0; i<imageArray.count; i++){
        control = [self bringFunctionItemWithImageName:[imageArray objectAtIndex:i] title:[titleArray objectAtIndex:i] sizeWidth:functionWidth];
        [control addTarget:self action:@selector(functionItemTap:) forControlEvents:UIControlEventTouchDown];
        [bottomContentView addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(functionWidth, imageHeight));
            make.left.equalTo(bottomContentView.mas_left).with.offset(pointX);
            make.top.equalTo(bottomContentView.mas_top).with.offset(ponintY);
        }];
        if((i + 1) % 3 == 0){
            pointX = 0;
            ponintY += imageHeight;
        }else{
            pointX += functionWidth;
        }
    }
    [bottomContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(control.mas_bottom).with.offset(0);
    }];
    return bottomScrollView;
}

/*!
 *  创建功能区item按钮对象，显示一个UIImageView 和一个UILabel
 *
 *  @param imageName 图标资源名
 *  @param title     文本显示内容
 *  @param sizeWidth UIImageView显示的宽度
 *
 *  @return UIControl对象
 */
-(UIControl*)bringFunctionItemWithImageName:(NSString*)imageName title:(NSString*)title sizeWidth:(float)sizeWidth{
    
    UIControl *control = [[UIControl alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control.mas_top).with.offset(10);
        make.centerX.equalTo(control.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sizeWidth/3, sizeWidth/3));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTag:1001];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
    }];
    
    return control;
}

/*!
 *  创建一个tab item的内容，显示一个UIImageView图标显示 和一个UILabel文本显示、一个UILabel选中红线显示
 *
 *  @param imageName   图标资源名
 *  @param title       文本显示内容
 *  @param imageheight UIImageView的高度
 *
 *  @return UIControl对象
 */
-(UIControl*)bringTabItemWithImageName:(NSString*)imageName title:(NSString*)title imageheight:(float)imageheight{
    UIControl *control = [[UIControl alloc] init];
    
    UILabel *spaceBottonLabel = [[UILabel alloc] init];
    [spaceBottonLabel setBackgroundColor:[UIColor redColor]];
    [spaceBottonLabel setTag:1001];
    [control addSubview:spaceBottonLabel];
    [spaceBottonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(control.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(20);
        make.right.equalTo(control.mas_right).with.offset(-20);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.bottom.equalTo(spaceBottonLabel.mas_top).with.offset(-5);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control.mas_top).with.offset(0);
        make.centerX.equalTo(control.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(imageheight, imageheight));
    }];
    return control;
}

/*!
 *  设置阴影
 *
 *  @param size 控件尺寸
 *
 *  @return CALayer
 */
-(CALayer*)setImageViewShadowLayerWithSize:(CGSize)size{
    CALayer *layer = [CALayer layer];
    [layer setFrame: CGRectMake(0, 0, size.width, size.height)];
    [layer setCornerRadius:size.width/2];
    [layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [layer setShadowColor:[UIColor grayColor].CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.8];
    return layer;
}

@end
