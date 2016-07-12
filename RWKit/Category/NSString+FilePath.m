//
//  NSString+FilePath.m
//  Test0711
//
//  Created by 常小哲 on 16/7/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

+ (NSString *)rw_documentsPath {
    return [self rw_searchPathFrom:NSDocumentDirectory];
}

+ (NSString *)rw_cachesPath {
    return [self rw_searchPathFrom:NSCachesDirectory];
}

+ (NSString *)rw_documentsContentDirectory:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [self rw_documentsPath], name];
}

+ (NSString *)rw_cachesContentDirectory:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [self rw_cachesPath], name];
}

#pragma mark-  private methods

+ (NSString *)rw_searchPathFrom:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

@end
