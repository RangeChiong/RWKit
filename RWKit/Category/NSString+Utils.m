//
//  NSString+Utils.m
//  Pods
//
//  Created by Ranger on 16/6/28.
//
//

#import "NSString+Utils.h"

#pragma mark-  FolderPath

@implementation NSString (FolderPath)

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

#pragma mark-  Reg

@implementation NSString (Reg)

#pragma mark-  判断纯数字字符串
- (BOOL)rw_isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
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

@end

#pragma mark-  Project

@implementation NSString (Project)

+ (NSString *)rw_shortVersion {
    return [self rw_objectFromMainBundleForKey:@"CFBundleShortVersionString"];
}

+ (NSInteger)rw_buildVersion {
    return [self rw_objectFromMainBundleForKey:@"CFBundleVersion"].integerValue;
}

+ (NSString *)rw_identifier {
    return [self rw_objectFromMainBundleForKey:@"CFBundleIdentifier"];
}

+ (NSString *)rw_objectFromMainBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  [infoDictionary objectForKey:key];
}

@end

#pragma mark-  string calculation

@implementation NSString (Calculation)


#pragma mark-  string length

- (CGSize)stringSize:(UIFont *)font regularHeight:(CGFloat)height {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                         
                                                       context:nil];
    return stringRect.size;
}

@end
