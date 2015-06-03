//
//  OrderListDef.h
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_OrderListDef_h
#define RKWXT_OrderListDef_h

enum{
    OrderList_All = 0,
    OrderList_Wait_Pay,
    OrderList_Wait_Send,
    OrderList_Wait_Receive,
    
    OrderList_Invalid
};

#import "OrderAllListVC.h"
#import "WaitPayOrderListVC.h"
#import "WaitReceiveOrderListVC.h"
#import "WaitSendGoodsListVC.h"

#endif
