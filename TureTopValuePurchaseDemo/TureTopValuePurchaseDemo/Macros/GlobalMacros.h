//
//  GlobalMacros.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#ifndef GlobalMacros_h
#define GlobalMacros_h

/***********************尺寸**********************/
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_SIZE SCREEN_BOUNDS.size//屏幕尺寸
#define SCREEN_WIDTH SCREEN_SIZE.width//屏幕宽度
#define SCREEN_HEIGHT SCREEN_SIZE.height//屏幕高度

/***********************颜色**********************/
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//rgb颜色
#define UIColorFromRGBA(r,g,b,a)([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
//
#define UIColorFromRGB(r,g,b)(UIColorFromRGBA(r,g,b,1.0))
//tab item名称默认状态
#define TAB_COLOR UIColorFromRGB(51.0,51.0,51.0)
//tab item名称选中状态颜色
#define TAB_SELECTED_COLOR UIColorFromRGB(252.0,80.0,2.0)
//nav标题文字颜色
#define GRAY_COLOR UIColorFromRGB(129.0,129.0,129.0)
//文本输入框
#define INPUT_COLOR UIColorFromRGB(106.0,106.0,106.0)


/***********************版本**********************/
#define __IPHONE_SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]


/***********************单例实例**********************/
#define APICONFIG [MDAPIConfig sharedConfig]
#define PAGECONFIG [MDPageConfig sharedConfig]
#define APPDATA [MDAppData sharedData]
#define FLUENTDB [MDFluentDB sharedDB]
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#endif
