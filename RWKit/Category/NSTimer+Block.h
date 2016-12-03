//
//  NSTimer+Block.h
//  RWKit
//
//  Created by Ranger on 16/5/5.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

/** 开启一个定时器 默认为RunLoopCommonMode */
+ (instancetype)rw_scheduleTimerWithTimeInterval:(NSTimeInterval)ti
                                         repeats:(BOOL)rep
                                      usingBlock:(void (^)(NSTimer *timer))block;

/** 开启一个定时器 */
+ (instancetype)rw_scheduleTimerWithTimeInterval:(NSTimeInterval)ti
                                         repeats:(BOOL)rep
                                            mode:(NSRunLoopMode)mode
                                      usingBlock:(void (^)(NSTimer *timer))block;

/*!
 *  创建一个NSTimer实例
 */
+ (instancetype)rw_timerWithTimeInterval:(NSTimeInterval)ti
                                 repeats:(BOOL)rep
                              usingBlock:(void (^)(NSTimer *t))block;

@end

NS_ASSUME_NONNULL_END
