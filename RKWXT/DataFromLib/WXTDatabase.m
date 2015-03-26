//
//  WXTDatabase.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTDatabase.h"
#import "DBCommon.h"
#import "EGODatabase.h"
@interface WXTDatabase(){
    EGODatabase * _database;
}

@end

@implementation WXTDatabase

-(id)init{
    @synchronized(self){
        if (self == nil) {
            self = [super init];
        }
    }
    return  self;
}

+(instancetype)shareDatabase{
    static dispatch_once_t onceToken;
    static WXTDatabase *database = nil;
    dispatch_once(&onceToken,^{
        database = [[WXTDatabase alloc] init];
    });
    return database;
}

-(BOOL)createDatabase:(NSString *)dbName{
    NSString * dbPath = [NSString stringWithFormat:@"%@/%@.sqlite",DOC_PATH,dbName];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _database = [EGODatabase databaseWithPath:dbPath];
    });
    if ([_database open]) {
        return YES;
    }
    return NO;
}

-(BOOL)createWXTTable{
    if ([_database open]) {
        if ([_database executeUpdate:kWXTCallTable]) {
            NSLog(@"%s用户通话数据表创建成功",__FUNCTION__);
            return YES;
        }else{
            NSLog(@"%s数据库表创建失败",__FUNCTION__);
            return NO;
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
        return NO;
    }
}

-(void)insertCallHistory:(NSString *)telephone date:(NSString*)date type:(int)type{
    if ([_database open]) {
        EGODatabaseResult * result = [_database executeQuery:[NSString stringWithFormat:kWXTInsertCallHistory,telephone,date,type]];
        if ([result errorCode] == 0) {
            NSLog(@"%s用户通话记录插入success:%lu",__FUNCTION__,[result count]);
        }else{
            NSLog(@"%s用户通话记录插入error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
}

-(NSMutableArray *)queryCallHistory{
    if ([_database open]) {
        EGODatabaseResult * result = [_database executeQuery:kWXTQueryCallHistory];
        if ([result errorCode] == 0) {
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i= 0 ; i < [result count]; i++) {
                EGODatabaseRow * databaseRow = [result rowAtIndex:i];
                NSString * telephone = [databaseRow stringForColumn:kWXTCall_Column_Telephone];
                NSString * date = [databaseRow stringForColumn:kWXTCall_Column_Date];
                int type = [databaseRow intForColumn:kWXTCall_Column_Date];
                NSLog(@"telephone:%@\tdate:%@\ttype:%i",telephone,date,type);
            }
            NSLog(@"%s用户通话记录查询success:%lu",__FUNCTION__,[result count]);
            return mutableArr;
        }else{
            NSLog(@"%s用户通话记录查询error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
    return nil;
}

-(void)delCallHistory:(NSString*)telephone{
    if ([_database open]) {
        EGODatabaseResult * result = [_database executeQuery:[NSString stringWithFormat:kWXTDelCallHistory,telephone]];
        if ([result errorCode] == 0) {
            NSLog(@"%s用户通话记录删除success:%lu",__FUNCTION__,[result count]);
        }else{
            NSLog(@"%s用户通话记录删除error:%i",__FUNCTION__,[result errorCode]);
        }
    }else{
        NSLog(@"%s数据库打开error:%@",__FUNCTION__,[_database lastErrorMessage]);
    }
}
@end
