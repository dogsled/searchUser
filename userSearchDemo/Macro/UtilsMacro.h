//
//  MacroDefinition.h
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//
#ifndef MacroDefinition_h
#define MacroDefinition_h

//AppDelegate
#define APPDELEGATE      ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//屏幕缩放系数，基础图是6p
//#define AUTOSIZESCALE_6P3X  (([UIScreen mainScreen].bounds.size.width)/414.0/3.0)

//----------------------系统设备相关----------------------------
//获取设备屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//应用尺寸
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define isIOS4 ([[[UIDevice currentDevice] systemVersion] intValue]==4)
#define isIOS5 ([[[UIDevice currentDevice] systemVersion] intValue]==5)
#define isIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]==6)
#define isIOS7 ([[[UIDevice currentDevice] systemVersion] intValue]==7)
#define isIOS8 ([[[UIDevice currentDevice] systemVersion] intValue]==8)
#define isIOS9 ([[[UIDevice currentDevice] systemVersion] intValue]==9)
#define isAfterIOS4 ([[[UIDevice currentDevice] systemVersion] intValue]>4)
#define isAfterIOS5 ([[[UIDevice currentDevice] systemVersion] intValue]>5)
#define isAfterIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]>6)
#define isAfterIOS7 ([[[UIDevice currentDevice] systemVersion] intValue]>7)
#define isAfterIOS8 ([[[UIDevice currentDevice] systemVersion] intValue]>8)
#define isAfterIOS9 ([[[UIDevice currentDevice] systemVersion] intValue]>9)
//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#define KOriginalPhotoImagePath   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif
