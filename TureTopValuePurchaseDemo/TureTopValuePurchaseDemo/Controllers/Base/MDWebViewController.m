//
//  MDWebViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDWebViewController.h"
#import "MDLoginViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface MDWebViewController ()<UIWebViewDelegate>

@end

@implementation MDWebViewController{
    UIWebView *_mainWebView;
    BOOL _needLogin;
    NSString *_requestURL;
}

@synthesize requestURL,navigateTitle;

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _needLogin = NO;
    if(!APPDATA.isLogin){
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if(self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO];
    }
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        MDLoginViewController *controller = [[MDLoginViewController alloc] init];
        controller.topIndex = 2;
        controller.loginAlterBlock = ^(){
            _requestURL = [MDCommon appendParameterForAppWithURL:_requestURL];
            if(APPDATA.isLogin){
                NSLog(@"登陆后的请求路径：%@",_requestURL);
                [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
                _needLogin = NO;
            }
        };
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:@"$('.pageWrap').addClass('none_h');"];
    [context evaluateScript:@"$('.pageWrap2').css({'padding-top':'5rem'});"];
    [context evaluateScript:@"$('.pageWrap2').find('ul.u_tab').css({'top':'0'});"];
    [self performSelector:@selector(showWeb) withObject:self afterDelay:0.1f];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([self.navigationItem.title isEqualToString:@""] && title != nil){
        [self.navigationItem setTitle: title];
    }
    if(_needLogin){
        _needLogin = NO;
        [self showAlertdialog];
        
    }
    [self.progressView hide];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(_needLogin){
        _needLogin = NO;
        [self showAlertdialog];
    }
    [self.progressView hide];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self.progressView show];
    NSURL *url = [request URL];
    NSString *urlString = url.relativeString;
    NSLog(@"shouldStartLoadWithRequest:%@",urlString);
    if([urlString isEqualToString:requestURL] || [requestURL extensionWithContainsString:urlString] || [[urlString componentsSeparatedByString:@"?"][0] isEqualToString:[requestURL componentsSeparatedByString:@"?"][0]]) {
        return YES;
    }
    
    if([urlString extensionWithContainsString:PAGECONFIG.homePageURLString]){
        [self.navigationController popViewControllerAnimated:NO];
        return YES;
    }
    
    NSString *token = nil;
    if(APPDATA.isLogin) token = APPDATA.token;
    
    //根据url获取控制器
    UIViewController *controller = [MDCommon controllerForPagePathWithURL:urlString currentController:self token:token];
    if(controller == nil) return NO;
    if([controller isKindOfClass:[MDLoginViewController class]]){
        _needLogin = YES;
        [self.progressView hide];
        return NO;
    }
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

#pragma mark action event methods

#pragma mark private methods
-(void)showWeb{
    [self.view bringSubviewToFront:_mainWebView];
}

-(void)initView{
    [self.navigationItem setTitle:navigateTitle];
    
    //_requestURL = [requestURL extensionWithContainsString:wapURL] ? [MDCommon appendParameterForAppWithURL:requestURL] : requestURL;
    _requestURL = [requestURL copy];
    _mainWebView = [[UIWebView alloc] init];
    [_mainWebView setDelegate:self];
    [self.view addSubview:_mainWebView];
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    NSURL *URL;
    if(__IPHONE_SYSTEM_VERSION > 9){
        URL = [NSURL URLWithString:[_requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }else{
        URL = [NSURL URLWithString:[_requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [_mainWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
    NSLog(@"initView:%@",[URL absoluteString]);
    
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}


-(void)showAlertdialog{
    if(__IPHONE_SYSTEM_VERSION >= 8){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，请登录" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}

@end
