//
//  CocoaClass.m
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "CocoaClass.h"

@implementation CocoaClass {
    BOOL _needUpdate;
}

@synthesize propertyInfos = _propertyInfos;
@synthesize methodInfos = _methodInfos;
@synthesize ivarInfos = _ivarInfos;

+ (instancetype)resolve:(Class)cls {
    NSParameterAssert(cls);
    
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CocoaClass *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate) {
        [info __update];
    }
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[CocoaClass alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)resolveWithClassName:(NSString *)clsName {
    Class cls = NSClassFromString(clsName);
    return [self resolve:cls];
}

- (instancetype)initWithClass:(Class)cls {
    NSParameterAssert(cls);

    self = [super init];
    if (self) {
        _cls = cls;
        _superCls = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        _name = NSStringFromClass(cls);
        _superClassInfo = [self.class resolve:_superCls];
    }
    return self;
}

#pragma mark-  update class info

- (void)__update {
    _propertyInfos = nil;
    _ivarInfos = nil;
    _methodInfos = nil;

    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

#pragma mark-  property

- (void)copyPropertyList:(void(^)(objc_property_t property))block {
    NSParameterAssert(block);
    u_int count;
    objc_property_t *properties = class_copyPropertyList(_cls, &count);
    if (properties) {
        for (u_int i = 0; i < count; i++) {
            block(properties[i]);
        }
    }
    
    free(properties);
}

#pragma mark-  methods

- (BOOL)swizzleMethod:(SEL)oldSel withMethod:(SEL)newSel {
    
    Method oldMethod = class_getInstanceMethod(_cls, oldSel);
    Method newMethod = class_getInstanceMethod(_cls, newSel);
    
    BOOL didAddMethod = class_addMethod(_cls,
                                        oldSel,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(_cls,
                            newSel,
                            method_getImplementation(oldMethod),
                            method_getTypeEncoding(oldMethod));
    }
    else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
    return didAddMethod;
}

- (void)copyMethodList:(void(^)(Method method))block {
    NSParameterAssert(block);
    u_int count;
    Method *methods = class_copyMethodList(_cls, &count);
    if (methods) {
        for (u_int i = 0; i < count; i++) {
            block(methods[i]);
        }
    }

    free(methods);
}

#pragma mark-  ivar

- (void)copyIvarList:(void(^)(Ivar ivar))block {
    NSParameterAssert(block);
    u_int count;
    Ivar *ivars = class_copyIvarList(_cls, &count);
    if (ivars) {
        for (u_int i = 0; i < count; i++) {
            block(ivars[i]);
        }
    }
    
    free(ivars);
}

#pragma mark-  info getter

- (NSDictionary<NSString *,CocoaProperty *> *)propertyInfos {
    if (_propertyInfos) return _propertyInfos;
    
    NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
    _propertyInfos = propertyInfos;
    [self copyPropertyList:^(objc_property_t  _Nonnull property) {
        CocoaProperty *info = [[CocoaProperty alloc] initWithProperty:property];
        if (info.name) propertyInfos[info.name] = info;
    }];

    return _propertyInfos ?: @{};
}

- (NSDictionary<NSString *,CocoaMethod *> *)methodInfos {
    if (_methodInfos) return _methodInfos;
    
    NSMutableDictionary *methodInfos = [NSMutableDictionary new];
    _methodInfos = methodInfos;
    [self copyPropertyList:^(objc_property_t  _Nonnull property) {
        CocoaProperty *info = [[CocoaProperty alloc] initWithProperty:property];
        if (info.name) methodInfos[info.name] = info;
    }];
    
    return _methodInfos ?: @{};
}

- (NSDictionary<NSString *,CocoaIvar *> *)ivarInfos {
    if (_ivarInfos) return _ivarInfos;
    
    NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
    _ivarInfos = ivarInfos;
    [self copyPropertyList:^(objc_property_t  _Nonnull property) {
        CocoaProperty *info = [[CocoaProperty alloc] initWithProperty:property];
        if (info.name) ivarInfos[info.name] = info;
    }];
    
    return _ivarInfos ?: @{};
}

@end


#pragma mark-  CocoaProperty

@implementation CocoaProperty

CPEncodingType CPGetEncodingType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return CPEncodingType_Unknown;
    size_t len = strlen(type);
    if (len == 0) return CPEncodingType_Unknown;
    
    CPEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= CPEncodingType_QualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= CPEncodingType_QualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= CPEncodingType_QualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= CPEncodingType_QualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= CPEncodingType_QualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= CPEncodingType_QualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= CPEncodingType_QualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return CPEncodingType_Unknown | qualifier;
    
    switch (*type) {
        case 'v': return CPEncodingType_Void | qualifier;
        case 'B': return CPEncodingType_Bool | qualifier;
        case 'c': return CPEncodingType_Int8 | qualifier;
        case 'C': return CPEncodingType_UInt8 | qualifier;
        case 's': return CPEncodingType_Int16 | qualifier;
        case 'S': return CPEncodingType_UInt16 | qualifier;
        case 'i': return CPEncodingType_Int32 | qualifier;
        case 'I': return CPEncodingType_UInt32 | qualifier;
        case 'l': return CPEncodingType_Int32 | qualifier;
        case 'L': return CPEncodingType_UInt32 | qualifier;
        case 'q': return CPEncodingType_Int64 | qualifier;
        case 'Q': return CPEncodingType_UInt64 | qualifier;
        case 'f': return CPEncodingType_Float | qualifier;
        case 'd': return CPEncodingType_Double | qualifier;
        case 'D': return CPEncodingType_LongDouble | qualifier;
        case '#': return CPEncodingType_Class | qualifier;
        case ':': return CPEncodingType_SEL | qualifier;
        case '*': return CPEncodingType_CString | qualifier;
        case '^': return CPEncodingType_Pointer | qualifier;
        case '[': return CPEncodingType_CArray | qualifier;
        case '(': return CPEncodingType_Union | qualifier;
        case '{': return CPEncodingType_Struct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return CPEncodingType_Block | qualifier;
            else
                return CPEncodingType_Object | qualifier;
        }
        default: return CPEncodingType_Unknown | qualifier;
    }
}

+ (instancetype)resolve:(objc_property_t)property {
    return [[self alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property {
    NSParameterAssert(property);
    self = [self init];
    
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    CPEncodingType type = 0;
    u_int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        objc_property_attribute_t attr = attrs[i];
        const char *attrValue = attr.value;
        switch (attr.name[0]) {
            case 'T': { // Type encoding
                if (attrValue) {
                    _typeEncoding = [NSString stringWithUTF8String:attrValue];
                    type = CPGetEncodingType(attrValue);
                    if ((type & CPEncodingType_Mask) == CPEncodingType_Object) {
                        size_t len = strlen(attrValue);
                        if (len > 3) {
                            char clsName[len - 2];
                            clsName[len - 3] = '\0';
                            memcpy(clsName, attrValue + 2, len - 3);
                            _cls = objc_getClass(clsName);
                        }
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrValue) {
                    _ivarName = [NSString stringWithUTF8String:attrValue];
                }
            } break;
            case 'R': {
                type |= CPEncodingType_PropertyReadonly;
            } break;
            case 'C': {
                type |= CPEncodingType_PropertyCopy;
            } break;
            case '&': {
                type |= CPEncodingType_PropertyRetain;
            } break;
            case 'N': {
                type |= CPEncodingType_PropertyNonatomic;
            } break;
            case 'D': {
                type |= CPEncodingType_PropertyDynamic;
            } break;
            case 'W': {
                type |= CPEncodingType_PropertyWeak;
            } break;
            case 'G': {
                type |= CPEncodingType_PropertyCustomGetter;
                if (attrValue) {
                    _getter = sel_registerName(attrValue);
                }
            } break;
            case 'S': {
                type |= CPEncodingType_PropertyCustomSetter;
                if (attrValue) {
                    _setter = sel_registerName(attrValue);
                }
            } // break; commented for code coverage in next line
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    
    if (!_getter) {
        _getter = sel_registerName(name);
    }
    if (!_setter) {
        char *setter = nil;
        asprintf(&setter, "set%c%s:", toupper(*name), name + 1);
        _setter = sel_registerName(setter);
        free(setter);
    }
    
    return self;
}

@end

@implementation CocoaMethod

@end

@implementation CocoaIvar

@end

