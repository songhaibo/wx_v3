//
//  CallVC.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCallIdentifier         @"callIdentifier"

@interface CallVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@end
