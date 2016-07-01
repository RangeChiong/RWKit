//
//  RWDatabaseManager.h
//  Test0701
//
//  Created by Ranger on 16/7/1.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDatabaseManager : NSObject

+ (instancetype)shareInstance;

/**
 *  打开数据库
 *
 *  @param sqliteFilePath 数据库文件路径 如果没有 则创建
 *  @param tableDict      @{@"tableName" : Class cls}
 */
- (void)open:(NSString *)sqliteFilePath dict:(NSDictionary *)tableDict;

/**
 *  打开数据库
 *
 *  @param sqliteFilePath 数据库文件路径 如果没有 则创建
 *  @param tableDict      @{@"tableName" : tableModel}
 *  @param done           操作完成后的回调 返回bool表示该操作是否成功
 */
- (void)open:(NSString *)sqliteFilePath dict:(NSDictionary *)tableDict done:(void(^)(BOOL success))done;

/**
 *  插入数据
 *
 *  @param tableName 表的名字
 *  @param modelArr  需要插入到该表的数据 @[model1,model2];
 */
- (void)insert:(NSString *)tableName models:(NSArray *)modelArr;

/**
 *  插入数据
 *
 *  @param tableName 表的名字
 *  @param modelArr  需要插入到该表的数据 @[model1,model2];
 *  @param done      操作完成后的回调 返回bool表示该操作是否成功
 */
- (void)insert:(NSString *)tableName models:(NSArray *)modelArr done:(void(^)(BOOL success))done;

/**
 *  删除数据
 *
 *  @param tableName  表的名字
 *  @param conditions 查询到需要删除数据的条件 @[model1, model2] 需要用到哪个条件去查询 就对model的哪个属性赋值
 */
- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions;

/**
 *  删除数据
 *
 *  @param tableName  表的名字
 *  @param conditions 查询到需要删除数据的条件 @[model1, model2] 需要用到哪个条件去查询 就对model的哪个属性赋值
 *  @param done       操作完成后的回调 返回bool表示该操作是否成功
 */
- (void)deleteData:(NSString *)tableName conditions:(NSArray *)conditions done:(void(^)(BOOL success))done;

/**
 *  更新数据
 *
 *  @param tableName 表的名字
 *  @param param     需要更新数据的键值对
 *  @param condition 查询需要更新数据的条件的键值对
 */
- (void)update:(NSString *)tableName param:(NSDictionary *)param condition:(NSDictionary *)condition;

/**
 *  更新数据
 *
 *  @param tableName 表的名字
 *  @param param     需要更新数据的键值对
 *  @param condition 查询需要更新数据的条件的键值对
 *  @param done      操作完成后的回调 返回bool表示该操作是否成功
 */
- (void)update:(NSString *)tableName
         param:(NSDictionary *)param
     condition:(NSDictionary *)condition
          done:(void(^)(BOOL success))done;

/**
 *  查询所有数据
 *
 *  @param tableName 表的名字
 *  @param block     每查到一个数据 就会以键值对的形式 从block中返回
 *  @param done      查询完成的回调
 */
- (void)queryAll:(NSString *)tableName perRow:(void(^)(NSDictionary *dict))block done:(dispatch_block_t)done;

@end

