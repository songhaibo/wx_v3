//
//  MainViewController.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MainViewController.h"
#import "HttpNetUtils.h"
#import "ContactsViewController.h"
#import "CallContactsVC.h"
#import "Constants.h"

@implementation MainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
//    NSLog(@"%suser_id:%@",__func__,[USER_DEFAULT objectForKey:@"userId"]);
    
//    NSString * userId = [USER_DEFAULT objectForKey:@"userId"];
//    [HttpNetUtils callPhoneActionWith:userId andCalled:@"17093432980" andCallback:^(id obj){
//        NSLog(@"%sresponseObject:%@\nmsg:%@",__func__,obj,obj[@"msg"]);
//    }];
    
    
//    [NOTIFY_CENTER postNotificationName:@"pageChange" object:sender];
}

-(IBAction)callBackPhone:(id)sender{
    NSLog(@"%s",__func__);
    NSString * userId = [USER_DEFAULT objectForKey:@"userId"];
    [HttpNetUtils callPhoneActionWith:userId andCalled:self.callPhoneTextField.text andCallback:^(id obj){
        if([obj[@"success"] intValue] == 1){
            
        }
        NSLog(@"%sresponseObject:%@\nmsg:%@",__func__,obj,obj[@"msg"]);
    }];
}

-(IBAction)contactsPage:(id)sender{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactsViewController * contactsCtrl = [storyBoard instantiateViewControllerWithIdentifier:@"ContactsCtrl"];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:contactsCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CallContactsVC * callVC = []
    switch (item.tag) {
        case 100:
            break;
        case 200:
//            [self.view addSubview:];
            DDLogWarn(@"%s",__FUNCTION__);
            break;
        default:
            break;
    }
}

-(void)pageChange{
    
}

@end
