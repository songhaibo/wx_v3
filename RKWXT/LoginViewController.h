//
//  ViewController.h
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField * pwdTextField;
@property (nonatomic, weak) IBOutlet UIButton * btnLogin;
@end

