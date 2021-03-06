//
//  SignModel.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SignModel.h"
#import "WXTURLFeedOBJ+Data.h"
#import "WXTURLFeedOBJ.h"
#import "SignEntity.h"

@interface SignModel(){
    NSMutableArray *_signArr;
}
@end

@implementation SignModel

-(void)parseClassifyData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    SignEntity *entity = [SignEntity signWithDictionary:dic];
    [_signArr addObject:entity];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:entity.time forKey:LastSignDate];
}

-(void)signGainMoney{
    [_signArr removeAllObjects];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"daily_attendance", @"cmd", userDefault.wxtID, @"user_id", [NSNumber numberWithInt:ShopID], @"agent_id", userDefault.token, @"token", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_LoadBalance httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        NSDictionary *dic = retData.data;
        __block SignModel *blockSelf = self;
        if ([[dic objectForKey:@"success"] integerValue] != 1){
            if (_delegate && [_delegate respondsToSelector:@selector(signFailed:)]){
                [_delegate signFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(signSucceed)]){
                [_delegate signSucceed];
            }
        }
    }];
}

@end
