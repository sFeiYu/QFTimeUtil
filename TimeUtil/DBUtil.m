//
//  DBUtil.m
//  Xiahuang
//
//  Created by KnowChat03 on 2019/6/26.
//  Copyright © 2019 Hangzhou middust Information Technology Co., Ltd. All rights reserved.
//

#import "DBUtil.h"
#import "PersonInfoManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@implementation DBUtil

#pragma mark - Path

+ (NSString *)dataRootPath
{
    if ([PersonInfoManager shareManager].memberId.length == 0) {
        return @"";
    }
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * rootPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"xiahuang_%@", [PersonInfoManager shareManager].memberId]];
    if (![manager fileExistsAtPath:rootPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rootPath;
}

+(NSString* )databasePathWithDBName:(NSString *)DBName
{
    
    NSString* path = [DBUtil dataRootPath];
    //创建数据库文件夹
    NSString *databaseFolder = [path stringByAppendingPathComponent:@"knowchat_Database"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:databaseFolder])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:databaseFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建数据库文件
    NSString* dbPath = [databaseFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", DBName]];
    return dbPath;
}

#pragma mark - Database

+ (BOOL)createDBWithDBName:(NSString *)DBName 
{
    BOOL isSucceed;
    NSString *dbFilePath = [DBUtil databasePathWithDBName:@"NoticeMain"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbFilePath];
    if (![database open]) {
        NSLog(@"打开失败");
        isSucceed = NO;
    }else{
        //聊天列表表
        if (![database tableExists:@"NoticeMain"]) {
            [database executeUpdate:@"create table if not exists NoticeMain(MemeberID text(50) primary key not null, IconImage text(200) not null, NickName text(50) not null, NoticeID text(50) not null, NoticeTime text(30) not null, NoticeRemark text(1000) not null, SendState text(2) not null, UnreadCount text(5) not null)"];
        }
        isSucceed = YES;
    }
    return isSucceed;
}


@end
