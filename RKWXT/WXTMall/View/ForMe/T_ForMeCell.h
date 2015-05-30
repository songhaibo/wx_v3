//
//  T_ForMeCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol forMeCellDeleagte;
@interface T_ForMeCell : WXMiltiViewCell
@property (nonatomic,assign)id<forMeCellDeleagte>delegate;
@end

@protocol forMeCellDeleagte <NSObject>
-(void)forMeCellClicked:(id)entity;
@end
