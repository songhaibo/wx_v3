//
//  WXTDatabase.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WXTDatabase : NSObject
@property (nonatomic, strong) NSString * dbName; // 数据库文件名
+(instancetype)shareDatabase;
-(BOOL)createDatabase:(NSString *)dbName;
-(BOOL)createWXTTable;
-(void)insertCallHistory:(NSString*)aName telephone:(NSString *)aTelephone date:(NSString*)aDate type:(int)aType;
-(NSMutableArray *)queryCallHistory;
/**
 @param telephone 电话号码
 */
-(void)delCallHistory:(NSString*)telephone;
@end