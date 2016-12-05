//
//  RWKeyChain.h
//  Test1114
//
//  Created by RangerChiong on 16/11/14.
//  Copyright © 2016年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RWKeyChainErrorCode) {
    RWKeyChainError_None = noErr,
    RWKeyChainError_BadArguments = -1001,
    RWKeyChainError_NoPassword = -1002,
    RWKeyChainError_InvalidParameter = errSecParam,
    RWKeyChainError_FailedToAllocated = errSecAllocate,
    RWKeyChainError_NotAvailable = errSecNotAvailable,
    RWKeyChainError_AuthorizationFailed = errSecAuthFailed,
    RWKeyChainError_DuplicatedItem = errSecDuplicateItem,
    RWKeyChainError_NotFound = errSecItemNotFound,
    RWKeyChainError_InteractionNotAllowed = errSecInteractionNotAllowed,
    RWKeyChainError_FailedToDecode = errSecDecode
};

extern NSString *const kRWKeychain_ErrorDomain;
extern NSString *const kRWKeychain_AccountKey;
extern NSString *const kRWKeyChain_UUIDKey;
extern NSString *const kRWKeychain_CreatedAtKey;
extern NSString *const kRWKeychain_ClassKey;
extern NSString *const kRWKeychain_DescriptionKey;
extern NSString *const kRWKeychain_LabelKey;
extern NSString *const kRWKeychain_LastModifiedKey;
extern NSString *const kRWKeychain_WhereKey;

@interface RWKeyChain : NSObject

+ (NSArray *)allAccounts;

+ (NSArray *)allAccounts:(NSError **)error;

+ (NSArray *)accountsForService:(NSString *)serviceName;

+ (NSArray *)accountsForService:(NSString *)serviceName error:(NSError **)error;


+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account;

+ (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;

+ (NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account;

+ (NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;

+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account;

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;

@end
