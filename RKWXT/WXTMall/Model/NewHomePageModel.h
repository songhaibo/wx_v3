//
//  NewHomePageModel.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageTop.h"
#import "HomePageRecModel.h"
#import "HomePageThemeModel.h"
#import "HomePageSurpModel.h"
#import "HomeNavModel.h"

@interface NewHomePageModel : NSObject
@property (nonatomic,assign) id<HomePageTopDelegate,HomePageRecDelegate,HomePageThemeDelegate,HomePageSurpDelegate>delegate;

@property (nonatomic,readonly) HomePageTop *top;
@property (nonatomic,readonly) HomePageRecModel *recommend;
@property (nonatomic,readonly) HomePageThemeModel *theme;
@property (nonatomic,readonly) HomePageSurpModel *surprise;
@property (nonatomic,readonly) HomeNavModel *navModel;

-(BOOL)isSomeDataNeedReload;
-(void)loadData;
-(void)toInit;

@end
