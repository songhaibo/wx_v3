//
//  WXTUITabbarVC.m
//  RKWXT
//
//  Created by SHB on 15/4/22.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITabbarVC.h"
#import "WXTFindVC.h"
#import "WXTMallViewController.h"
#import "UserInfoVC.h"
#import "ContactsCallViewController.h"
#import "CallViewController.h"

#define kTabBarHeight (52.0)
#define Size self.bounds.size

@interface WXTUITabbarVC(){
    NSArray *views;
    ContactsCallViewController * callview;
    CallViewController *recentCall;
}

@property (nonatomic,strong) UIView *downView;
@end

@implementation WXTUITabbarVC
@synthesize downView;

-(id)init{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(inputNumber) name:InputNumber object:nil];
    [notification addObserver:self selector:@selector(delNumberToEnd) name:DelNumberToEnd object:nil];
    [notification addObserver:self selector:@selector(showDownView) name:ShowDownView object:nil];
    [notification addObserver:self selector:@selector(hideDownView) name:HideDownView object:nil];
    
    WXTMallViewController * mallVC = [[[WXTMallViewController alloc] init] autorelease];
    callview = [[[ContactsCallViewController alloc] init] autorelease];
    WXTFindVC *phoneView = [[[WXTFindVC alloc] init] autorelease];
    UserInfoVC *infoVC = [[[UserInfoVC alloc] init] autorelease];
    
    WXUITabBarItem *mallItem = [self createTabbarItem];
    [mallItem setTabBarItemImage:[UIImage imageNamed:@"MallNormal.png"] forState:WXButtonControlState_Normal];
    [mallItem setTabBarItemImage:[UIImage imageNamed:@"MallSelected.png"] forState:WXButtonControlState_Selected];
    [mallItem setTabBarItemTitle:@"商城" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *callItem = [self createTabbarItem];
    [callItem setTabBarItemImage:[UIImage imageNamed:@"CallNormal.png"] forState:WXButtonControlState_Normal];
    [callItem setTabBarItemImage:[UIImage imageNamed:@"CallSelected.png"] forState:WXButtonControlState_Selected];
    [callItem setTabBarItemTitle:@"通话" forState:WXButtonControlState_Normal];
    
//    //实现app+
//    WXUITabBarItem *addItem = [self createTabbarItem];
//    [addItem setTabBarItemImage:[UIImage imageNamed:@"ContactInfoHeadImg.png"] forState:WXButtonControlState_Normal];
//    [addItem setTabBarItemImage:[UIImage imageNamed:@"ContactInfoHeadImg.png"] forState:WXButtonControlState_Selected];
//    [addItem setTabBarItemTitle:@"app+" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *findItem = [self createTabbarItem];
    [findItem setTabBarItemImage:[UIImage imageNamed:@"FindNormal.png"] forState:WXButtonControlState_Normal];
    [findItem setTabBarItemImage:[UIImage imageNamed:@"FindSelected.png"] forState:WXButtonControlState_Selected];
    [findItem setTabBarItemTitle:@"发现" forState:WXButtonControlState_Normal];
    
    WXUITabBarItem *moreItem = [self createTabbarItem];
    [moreItem setTabBarItemImage:[UIImage imageNamed:@"UserNormal.png"] forState:WXButtonControlState_Normal];
    [moreItem setTabBarItemImage:[UIImage imageNamed:@"UserSelected.png"] forState:WXButtonControlState_Selected];
    [moreItem setTabBarItemTitle:@"个人中心" forState:WXButtonControlState_Normal];

    WXUITabBar *tabBar = [[[WXUITabBar alloc] initWithTabBarHeight:kTabBarHeight] autorelease];
    if([self showTabbarNumber] == 3){
        [tabBar setTabBarItems:[NSArray arrayWithObjects:callItem,findItem,moreItem, nil]];
        if(self = [super initWithControllers:[NSArray arrayWithObjects:callview,phoneView,infoVC, nil] tabBar:tabBar]){
        }
    }else{
        [tabBar setTabBarItems:[NSArray arrayWithObjects:mallItem,callItem,findItem,moreItem, nil]];
        if(self = [super initWithControllers:[NSArray arrayWithObjects:mallVC,callview,phoneView,infoVC, nil] tabBar:tabBar]){
        }
    }
    [tabBar setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}

-(WXUITabBarItem*)createTabbarItem{
    CGSize size = [self tabBarItemSize];
    WXUITabBarItem *item = [WXUITabBarItem tabBarItem];
    [item setFrame:CGRectMake(0, 0, size.width, size.height)];
    [item setTitleColor:WXColorWithInteger(0x808080) forState:WXButtonControlState_Normal];
    [item setTitleColor:WXColorWithInteger(0x0c8bdf) forState:WXButtonControlState_Selected];
    return item;
}

-(CGSize)tabBarItemSize{
    return CGSizeMake(IPHONE_SCREEN_WIDTH/[self showTabbarNumber], kTabBarHeight);
}

-(NSInteger)showTabbarNumber{
    NSInteger number = 4;
    if([CustomMadeOBJ sharedCustomMadeOBJS].appCategory == E_App_Category_Eatable){
        return 3;
    }
    return number;
}

-(void)repeatSelectedAtIndex:(NSInteger)index{
    if([self showTabbarNumber] == 3){
        if(index == 0){
            [self callBtn];
        }
    }else{
        if(index == 1){
            [self callBtn];
        }
    }
}

-(void)callBtn{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ClickedKeyboardBtn object:nil];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if([self showTabbarNumber] == 3){
        [self selectedAtIndex:0];
    }else{
        [self selectedAtIndex:1];
    }
    [self setDexterity:E_Slide_Dexterity_Low];
    
    [self createDownView];
    
    
//    if([CustomMadeOBJ sharedCustomMadeOBJS].appCategory == E_App_Category_Eatable){
//        [but setHidden:YES];
//        [label setHidden:YES];
//        
//        
//        [but0 setFrame:CGRectMake(0, 3, Size.width/3, kTabBarHeight/2+btnGapHeight)];
//        [label0 setFrame:CGRectMake(0, kTabBarHeight/2+ygap, Size.width/3, kTabBarHeight/2-btnGapHeight)];
//        
//        [but1 setFrame:CGRectMake(Size.width/3, 3, Size.width/3, kTabBarHeight/2+btnGapHeight)];
//        [label1 setFrame:CGRectMake(Size.width/3, kTabBarHeight/2+ygap, Size.width/3, kTabBarHeight/2-btnGapHeight)];
//        
//        [but2 setFrame:CGRectMake(Size.width*2/3, 3, Size.width/3, kTabBarHeight/2+btnGapHeight)];
//        [label2 setFrame:CGRectMake(Size.width*2/3, kTabBarHeight/2+ygap, Size.width/3, kTabBarHeight/2-btnGapHeight)];
//    }
}

-(void)createDownView{
    downView = [[UIView alloc] init];
    downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    [downView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [self.view addSubview:downView];
    
    WXTUIButton *keyboardBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    keyboardBtn.frame = CGRectMake(0, 5, Size.width/4, kTabBarHeight/2);
    [keyboardBtn setImage:[UIImage imageNamed:@"CallSelected.png"] forState:UIControlStateNormal];
    [keyboardBtn addTarget:self action:@selector(downviewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:keyboardBtn];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(0, kTabBarHeight/2, Size.width/4, kTabBarHeight/2);
    [textLabel setText:@"通话"];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:WXTFont(12.0)];
    [textLabel setTextColor:WXColorWithInteger(0x0c8bdf)];
    [downView addSubview:textLabel];
    
    WXTUIButton *callBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(Size.width/4, 0, Size.width/2, kTabBarHeight);
    [callBtn setImage:[UIImage imageNamed:@"CallBtnImg.png"] forState:UIControlStateNormal];
    [callBtn setBackgroundImageOfColor:WXColorWithInteger(0x2fbf62) controlState:UIControlStateNormal];
    [callBtn setBackgroundImageOfColor:WXColorWithInteger(0x0e8739) controlState:UIControlStateSelected];
    [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:callBtn];
}

//收起键盘和底部
-(void)downviewBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
    if(recentCall.downview_type == DownView_Del || recentCall.downview_type == DownView_Init){
        [UIView animateWithDuration:KeyboardDur animations:^{
            downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
        }];
    }
}

-(void)showDownView{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
    }];
}

-(void)hideDownView{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    }];
}

//键盘输入
-(void)inputNumber{
    if(recentCall.downview_type == DownView_show){
        return;
    }
    recentCall.downview_type = DownView_show;
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height-kTabBarHeight, Size.width*3/4, kTabBarHeight);
    }];
    //    callview.segmentControl.hidden = YES;
}

-(void)delNumberToEnd{
    [UIView animateWithDuration:KeyboardDur animations:^{
        downView.frame = CGRectMake(0, Size.height, Size.width*3/4, kTabBarHeight);
    }];
}


-(void)callBtnClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:CallPhone object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end