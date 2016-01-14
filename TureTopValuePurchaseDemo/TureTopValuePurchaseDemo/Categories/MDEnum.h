//
//  MDEnum.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#ifndef MDEnum_h
#define MDEnum_h

/*!
 *  读取资源文件信息
 */
typedef NS_ENUM(NSInteger,LDReadResourceStateType) {
    /*!
     *  读取成功
     */
    LDReadResourceStateTypeSuccess = 0,
    /*!
     *  文件不存在
     */
    LDReadResourceStateTypePathNoExist = 1,
    /*!
     *  内容转换json错误
     */
    LDReadResourceStateTypeContentTransformError = 2
};

#endif /* MDEnum_h */
