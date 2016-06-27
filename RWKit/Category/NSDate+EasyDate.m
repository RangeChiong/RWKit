//
//  NSDate+EasyDate.m
//  RPAntus
//
//  Created by Crz on 15/12/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "NSDate+EasyDate.h"

@implementation NSDate (EasyDate)

#pragma mark-   返回格式化后的日期字符串

+ (NSString *)rw_stringFromTimeInterval:(NSTimeInterval)interval {
    //  处理时间
    NSDate *receivedDate = [NSDate dateWithTimeIntervalSince1970:interval / 1000.0];
    return [self stringFromDate:receivedDate];
}

+ (NSString *)rw_stringFromTimeInterval:(NSTimeInterval)interval
                          withFormat:(NSString *)format {
    //  处理时间
    NSDate *receivedDate = [NSDate dateWithTimeIntervalSince1970:interval / 1000.0];
    return [self stringFromDate:receivedDate withFormat:format];
}

+ (NSString *)rw_stringFromNow {

    return [self stringFromNowWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)rw_stringFromNowWithFormat:(NSString *)format {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];

    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)rw_stringFromDate:(NSDate *)date {

    return [self stringFromDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)rw_stringFromDate:(NSDate *)date withFormat:(NSString *)format {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];

    return [dateFormatter stringFromDate:date];
}

#pragma mark-   返回格式化后的日期字符串

+ (NSDate *)rw_dateFromString:(NSString *)string {

    return [self dateFromString:string withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)rw_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSTimeInterval)rw_timeIntervalSince1970 {

    return [[NSDate date] timeIntervalSince1970];
}

@end
