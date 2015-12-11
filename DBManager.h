
#import <Foundation/Foundation.h>
/*
 数据管理
 按照单例设计模式 进行 设计
 存储 收藏/下载/浏览记录
 //增删改查数据
 */

#import "FMDatabase.h"

@interface DBManager : NSObject
//非标准单例
+ (DBManager *)sharedManager;
//增加 数据 收藏/浏览/下载记录

//存储类型 favorites downloads browses
- (void)insertModel:(id)model recordType:(NSString *)type;
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForAppId:(NSString *)appId recordType:(NSString *)type;

- (BOOL)deleteValueWithFavorityId:(NSString *)favorityId;

//根据指定类型  查找所有的记录
- (NSArray *)readAllModels;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForAppId:(NSString *)appId recordType:(NSString *)type;
//根据 指定的记录类型  返回 记录的条数
//- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type;
// 删除表
- (BOOL)dropTable;

@end


