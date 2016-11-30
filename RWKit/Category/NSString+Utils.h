//
//  NSString+Utils.h
//  Pods
//
//  Created by Ranger on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark-  FolderPath

@interface NSString (FolderPath)

/*!
 *  获取沙盒下documens文件夹路径
 */
+ (NSString *)rw_documentsPath;

/*!
 *  获取沙盒下caches文件夹路径
 */
+ (NSString *)rw_cachesPath;

/*!
 *  获取沙盒下documens文件夹中 文件或者文件夹的完整路径
 */
+ (NSString *)rw_documentsContentDirectory:(NSString *)name;

/*!
 *  获取沙盒下caches文件夹中 文件或者文件夹的完整路径
 */
+ (NSString *)rw_cachesContentDirectory:(NSString *)name;

@end

#pragma mark-  Reg

@interface NSString (Reg)

/** 正则匹配11位手机号码 */
- (BOOL)rw_checkPhoneNumber;

/** 判断纯数字字符串 */
- (BOOL)rw_isPureInt;

@end

#pragma mark-  Project

@interface NSString (Project)

/** 获取当前工程的发布版本 */
+ (NSString *)rw_shortVersion;

/** 获取当前工程的内部版本 */
+ (NSInteger)rw_buildVersion;

/** 获取当前工程的唯一标识 */
+ (NSString *)rw_identifier;

/** 从mainBundle中根据key获取信息 */
+ (NSString *)rw_objectFromMainBundleForKey:(NSString *)key;

@end

#pragma mark-  string calcalation

@interface NSString (Calculation)

/** 计算单位 ：xxx万 xxx亿 */
- (NSString *)calculateUnit;

/** 添加千分符号 1,000,000 */
- (NSString *)addSeparator;

/** 计算文字宽高 */
- (CGSize)stringSize:(UIFont *)font regularHeight:(CGFloat)height;

@end
