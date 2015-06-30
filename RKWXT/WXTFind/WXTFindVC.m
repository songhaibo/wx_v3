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

#define Size self.bounds.size

@interface WXTFindVC()<wxtFindDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    WXTFindModel *_model;
    UIView *shellView;
    UITableView *_tableView;
    
    NSMutableArray *dataArr; //界面显示的数据
    NSMutableArray *spaceArr; //界面空格数据
    
    //webview单纯展示网页的
    UIWebView *_webView;
}
@end

@implementation WXTFindVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat yOffset = 0;
    if(kShowFind != 0){
        if(kShowFind == 1){
            if(kFindName){
                [self setCSTTitle:kFindName];
            }else{
                [self setCSTTitle:@"发现"];
            }
        }else{  //只显示状态栏
            yOffset = 20;
            [self setCSTNavigationViewHidden:YES animated:NO];
        }
    }else{
        [self setCSTNavigationViewHidden:YES animated:NO];
    }
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _model = [[WXTFindModel alloc] init];
    [_model setFindDelegate:self];
    [_model loadFindData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
    dataArr = [[NSMutableArray alloc] init];
    spaceArr = [[NSMutableArray alloc] init];
    
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, yOffset, Size.width, Size.height-yOffset);
    [shellView setBackgroundColor:[UIColor clearColor]];
    [shellView setHidden:YES];
    [self addSubview:shellView];
    [self showReloadBaseView];
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, yOffset, Size.width, Size.height-yOffset);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setHidden:YES];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setTableFooterView:[self emptyView]];
    [self addSubview:_tableView];
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, yOffset, Size.width, Size.height-yOffset)];
    [_webView setDelegate:self];
    [_webView setHidden:YES];
    [self addSubview:_webView];
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
    [btn setBackgroundImageOfColor:WXColorWithInteger(0xdd2726) controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [btn setTitle:@"刷新重试" forState:UIControlStateNormal];
    [btn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadFindData) forControlEvents:UIControlEventTouchUpInside];
    [shellView addSubview:btn];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section>0){
        return height;
    }
    FindEntity *entity = [_model.findDataArr objectAtIndex:0];
    if(entity.find_ygap == Find_YgapType_BigSpace){
        height = 20;
    }
    if(entity.find_ygap == Find_YgapType_TwoBigSpace){
        height = 40;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section  == [dataArr count]-1){
        return height;
    }
    FindEntity *enti = [_model.findDataArr objectAtIndex:0];
    if(enti.find_ygap != Find_YgapType_None){
        section = section+1;
    }
    FindEntity *entity = [spaceArr objectAtIndex:section];
    if(entity.find_ygap == Find_YgapType_BigSpace){
        height = 20;
    }
    if(entity.find_ygap == Find_YgapType_TwoBigSpace){
        height = 40;
    }
    return height;
}

-(WXUITableViewCell*)findCommonCellAtSection:(NSInteger)section{
    static NSString *identifier = @"findCommonCell";
    WXTFindCommmonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTFindCommmonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[dataArr objectAtIndex:section]];
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
    FindEntity *entity = [dataArr objectAtIndex:section];
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = entity.webUrl;
    commonVC.titleName = entity.name;
    [self.wxNavigationController pushViewController:commonVC];
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
    
    NSInteger number = 0;
    for(FindEntity *entity in _model.findDataArr){
        number ++;
        if(entity.find_ygap == Find_YgapType_BigSpace || entity.find_ygap == Find_YgapType_SmallSpace){
            if(entity.find_ygap == Find_YgapType_BigSpace){
                if(number == 2){
                    entity.find_ygap = Find_YgapType_TwoBigSpace;
                    [spaceArr removeLastObject];
                }
            }
            [spaceArr addObject:entity];
        }else{
            number = 0;
            [dataArr addObject:entity];
        }
    }
    
    [_tableView setHidden:NO];
    [shellView setHidden:YES];
    [_tableView reloadData];
}

//无网络情况下二次加载
-(void)reloadFindData{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
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
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
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
