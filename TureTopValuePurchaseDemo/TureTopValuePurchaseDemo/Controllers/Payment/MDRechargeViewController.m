//
//  MDRechargeViewController.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/28.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDRechargeViewController.h"
#import "MDPaymentModel.h"
#import "CheckBoxButton.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MDPaymentDataController.h"

#import "WXApi.h"
@interface MDRechargeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation MDRechargeViewController{
    MDPaymentDataController *_dataController;
    TPKeyboardAvoidingTableView *_mainTableView;
    UITextField *_mainTextField;
    
    BOOL _isCheckedForWalletPurse;//是否选择电子钱包支付
    float _cardBalance;//卡包余额
    float _walletBalance;//钱包余额
    NSString *_phone;
}

@synthesize rechargeType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return section == 1 ? 34 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 ? 20 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 40;
    if(indexPath.row == 4){
        height = 130;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                [self submitPaymentOrderDataWithPayType:MDPaymentTypeWebChat payPwd:nil completion:^(MDSubmitPaymentOrderModel *model) {
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
            case 1:{
                [self submitPaymentOrderDataWithPayType:MDPaymentTypeTenpay payPwd:nil completion:^(MDSubmitPaymentOrderModel *model) {
                    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageURL:model.payURL];
                }];
            }
                break;
            case 2:
                _isCheckedForWalletPurse = !_isCheckedForWalletPurse;
                [_mainTableView reloadData];
                break;
        }
    }
}

#pragma mark UITableViewDataSource

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setText:@"选择支付方式"];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 || (section == 1 && rechargeType == 2) ? 2 : (_isCheckedForWalletPurse ? 5 : 3);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            static NSString *balanceCellIdentifier = @"BalanceCell";
            static NSString *rechargeCellIdentifier = @"ReChargeBalanceCell";
            if(indexPath.row == 0){
                cell = [tableView dequeueReusableCellWithIdentifier:balanceCellIdentifier];
                if(cell == nil){
                    cell = [self bringBalanceViewWithIdentifier:balanceCellIdentifier];
                }
                UILabel *label = [cell viewWithTag:1001];
                [label setText:[NSString stringWithFormat:@"%.2f",(rechargeType == 1 ? _cardBalance : _walletBalance)]];
            }else if(indexPath.row == 1){
                cell = [tableView dequeueReusableCellWithIdentifier:rechargeCellIdentifier];
                if(cell == nil){
                    cell = [self bringRechargeBalanceViewWithIdentifier:rechargeCellIdentifier];
                }
            }
        }
            break;
        case 1:
            cell = [self paymentWayWithTableView:tableView indexPath:indexPath];
            break;
    }
    return cell;
}


#pragma mark action event methods
-(void)refreshData{
    [_dataController requestWalletCardBalanceDataWithUserId:APPDATA.userId type:MDBalanceTypeCard completion:^(BOOL state, NSString * _Nullable msg, MDPaymentModel * _Nullable model) {
        if(state){
            if(rechargeType == MDRechargeTypeCard){
                _cardBalance = model.balance;
                [_dataController requestWalletCardBalanceDataWithUserId:APPDATA.userId type:MDBalanceTypeWallet completion:^(BOOL state, NSString * _Nullable msg, MDPaymentModel * _Nullable model) {
                    if(state){
                        _walletBalance = model.balance;
                    }
                }];
            }else{
                _walletBalance = model.balance;
            }
            _phone = model.phone;
            [_mainTableView reloadData];
        }
    }];
}

-(void)settingPasswordTap{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAlertPayPW title:@"设置密码" parameters:nil isNeedLogin:YES loginTipBlock:nil];
}

-(void)forwardPasswordTap{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAlertPayPW title:@"重新设置密码" parameters:nil isNeedLogin:YES loginTipBlock:nil];
}

-(void)submitPaymentTap:(UIButton*)button{
    NSString *payPwd = @"";
    UITextField *textField = (UITextField*)[[[button superview] superview] viewWithTag:1001];
    if(textField != nil) payPwd = textField.text;
    if([payPwd isEqualToString:@""]){
        [self showAlertMessage:@"请输入支付密码"];
        return;
    }
    __weak typeof(MDRechargeViewController) *weakself = self;
    [self submitPaymentOrderDataWithPayType:MDPaymentTypeSystempay payPwd:payPwd completion:^(MDSubmitPaymentOrderModel *model) {
        APPDATA.mergeCode = model.mergeCode;
        [weakself showAlertPaySucessMessage:[NSString stringWithFormat:@"支付金额：%@",_mainTextField.text]];
    }];
}

#pragma mark private methods

-(void)submitPaymentOrderDataWithPayType:(MDPaymentType)payType payPwd:(NSString*)payPwd completion:(void(^)(MDSubmitPaymentOrderModel *model))completion{
    float payAmount = [_mainTextField.text floatValue];
    if(payAmount == 0){
        [self showAlertMessage:@"请输入充值的金额"];
        return;
    }
    [_dataController submitCardRechargeWithRechargeType:rechargeType userId:APPDATA.userId payType:payType payAmount:payAmount payPwd:payPwd completion:^(BOOL state, NSString * _Nullable msg, MDSubmitPaymentOrderModel * _Nullable model) {
        if(state){
            completion(model);
        }else{
            [self showAlertMessage:msg];
        }
    }];
    
}

-(void)initData{
    _isCheckedForWalletPurse = NO;
    _dataController = [[MDPaymentDataController alloc] init];
}

-(void)initView{
    
    [self.navigationItem setTitle:rechargeType == MDRechargeTypeCard ? @"卡包购买":@"电子钱包充值"];
    
    _mainTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [self refreshData];
}



-(UITableViewCell*)paymentWayWithTableView:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath{
    static NSString *iconCell = @"TitleAndIconCell";
    static NSString *paymentCell = @"PaymentPasswordCell";
    UITableViewCell *cell;
    if(indexPath.row == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:paymentCell];
        if(cell == nil){
            cell = [self bringPaymentPasswardViewWithIdentifier:paymentCell];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:iconCell];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iconCell];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
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
                title = [NSString stringWithFormat:@"电子钱包余额：¥%.2f%@",_walletBalance,(_walletBalance > [_mainTextField.text floatValue] ? @"" : @"（余额不足）")];
                break;
        }
        if(![icon isEqualToString:@""])[cell.imageView setImage:[UIImage imageNamed:icon]];
        if(![title isEqualToString:@""])[cell.textLabel setText:title];
    }
    return cell;
}

-(UITableViewCell*)bringBalanceViewWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setText:@"可用余额："];
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.left.equalTo(cell.mas_left).with.offset(8);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    [valueLabel setTextColor:[UIColor redColor]];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    [valueLabel setTag:1001];
    [cell addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(8);
        make.right.equalTo(cell.mas_right).with.offset(8);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
    }];
    return cell;
}

-(UITableViewCell*)bringRechargeBalanceViewWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setText:@"充值金额："];
    [cell.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.left.equalTo(cell.contentView.mas_left).with.offset(8);
        make.top.equalTo(cell.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
    }];
    
    _mainTextField = [[UITextField alloc] init];
    [_mainTextField setTextColor:[UIColor redColor]];
    [_mainTextField setFont:[UIFont systemFontOfSize:14]];
    [_mainTextField setTag:1001];
    [_mainTextField setPlaceholder:@"请输入充值金额"];
    [_mainTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [cell.contentView addSubview:_mainTextField];
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).with.offset(8);
        make.right.equalTo(cell.contentView.mas_right).with.offset(8);
        make.top.equalTo(cell.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
    }];
    return cell;
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
        __weak typeof(MDRechargeViewController) *weakSelf = self;
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
