//
//  CoordinateController.m
//  Woxin2.0
//
//  Created by le ting on 7/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "CoordinateController.h"
#import "ContactDetailVC.h"
#import "SignViewController.h"
#import "NewGoodsInfoVC.h"
#import "UserBonusVC.h"
#import "MakeOrderVC.h"
#import "OrderPayVC.h"
#import "RechargeVC.h"
#import "HomeOrderVC.h"
#import "OrderListEntity.h"
#import "OrderDealRefundVC.h"
#import "RefundSucceedVC.h"
#import "GoodsInfoVC.h"
#import "AboutShopVC.h"
@implementation CoordinateController

+ (CoordinateController*)sharedCoordinateController{
    static dispatch_once_t onceToken;
    static CoordinateController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinateController alloc] init];
    });
    return sharedInstance;
}

+ (WXUINavigationController*)sharedNavigationController{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    WXUINavigationController *navigationController = appDelegate.navigationController;
    return navigationController;
}

-(void)toRechargeVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    [vc.wxNavigationController pushViewController:rechargeVC];
}

-(void)toOrderList:(id)sender selectedShow:(NSInteger)number animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    HomeOrderVC *orderListVC = [[HomeOrderVC alloc] init];
    orderListVC.selectedNum = number;
    [vc.wxNavigationController pushViewController:orderListVC];
}

-(void)toGoodsInfoVC:(id)sender goodsID:(NSInteger)goodsID animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    NewGoodsInfoVC *orderListVC = [[NewGoodsInfoVC alloc] init];
    orderListVC.goodsId = goodsID;
    [vc.wxNavigationController pushViewController:orderListVC];
}

-(void)toUserBonusVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    UserBonusVC *bonusVC = [[UserBonusVC alloc] init];
    [vc.wxNavigationController pushViewController:bonusVC];
}

-(void)toMakeOrderVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    MakeOrderVC *orderVC = [[MakeOrderVC alloc] init];
    orderVC.goodsList = orderInfo;
    [vc.wxNavigationController pushViewController:orderVC];
}

-(void)toOrderPayVC:(id)sender orderInfo:(id)orderInfo animated:(BOOL)animated{
    OrderListEntity *entity = orderInfo;
    WXUIViewController *vc = sender;
    NSInteger number = 0;
    CGFloat price = 0;
    for(OrderListEntity *ent in entity.goodsArr){
        number += ent.sales_num;
        price += ent.factPayMoney;
    }
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.orderID = [NSString stringWithFormat:@"%ld",(long)entity.order_id];
    payVC.payMoney = price;
    [vc.wxNavigationController pushViewController:payVC];
}

-(void)toRefundVC:(id)sender goodsInfo:(id)goodsInfo animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    OrderDealRefundVC *refundVC = [[OrderDealRefundVC alloc] init];
    refundVC.entity = goodsInfo;
    [vc.wxNavigationController pushViewController:refundVC];
}

-(void)toRefundInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    RefundSucceedVC *refundInfoVC = [[RefundSucceedVC alloc] init];
    refundInfoVC.entity = orderEntity;
    [vc.wxNavigationController pushViewController:refundInfoVC];
}

-(void)toOrderInfoVC:(id)sender orderEntity:(id)orderEntity animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    GoodsInfoVC *goodsInfoVC = [[GoodsInfoVC alloc] init];
    goodsInfoVC.goodsEntity = orderEntity;
    [vc.wxNavigationController pushViewController:goodsInfoVC];
}

-(void)toAboutShopVC:(id)sender animated:(BOOL)animated{
    WXUIViewController *vc = sender;
    AboutShopVC *shopVC = [[AboutShopVC alloc] init];
    [vc.wxNavigationController pushViewController:shopVC];
}

@end
