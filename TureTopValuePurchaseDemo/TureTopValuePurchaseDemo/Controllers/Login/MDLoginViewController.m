//
//  MDLoginViewController.m
//  TureTopValuePurchaseDemo
//  用户登录控制器
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDLoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AESCrypt.h"

#import "MDLoginDataController.h"

@interface MDLoginViewController ()<UITextFieldDelegate>

@end

@implementation MDLoginViewController{
    MDLoginDataController *_dataController;
    
    BOOL _isSelected;//是否选中 记住密码
    UIButton *_rememberButton;//记住密码 选择框
    
    UITextField *_userTextField;
    UITextField *_passwordTextField;
}

@synthesize topIndex,loginAlterBlock;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark UIAlertViewDelegate

#pragma mark -- UITextFielDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _userTextField && ![_userTextField.text isEqualToString:@""]){
        [textField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }else if(textField == _passwordTextField){
        [textField resignFirstResponder];
        [self userLogin];
    }
    return YES;
}


#pragma mark action and event methods
/**
 *  返回上一个界面
 */
- (void)backTap
{
    if(topIndex == 2){
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:array[array.count - topIndex - 1] animated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  跳转 忘记密码 修改密码 界面
 */
-(void)PushtoFindPassWord
{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeForgetPassword title:@"忘记密码" parameters:nil isNeedLogin:NO loginTipBlock:nil];
}

/**
 *  跳转 注册 界面
 */
- (void)PushtoRegister
{
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeRegister title:@"用户注册" parameters:nil isNeedLogin:NO loginTipBlock:nil];
}


/**
 *  记住密码选择框 点击事件
 *
 *  @param buttton 记住密码选择框 按钮控件
 */
- (void)rememberPassword:(UIButton *)buttton
{
    _isSelected = !_isSelected;
    NSString *imageName = @"unchecked";
    if (_isSelected) imageName = @"checked";
    [buttton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


/**
 *  用户登录 事件
 */
- (void)userLogin
{
    if(_userTextField.text.length == 0){
        [self showAlertDialog:@"请输入用户名/手机号"];
        return;
    }
    if(_passwordTextField.text.length == 0){
        [self showAlertDialog:@"请输入密码"];
        return;
    }
    [self.progressView show];
    [_dataController submitDataWithUserName:_userTextField.text password:_passwordTextField.text rememberPW:_isSelected completion:^(BOOL state, NSString *msg) {
        if(state){
            [self.navigationController popViewControllerAnimated:YES];
            if(loginAlterBlock) loginAlterBlock();
        }else{
            [self showAlertDialog:msg];
        }
        [self.progressView hide];
    }];
}

#pragma mark private methods

-(void)initData{
    _dataController = [[MDLoginDataController alloc] init];
    _isSelected = NO;
}
/**
 *  初始化界面
 */
-(void)initView{
    [self.navigationItem setTitle:@"登录"];
    [self.leftButton removeTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchDown];
    [self.leftButton addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchDown];
    [self.rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.rightButton addTarget:self action:@selector(PushtoRegister) forControlEvents:UIControlEventTouchDown];
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [self.view addSubview: scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    UIView *scrollContentView = [[UIView alloc] init];
    [scrollView addSubview: scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).with.insets(UIEdgeInsetsZero);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    //添加 账户/密码 输入框区域
    UIView * loginView = [[UIView alloc]initWithFrame:CGRectZero];
    loginView.layer.borderColor = [UIColorFromRGBA(214.0, 214.0, 214.0, 1) CGColor];
    loginView.layer.borderWidth = 0.8;
    [scrollContentView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(91);
        make.right.equalTo(scrollContentView.mas_right).with.offset(0);
        make.left.equalTo(scrollContentView.mas_left).with.offset(-5);
        make.top.equalTo(scrollContentView.mas_top).with.offset(64);
    }];
    _userTextField = [self addTextFieldWithView:loginView masEqual:loginView.mas_top offset:0 text:@"账户:" placeholder:@"邻里账户/手机号" isCarve:YES secureTextEntry:NO];
    [_userTextField setReturnKeyType:UIReturnKeyNext];
    _passwordTextField = [self addTextFieldWithView:loginView masEqual:loginView.mas_bottom offset:-44 text:@"密码:" placeholder:@"密码" isCarve:NO secureTextEntry:YES];
    [_passwordTextField setReturnKeyType:UIReturnKeyDone];
    
    
    _rememberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rememberButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [_rememberButton addTarget:self action:@selector(rememberPassword:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:_rememberButton];
    [_rememberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(loginView.mas_left).with.offset(15);
        make.top.equalTo(loginView.mas_bottom).with.offset(10);
    }];
    
    UILabel * savePassword = [[UILabel alloc] init];
    savePassword.text = @"记住密码";
    savePassword.font = [UIFont systemFontOfSize:15];
    savePassword.textColor = UIColorFromRGBA(106.0, 106.0, 106.0, 1);
    [scrollContentView addSubview:savePassword];
    [savePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 25));
        make.top.equalTo(loginView.mas_bottom).with.offset(10);
        make.left.equalTo(_rememberButton.mas_right).with.offset(5);
    }];
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(PushtoFindPassWord) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [scrollContentView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 25));
        make.top.equalTo(loginView.mas_bottom).with.offset(10);
        make.right.equalTo(scrollContentView.mas_right).with.offset(-10);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = UIColorFromRGBA(240.0, 57.0, 11.0,1.0);
    loginBtn.layer.cornerRadius = 4;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [scrollContentView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollContentView.mas_left).with.offset(10);
        make.right.equalTo(scrollContentView.mas_right).with.offset(-10);
        make.top.equalTo(savePassword.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@35);
    }];
    
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginBtn.mas_bottom);
    }];
    
    
    //初始化用户名输入框 密码输入框 记住密码按钮
    _userTextField.text = [MDUserDefaultHelper readForKey:userCodeKey];
    _isSelected = [[MDUserDefaultHelper readForKey:rememberPWKey] boolValue];
    if (_isSelected)
    {
        _passwordTextField.text = [AESCrypt decrypt:[MDUserDefaultHelper readForKey:userPassWordKey] password:AESCryptKey] ;
        [_rememberButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
}
/**
 *  添加一个UIView，包含一个显示名称的UILabel和一个输入对应内容的UITextFields
 *
 *  @param superView       UIView的父级对象
 *  @param masEqual        UIView的顶部约束对象的位置
 *  @param offset          UIView的顶部约束对象的位置的距离
 *  @param tag             UITextField的tag值
 *  @param text            UILabel的text熟悉值
 *  @param placeholder     UITextField的提示内容
 *  @param isCarve         是否有分隔线
 *  @param secureTextEntry 是否有分隔线
 *
 *  @return UITextField
 */
-(UITextField*)addTextFieldWithView:(UIView*)superView masEqual:(MASViewAttribute *)masEqual offset:(double)offset text:(NSString*)text placeholder:(NSString*)placeholder isCarve:(BOOL)isCarve secureTextEntry:(BOOL)secureTextEntry{
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(masEqual).with.offset(offset);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = UIColorFromRGBA(106.0, 106.0, 106.0, 1);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CGSizeMake(40, 34));
        make.left.equalTo(view.mas_left).with.offset(15);
        make.centerY.equalTo(view);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = placeholder;
    textField.textColor = UIColorFromRGBA(106.0, 106.0, 106.0, 1);
    [textField setSecureTextEntry:secureTextEntry];
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.left.equalTo(label.mas_right).with.offset(5);
        make.right.equalTo(view.mas_right).with.offset(10);
        make.centerY.equalTo(view);
    }];
    
    if(isCarve){
        UILabel * lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = UIColorFromRGBA(214.0, 214.0, 214.0, 1);
        [superView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(superView.mas_left).with.offset(0);
            make.right.equalTo(superView.mas_right).with.offset(0);
            make.top.equalTo(view.mas_bottom).with.offset(2);
        }];
    }
    return textField;
}

@end
