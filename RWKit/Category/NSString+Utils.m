//
//  NSString+Utils.m
//  Pods
//
//  Created by Ranger on 16/6/28.
//
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

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

#pragma 正则匹配11位手机号
- (BOOL)rw_checkPhoneNumber {
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark-  判断纯数字字符串
- (BOOL)rw_isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
