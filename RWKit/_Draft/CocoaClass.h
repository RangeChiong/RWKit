//
//  CocoaClass.h
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

@import Foundation;
@import ObjectiveC.runtime;

@class CocoaProperty;
@class CocoaMethod;
@class CocoaIvar;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CPEncodingType) {
    CPEncodingType_Mask       = 0xFF, ///< mask of type value
    CPEncodingType_Unknown    = 0, ///< unknown
    CPEncodingType_Void       = 1, ///< void
    CPEncodingType_Bool       = 2, ///< bool
    CPEncodingType_Int8       = 3, ///< char / BOOL
    CPEncodingType_UInt8      = 4, ///< unsigned char
    CPEncodingType_Int16      = 5, ///< short
    CPEncodingType_UInt16     = 6, ///< unsigned short
    CPEncodingType_Int32      = 7, ///< int
    CPEncodingType_UInt32     = 8, ///< unsigned int
    CPEncodingType_Int64      = 9, ///< long long
    CPEncodingType_UInt64     = 10, ///< unsigned long long
    CPEncodingType_Float      = 11, ///< float
    CPEncodingType_Double     = 12, ///< double
    CPEncodingType_LongDouble = 13, ///< long double
    CPEncodingType_Object     = 14, ///< id
    CPEncodingType_Class      = 15, ///< Class
    CPEncodingType_SEL        = 16, ///< SEL
    CPEncodingType_Block      = 17, ///< block
    CPEncodingType_Pointer    = 18, ///< void*
    CPEncodingType_Struct     = 19, ///< struct
    CPEncodingType_Union      = 20, ///< union
    CPEncodingType_CString    = 21, ///< char*
    CPEncodingType_CArray     = 22, ///< char[10] (for example)
    
    CPEncodingType_QualifierMask   = 0xFF00,   ///< mask of qualifier
    CPEncodingType_QualifierConst  = 1 << 8,  ///< const
    CPEncodingType_QualifierIn     = 1 << 9,  ///< in
    CPEncodingType_QualifierInout  = 1 << 10, ///< inout
    CPEncodingType_QualifierOut    = 1 << 11, ///< out
    CPEncodingType_QualifierBycopy = 1 << 12, ///< bycopy
    CPEncodingType_QualifierByref  = 1 << 13, ///< byref
    CPEncodingType_QualifierOneway = 1 << 14, ///< oneway
    
    CPEncodingType_PropertyMask         = 0xFF0000, ///< mask of property
    CPEncodingType_PropertyReadonly     = 1 << 16, ///< readonly
    CPEncodingType_PropertyCopy         = 1 << 17, ///< copy
    CPEncodingType_PropertyRetain       = 1 << 18, ///< retain
    CPEncodingType_PropertyNonatomic    = 1 << 19, ///< nonatomic
    CPEncodingType_PropertyWeak         = 1 << 20, ///< weak
    CPEncodingType_PropertyCustomGetter = 1 << 21, ///< getter=
    CPEncodingType_PropertyCustomSetter = 1 << 22, ///< setter=
    CPEncodingType_PropertyDynamic      = 1 << 23, ///< @dynamic
};

// get encoding type
CPEncodingType CPGetEncodingType(const char *typeEncoding);


@interface CocoaClass : NSObject

@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) CocoaClass *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaProperty *> *propertyInfos;///< properties
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaMethod *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaIvar *> *ivarInfos; ///< ivars

+ (instancetype)resolve:(Class)cls;
+ (instancetype)resolveWithClassName:(NSString *)clsName;
- (instancetype)initWithClass:(Class)cls;

// update info

- (void)setNeedUpdate;
- (BOOL)needUpdate;

// property
- (void)copyPropertyList:(void(^)(objc_property_t property))block;

// method
- (BOOL)swizzleMethod:(SEL)oldSel withMethod:(SEL)newSel;
- (void)copyMethodList:(void(^)(Method method))block;

// ivar
- (void)copyIvarList:(void(^)(Ivar ivar))block;

@end


@interface CocoaProperty : NSObject

@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) CPEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

+ (instancetype)resolve:(objc_property_t)property;
- (instancetype)initWithProperty:(objc_property_t)property;

@end


@interface CocoaMethod : NSObject
@end


@interface CocoaIvar : NSObject
@end

NS_ASSUME_NONNULL_END
