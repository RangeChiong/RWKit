//
//  RWKeyChain.m
//  Test1114
//
//  Created by RangerChiong on 16/11/14.
//  Copyright © 2016年 Ranger. All rights reserved.
//

#import "RWKeyChain.h"

NSString *const kRWKeyChain_ErrorDomain = @"com.ranger.rwkeychain";
NSString *const kRWKeyChain_AccountKey = @"com.ranger.acct";
NSString *const kRWKeyChain_UUIDKey = @"com.ranger.UUID";
NSString *const kRWKeyChain_CreatedAtKey = @"com.ranger.cdat";
NSString *const kRWKeyChain_ClassKey = @"com.ranger.cls";
NSString *const kRWKeyChain_DescriptionKey = @"desc";
NSString *const kRWKeyChain_LabelKey = @"com.ranger.labl";
NSString *const kRWKeyChain_LastModifiedKey = @"com.ranger.mdat";
NSString *const kRWKeyChain_WhereKey = @"com.ranger.svce";

@implementation RWKeyChain

#pragma mark - Getting Accounts

+ (NSArray *)allAccounts {
    return [self accountsForService:nil error:nil];
}


+ (NSArray *)allAccounts:(NSError **)error {
    return [self accountsForService:nil error:error];
}


+ (NSArray *)accountsForService:(NSString *)service {
    return [self accountsForService:service error:nil];
}


+ (NSArray *)accountsForService:(NSString *)service error:(NSError **)error {
    OSStatus status = RWKeyChainError_BadArguments;
    NSMutableDictionary *query = [self _queryForService:service account:nil];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kRWKeyChain_ErrorDomain code:status userInfo:nil];
        return nil;
    }
    
    return (__bridge_transfer NSArray *)result;
}

#pragma mark - Getting Passwords

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account {
    return [self passwordForService:service account:account error:nil];
}

+ (NSString *)passwordForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    NSData *data = [self passwordDataForService:service account:account error:error];
    if (data.length > 0) {
        NSString *string = [[NSString alloc] initWithData:(NSData *)data encoding:NSUTF8StringEncoding];
        return string;
    }
    
    return nil;
}

+ (NSData *)passwordDataForService:(NSString *)service account:(NSString *)account {
    return [self passwordDataForService:service account:account error:nil];
}

+ (NSData *)passwordDataForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = RWKeyChainError_BadArguments;
    if (!service || !account) {
        if (error) {
            *error = [NSError errorWithDomain:kRWKeyChain_ErrorDomain code:status userInfo:nil];
        }
        return nil;
    }
    
    CFTypeRef result = NULL;
    NSMutableDictionary *query = [self _queryForService:service account:account];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kRWKeyChain_ErrorDomain code:status userInfo:nil];
        return nil;
    }
    return (__bridge_transfer NSData *)result;
}

#pragma mark - Deleting Passwords

+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account {
    return [self deletePasswordForService:service account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = RWKeyChainError_BadArguments;
    if (service && account) {
        NSMutableDictionary *query = [self _queryForService:service account:account];
        status = SecItemDelete((__bridge CFDictionaryRef)query);
    }
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kRWKeyChain_ErrorDomain code:status userInfo:nil];
    }
    return (status == noErr);
    
}

#pragma mark - Setting Passwords

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account {
    return [self setPassword:password forService:service account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    return [self setPasswordData:data forService:service account:account error:error];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)service account:(NSString *)account {
    return [self setPasswordData:password forService:service account:account error:nil];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = RWKeyChainError_BadArguments;
    if (password && service && account) {
        [self deletePasswordForService:service account:account];
        NSMutableDictionary *query = [self _queryForService:service account:account];
        [query setObject:password forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kRWKeyChain_ErrorDomain code:status userInfo:nil];
    }
    return (status == noErr);
}

#pragma mark-  private methods

+ (NSMutableDictionary *)_queryForService:(NSString *)service account:(NSString *)account {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    if (service) {
        [dictionary setObject:service forKey:(__bridge id)kSecAttrService];
    }
    
    if (account) {
        [dictionary setObject:account forKey:(__bridge id)kSecAttrAccount];
    }
    
    return dictionary;
}

@end
