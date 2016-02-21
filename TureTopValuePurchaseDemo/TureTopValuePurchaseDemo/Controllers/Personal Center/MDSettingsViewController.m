//
//  MDSettingsViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSettingsViewController.h"

@interface MDSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MDSettingsViewController{
    NSString *_serviceTel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _serviceTel = @"400-098-0808";
    [self initView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:;
                //账户安全
                [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAccountSecurity title:@"账户安全" parameters:nil isNeedLogin:YES loginTipBlock:nil];
                break;
            case 1://检测版本
                [MDCommon checkedVersionForAppWithUpdateWithController:self isShowNewVersionMessage:YES];
                break;
            case 2://关于超值购
                [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeAbout title:@"关于超值购" parameters:nil isNeedLogin:NO loginTipBlock:nil];
                break;
            case 3:{//客服热线
                NSString *str=[NSString stringWithFormat:@"tel:%@",_serviceTel];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
                break;
        }
    }else if(indexPath.section == 1){
        if(APPDATA.isLogin){
            [MDHttpManager POST:APICONFIG.loginOutApiURLString parameters:@{} sucessBlock:^(id  _Nullable responseObject) {
                
            } failureBlock:^(NSError * _Nonnull error) {
                
            }];
            APPDATA.isLogin = NO;
            [MDUserDefaultHelper removeForKey:userIDKey];
            [MDUserDefaultHelper removeForKey:tokenKey];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 4 : 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return APPDATA.isLogin ? 2 : 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == 0 ){
        static NSString *normalCellIdentifier = @"NormalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:normalCellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            
            UILabel *label = [[UILabel alloc] init];
            [label setTextColor:UIColorFromRGBA(220, 220, 220, 1)];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTag:1001];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(120, 30));
                make.right.equalTo(cell.contentView.mas_right).with.offset(0);
                make.centerY.equalTo(cell.contentView);
            }];
        }
    }else{
        static NSString *exitLoginCellIdentifier = @"ExitLoginCell";
        cell = [tableView dequeueReusableCellWithIdentifier:exitLoginCellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:exitLoginCellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UILabel *label = [[UILabel alloc] init];
            [label setTextColor:[UIColor redColor]];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:@"退出登录"];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsZero);
            }];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 ){
        UILabel *label = [cell.contentView viewWithTag:1001];
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"账户安全"];
                break;
            case 1:
                [cell.textLabel setText:@"检测版本"];
                [label setText:__APP_VERSION];
                break;
            case 2:
                [cell.textLabel setText:@"关于超值购"];
                break;
            case 3:
                [cell.textLabel setText:@"客服热线"];
                [label setText:_serviceTel];
                break;
        }
    }
}

#pragma mark private methods
-(void)initView{
    [self.navigationItem setTitle:@"设置"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

@end
