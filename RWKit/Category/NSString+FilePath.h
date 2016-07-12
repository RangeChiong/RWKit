//
//  NSString+FilePath.h
//  Test0711
//
//  Created by 常小哲 on 16/7/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)

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
