//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "WXTFindModel.h"
#import "FindEntity.h"
#import "WXTFindCommmonCell.h"
#import "FindCommonVC.h"

#define Size self.view.bounds.size

@interface WXTFindVC()<wxtFindDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    WXTFindModel *_model;
    UIView *shellView;
    UITableView *_tableView;
    
    //webview单纯展示网页的
    UIWebView *_webView;
}
@end

@implementation WXTFindVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createTopView:@"发现"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _model = [[WXTFindModel alloc] init];
    [_model setFindDelegate:self];
    [_model loadFindData];
    [self showWaitView:self.view];
    
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, 66, Size.width, Size.height-50-66);
    [shellView setBackgroundColor:[UIColor clearColor]];
    [shellView setHidden:YES];
    [self.view addSubview:shellView];
    [self showReloadBaseView];
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 66, Size.width, Size.height-50-66);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setHidden:YES];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setTableFooterView:[self emptyView]];
    [self.view addSubview:_tableView];
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 66, Size.width, Size.height-50-66)];
    [_webView setDelegate:self];
    [_webView setHidden:YES];
    [self.view addSubview:_webView];
}

-(UIView *)emptyView{
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, Size.width, 100);
    [footView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    return footView;
}

#pragma mark showBaseView
-(void)showReloadBaseView{
    CGFloat yOffset = 100;
    UIImage *wifiImg = [UIImage imageNamed:@"NoWifi.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-wifiImg.size.width)/2, yOffset, wifiImg.size.width, wifiImg.size.height);
    [imgView setImage:wifiImg];
    [shellView addSubview:imgView];
    
    yOffset += wifiImg.size.height+10;
    CGFloat labelWidth = 200;
    CGFloat labelheight = 30;
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:WXTFont(14.0)];
    [label1 setText:@"世界上最遥远的距离就是"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label1];
    
    yOffset += labelheight;
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:WXTFont(14.0)];
    [label2 setText:@"没有网络连接"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label2];
    
    yOffset += labelheight+20;
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 35;
    WXTUIButton *btn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [btn setBorderRadian:10.0 width:0.5 color:[UIColor clearColor]];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [btn setTitle:@"刷新重试" forState:UIControlStateNormal];
    [btn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadFindData) forControlEvents:UIControlEventTouchUpInside];
    [shellView addSubview:btn];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if([_model.findDataArr count] > 0){
        section = [_model.findDataArr count]/2+1;
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section*2+1 > [_model.findDataArr count]-1){
        return height;
    }
    FindEntity *entity = [_model.findDataArr objectAtIndex:section*2+1];
    if(entity.find_ygap == Find_YgapType_BigSpace){
        height = 20;
    }
    if(entity.find_ygap == Find_YgapType_SmallSpace || entity.find_ygap == Find_YgapType_None){
        height = 0;
    }
    return height;
}

-(WXUITableViewCell*)findCommonCellAtSection:(NSInteger)section{
    static NSString *identifier = @"findCommonCell";
    WXTFindCommmonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTFindCommmonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[_model.findDataArr objectAtIndex:section*2]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self findCommonCellAtSection:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    FindEntity *entity = [_model.findDataArr objectAtIndex:section*2];
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = entity.webUrl;
    commonVC.titleName = entity.name;
    [self.navigationController pushViewController:commonVC animated:YES];
}


#pragma mark delegate
-(void)initFinddataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [shellView setHidden:NO];
    [_tableView setHidden:YES];
    if(!errorMsg){
        errorMsg = @"数据加载失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)initFinddataSucceed{
    [self unShowWaitView];
    if(_model.find_type == Find_Type_ShowWeb){
        [self showWebView];
        return;
    }
    if([_model.findDataArr count] == 0){
        return;
    }
    [_tableView setHidden:NO];
    [shellView setHidden:YES];
    [_tableView reloadData];
}

//无网络情况下二次加载
-(void)reloadFindData{
    [self showWaitView:self.view];
    [_model loadFindData];
}

#pragma mark showWeb
-(void)showWebView{
    if(!_model.webUrl){
        [shellView setHidden:NO];
        [_webView setHidden:YES];
        [_tableView setHidden:YES];
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.webUrl]];
    if (request){
        [_webView loadRequest:request];
    }
    [_webView setHidden:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_model setFindDelegate:nil];
}

@end
