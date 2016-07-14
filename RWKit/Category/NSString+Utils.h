//
//  NSString+Utils.h
//  Pods
//
//  Created by Ranger on 16/6/28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

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


/** 正则匹配11位手机号码 */
- (BOOL)rw_checkPhoneNumber;

@end
