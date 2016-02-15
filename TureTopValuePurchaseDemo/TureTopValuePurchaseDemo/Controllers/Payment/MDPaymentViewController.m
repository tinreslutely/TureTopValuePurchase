//
//  MDPaymentViewController.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/15.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDPaymentViewController.h"
#import "MDPaymentDataController.h"
#import "CheckBoxButton.h"
#import "TPKeyboardAvoidingTableView.h"

#import "WXApi.h"

@interface MDPaymentViewController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MDPaymentViewController{
    TPKeyboardAvoidingTableView *_mainTableView;
    MDPaymentDataController *_dataController;
    BOOL _allowPay;
    BOOL _isCheckedForCardPurse;//是否选择超值购卡包支付
    BOOL _isCheckedForWalletPurse;//是否选择电子钱包支付
    MDPaymentOrderInformationModel *_mainOrderInformationModel;
}

@synthesize orderType,orderCodes;

#pragma mark life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"去首页"]){
        [self backToHome];
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 44 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 40;
    if(_mainOrderInformationModel.canUseCardPay){
        switch (indexPath.section) {
            case 0:
                if(indexPath.row == 1){
                    height = 60;
                }
                break;
            case 1:{
                if((_mainOrderInformationModel.hasEnoughCardPay && _isCheckedForCardPurse && indexPath.row == 0) || indexPath.row == 4){
                    height = 130;
                }
            }
                break;
        }
    }else{
        if(indexPath.row == 4){
            height = 130;
        }
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if((_mainOrderInformationModel.canUseCardPay && indexPath.section == 1) || (!_mainOrderInformationModel.canUseCardPay && indexPath.section == 0) ){
        float cardPayAmount = 0;
        if(_isCheckedForCardPurse && !_mainOrderInformationModel.hasEnoughCardPay){
            cardPayAmount = _mainOrderInformationModel.cardBalance;
        }
        switch (indexPath.row) {
            case 0://微信支付
            {
                [self submitPaymentOrderDataWithPayType:MDPaymentTypeWebChat cardPayAmount:cardPayAmount payPwd:nil completion:^(MDSubmitPaymentOrderModel *model) {
                    APPDATA.mergeCode = model.out_trade_no;
                    PayReq *req = [[PayReq alloc] init];
                    req.partnerId = model.partnerid;
                    req.prepayId = model.prepayid;
                    req.package = model.package;
                    req.nonceStr = model.noncestr;
                    req.timeStamp = [model.timestamp intValue];
                    req.sign = model.sign;
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ldnpackage=%@\nsign=%@\nserversign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign,model.sign );
                }];
            }
                break;
            case 1://财付通支付
            {
                [self submitPaymentOrderDataWithPayType:MDPaymentTypeTenpay cardPayAmount:cardPayAmount payPwd:nil completion:^(MDSubmitPaymentOrderModel *model) {
                    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageURL:model.payURL];
                }];
            }
                break;
            case 2:{
                if((_mainOrderInformationModel.canUseCardPay && indexPath.section == 1) || (!_mainOrderInformationModel.canUseCardPay && indexPath.section == 0)){
                    _isCheckedForWalletPurse = !_isCheckedForWalletPurse;
                    [_mainTableView reloadData];
                }
            }
                break;
        }
    }
}

#pragma mark UITableViewDataSource

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [label setText:[NSString stringWithFormat:@"付款金额：%.2f",_mainOrderInformationModel.totalPrice]];
        [label setTextColor:[UIColor redColor]];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 12, 0, 0));
        }];
        return view;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allowPay ?  (_mainOrderInformationModel.canUseCardPay ? 2 : 1) : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    if(_mainOrderInformationModel.canUseCardPay){
        switch (section) {
            case 0:
                rows = _isCheckedForCardPurse ? 2 : 1;
                break;
            case 1:
                rows = (_isCheckedForCardPurse && _mainOrderInformationModel.hasEnoughCardPay) ? 1 : (_isCheckedForWalletPurse ? (_mainOrderInformationModel.hasEnoughWalletPay ? 5 : 4) : 3);
                break;
        }
    }else{
        rows = _isCheckedForWalletPurse ? (_mainOrderInformationModel.hasEnoughWalletPay ? 5 : 4) : 3;
    }
    return rows;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(_mainOrderInformationModel.canUseCardPay){
        switch (indexPath.section) {
            case 0:{
                if(indexPath.row == 0){
                    cell = [self bringCardPurseCellWithWithTableView:tableView];
                }else if(indexPath.row == 1 && _isCheckedForCardPurse){
                    cell = [self bringCardPurseCheckedCellWithWithTableView:tableView];
                }
            }
                break;
            case 1:
                cell = [self paymentWayWithTableView:tableView indexPath:indexPath];
                break;
        }
    }else{
        cell = [self paymentWayWithTableView:tableView indexPath:indexPath];
    }
    return cell;
}


#pragma mark action event methods
-(void)refreshData{
    [_dataController requestOrderDataWithUserId:APPDATA.userId orderCodes:orderCodes orderType:[NSString stringWithFormat:@"%d",orderType] completion:^(BOOL state, NSString *msg, MDPaymentOrderInformationModel *model) {
        if(state){
            _allowPay = YES;
            _mainOrderInformationModel = model;
            _mainOrderInformationModel.hasEnoughWalletPay = (_mainOrderInformationModel.walletBalance - _mainOrderInformationModel.totalPrice > 0);
            _mainOrderInformationModel.shortCardPrice = _mainOrderInformationModel.cardBalance - _mainOrderInformationModel.totalPrice > 0 ? 0 : _mainOrderInformationModel.totalPrice - _mainOrderInformationModel.cardBalance;
            _mainOrderInformationModel.hasEnoughCardPay = (_mainOrderInformationModel.shortCardPrice == 0);
            [_mainTableView reloadData];
        }
    }];
}


-(void)checkTap:(CheckBoxButton*)button{
    [button setChecked:!button.checked];
    _isCheckedForCardPurse = button.checked;
    [_mainTableView reloadData];
}

-(void)backTap{
    NSArray *array = self.navigationController.viewControllers;
    int index = (int)array.count - 2;
    if([array[index] isKindOfClass:NSClassFromString(@"MDWebViewController")]){
        index --;
    }
    if(index >= 0){
        [self.navigationController popToViewController:array[index]  animated:YES];
    }
}

-(void)settingPasswordTap{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAlertPayPW title:@"设置密码" parameters:nil isNeedLogin:YES loginTipBlock:nil];
}

-(void)forwardPasswordTap{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAlertPayPW title:@"重新设置密码" parameters:nil isNeedLogin:YES loginTipBlock:nil];
}

-(void)submitPaymentTap:(UIButton*)button{
    float cardPayAmount = 0;
    NSString *payPwd = @"";
    UITextField *textField = (UITextField*)[[[button superview] superview] viewWithTag:1001];
    if(textField != nil) payPwd = textField.text;
    if([payPwd isEqualToString:@""]){
        [self showAlertMessage:@"请输入支付密码"];
         return;
    }
    if( _isCheckedForCardPurse){//卡包支付
        cardPayAmount = _mainOrderInformationModel.hasEnoughCardPay ? _mainOrderInformationModel.totalPrice : _mainOrderInformationModel.cardBalance;
    }
    __weak typeof(self) weakself = self;
    [self submitPaymentOrderDataWithPayType:MDPaymentTypeSystempay cardPayAmount:cardPayAmount payPwd:payPwd completion:^(MDSubmitPaymentOrderModel *model) {
        [weakself showAlertPaySucessMessage:[NSString stringWithFormat:@"支付金额：%.2f",cardPayAmount]];
    }];
}


#pragma mark private methods

-(void)submitPaymentOrderDataWithPayType:(MDPaymentType)payType cardPayAmount:(float)cardPayAmount payPwd:(NSString*)payPwd completion:(void(^)(MDSubmitPaymentOrderModel *model))completion{
    [_dataController submitPaymentOrderWithUserId:APPDATA.userId orderCodes:orderCodes orderType:orderType payType:payType cardPayAmount:[NSString stringWithFormat:@"%f",cardPayAmount] payPwd:payPwd completion:^(BOOL state, NSString *msg, MDSubmitPaymentOrderModel *model) {
        if(state){
            completion(model);
        }else{
            [self showAlertMessage:msg];
        }
    }];
}

-(void)initData{
    _allowPay = NO;
    _isCheckedForWalletPurse = NO;
    _dataController = [[MDPaymentDataController alloc] init];
}

-(void)initView{
    [self.navigationItem setTitle:@"在线支付"];
    [self.leftButton removeTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchDown];
    [self.leftButton addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [self refreshData];
}

-(UITableViewCell*)bringPaymentPasswardViewWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIView *topView = [[UIView alloc] init];
    [cell addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:@"支付密码："];
    [label setTextAlignment:NSTextAlignmentRight];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.top.equalTo(topView.mas_top).with.offset(0);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
    }];
    
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setPlaceholder:@"请输入支付密码"];
    [textField setFont:[UIFont systemFontOfSize:14]];
    [textField setSecureTextEntry:YES];
    [textField setTag:1001];
    [topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(0);
        make.left.equalTo(label.mas_right).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.bottom.equalTo(topView.mas_bottom).with.offset(0);
    }];
    
    
    UILabel *spacetorLabel = [[UILabel alloc] init];
    [spacetorLabel setBackgroundColor:UIColorFromRGBA(206, 205, 210, 1)];
    [cell addSubview:spacetorLabel];
    [spacetorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(12);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [cell addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spacetorLabel.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.height.mas_equalTo(79);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"设置密码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(settingPasswordTap) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
    }];
    
    button = [[UIButton alloc] init];
    [button setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forwardPasswordTap) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
    }];
    
    button = [[UIButton alloc] init];
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [button setBackgroundColor:[UIColor redColor]];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button.layer setCornerRadius:5];
    [button addTarget:self action:@selector(submitPaymentTap:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(8);
        make.right.equalTo(bottomView.mas_right).with.offset(-8);
    }];
    
    return cell;
}

-(UITableViewCell*)bringCardPurseCellWithWithTableView:(UITableView *)tableView{
    static NSString *titleCell = @"TitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
        
        CheckBoxButton *checkButton = [[CheckBoxButton alloc]  initWithChecked:false];
        [checkButton addTarget:self action:@selector(checkTap:) forControlEvents:UIControlEventTouchDown];
        [checkButton setRadius:10];
        [cell addSubview:checkButton];
        [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.centerY.equalTo(cell);
        }];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"超值购卡包余额   ￥%.2f",_mainOrderInformationModel.cardBalance]];
    return cell;
    
}

-(UITableViewCell*)bringCardPurseCheckedCellWithWithTableView:(UITableView *)tableView{
    static NSString *titleCheckedCell = @"TitleCheckedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCheckedCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCheckedCell];
        
        UILabel *cardPurseLabel = [[UILabel alloc] init];
        [cardPurseLabel setFont:[UIFont systemFontOfSize:14]];
        [cardPurseLabel setTag:1001];
        [cell addSubview:cardPurseLabel];
        [cardPurseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(cell.mas_left).with.offset(16);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.top.equalTo(cell.mas_top).with.offset(0);
        }];
        
        UILabel *lackLabel = [[UILabel alloc] init];
        [lackLabel setFont:[UIFont systemFontOfSize:14]];
        [lackLabel setTag:1002];
        [cell addSubview:lackLabel];
        [lackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(cell.mas_left).with.offset(16);
            make.right.equalTo(cell.mas_right).with.offset(-8);
            make.top.equalTo(cardPurseLabel.mas_bottom).with.offset(0);
        }];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [((UILabel*)[cell viewWithTag:1001]) setText:[NSString stringWithFormat:@"卡包支付：%.2f",_mainOrderInformationModel.totalPrice]];
    [((UILabel*)[cell viewWithTag:1002]) setText:[NSString stringWithFormat:@"还需支付：%.2f",_mainOrderInformationModel.shortCardPrice]];
    return cell;
    
}

-(UITableViewCell*)paymentWayWithTableView:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath{
    static NSString *iconCell = @"TitleAndIconCell";
    static NSString *paymentCell = @"PaymentPasswordCell";
    UITableViewCell *cell;
    if((_isCheckedForCardPurse && _mainOrderInformationModel.hasEnoughCardPay) || indexPath.row == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:paymentCell];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:iconCell];
    }
    if(cell == nil){
        if((_isCheckedForCardPurse && _mainOrderInformationModel.hasEnoughCardPay) || indexPath.row == 4){
            cell = [self bringPaymentPasswardViewWithIdentifier:paymentCell];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iconCell];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    if(!_isCheckedForCardPurse || !_mainOrderInformationModel.hasEnoughCardPay){
        NSString *icon = @"";
        NSString *title = @"";
        switch (indexPath.row) {
            case 0:
                icon = @"webcat";
                title = @"微信支付";
                break;
            case 1:
                icon = @"tenpay";
                title = @"财付通";
                break;
            case 2:
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                icon = @"purse";
                title = @"电子钱包";
                break;
            case 3:
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                title = [NSString stringWithFormat:@"电子钱包余额：¥%.2f%@",_mainOrderInformationModel.walletBalance,(_mainOrderInformationModel.hasEnoughWalletPay ? @"" : @"（余额不足）")];
                break;
        }
        if(![icon isEqualToString:@""])[cell.imageView setImage:[UIImage imageNamed:icon]];
        if(![title isEqualToString:@""])[cell.textLabel setText:title];
    }
    return cell;
}

-(void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showAlertMessage:(NSString*)message{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)showAlertPaySucessMessage:(NSString*)message{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        __weak typeof(MDPaymentViewController) *weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付成功" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf backToHome];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付成功" message:message delegate:self cancelButtonTitle:@"去首页" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
