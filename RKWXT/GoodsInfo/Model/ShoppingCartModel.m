//
//  ShoppingCartModel.m
//  RKWXT
//
//  Created by SHB on 15/6/19.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ShoppingCartModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface ShoppingCartModel(){
    NSMutableArray *_dataList;
}
@end

@implementation ShoppingCartModel
@synthesize data = _dataList;

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(id)init{
    self = [super init];
    if(self){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)parseGoodInfoDetail:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_dataList removeAllObjects];
}

-(void)loadGoodsInfoWithGoodsID:(NSInteger)goodsID withGoodsImg:(NSString *)goodsImg withGoodsNum:(NSInteger)number withGoodsName:(NSString*)name withGoodsPrice:(CGFloat)price withStockName:(NSString *)stockName withStockID:(NSInteger)stockID{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", userObj.wxtID, @"woxin_id",[NSNumber numberWithInt:(int)kSubShopID], @"shop_id", [NSNumber numberWithInt:1], @"type", [NSNumber numberWithInt:(int)goodsID], @"goods_id", [NSNumber numberWithInt:(int)number], @"goods_number", name, @"goods_name", [NSNumber numberWithFloat:price], @"goods_price", goodsImg, @"goods_img", [NSNumber numberWithInt:(int)stockID], @"goods_stock_id", stockName, @"goods_stock_name", nil];
    __block ShoppingCartModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(addGoodsToShoppingCartFailed:)]){
                [_delegate addGoodsToShoppingCartFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseGoodInfoDetail:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(addGoodsToShoppingCartSucceed:)]){
                [_delegate addGoodsToShoppingCartSucceed:[[retData.data objectForKey:@"data"] integerValue]];
            }
        }
    }];
}

@end
