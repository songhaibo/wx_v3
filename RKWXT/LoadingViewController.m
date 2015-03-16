//
//  LoadingViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoadingViewController.h"
#import "RegistVC.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //	UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //	MainViewController * mainCtrl = [storyBoard instantiateViewControllerWithIdentifier:@"MainCtrl"];
    //    NSArray * view = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:nil options:nil];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [imageView setImage:[UIImage imageNamed:@"Default@2x.png"]];
    [self.view addSubview:imageView];
    [UIView animateWithDuration:4.0 animations:^(){
        imageView.alpha = 1.0f;
    }completion:^(BOOL finished){
        if(finished){
            [UIApplication sharedApplication].statusBarHidden = YES;
            [imageView removeFromSuperview];
            RegistVC * vc = [[RegistVC alloc] init];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
