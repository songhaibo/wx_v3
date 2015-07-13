//
//  WXTProductDetailViewController.m
//  RKWXT
//
//  Created by app on 5/28/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import "WXTGoodsDetailViewController.h"
#import "GoodsDetailCell.h"
#import "StrechyParallaxScrollView.h"
#import "EScrollerView.h"
#import "WXHomeTopGoodCell.h"
#import "UIButton+UIButtonImageWithLable.h"
#import "WXTAPNViewController.h"
@interface WXTGoodsDetailViewController ()<EScrollerViewDelegate>{
    UITableView * _tableView;
    NSMutableArray * _proPicMArray;
    NSMutableArray * _imageViewsMArray; // 视图
    UIScrollView * _baseScrollView;
    UIScrollView * _scrollView;
    
    int startContentOffsetX;
    int willEndContentOffsetX;
    int endContentOffsetX;
    int _currentPageIndex;
    NSTimer *_timer;
    NSUInteger _count;
    
    NSMutableArray * _dataMArray;
    NSMutableArray * _picMArray;
}

@end

@implementation WXTGoodsDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTTitle:@"商品详情"];
    [self setBackgroundColor:WXColorWithInteger(0xbfbfc3)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0x000000);
    [self loadData];
    [self initUI];
}

-(void)initUI{
    [self initTableView];
    [self initBottomView];
}

// 头部产品图片
-(void)initScrollView{
    CGFloat scrollViewH = IPHONE_SCREEN_HEIGHT - TAB_NAVIGATION_BAR_HEGITH - NAVIGATION_BAR_HEGITH - 20;
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH+20, IPHONE_SCREEN_WIDTH, scrollViewH)];
    [self.view addSubview:_baseScrollView];
}

-(UIView*)topProAdView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 266)];
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 266)
                                                          ImageArray:[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33", nil]];
    scroller.delegate=self;
    [view addSubview:scroller];
    return view;
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
}

-(void)initBottomView{
    // 购物车
    CGFloat cartW = 75;
    CGFloat cartH = 47;
    CGFloat cartY = IPHONE_SCREEN_HEIGHT - cartH;
    UIFont * common = [UIFont systemFontOfSize:14];
    UIButton * btnCart = [[UIButton alloc]initWithFrame:CGRectMake(0, cartY, cartW, cartH)];
    btnCart.backgroundColor = WXColorWithInteger(0x7f7f7f);
    btnCart.titleLabel.font = common;
    [btnCart setTitle:@"购物车" forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(cartDetail) forControlEvents:UIControlEventTouchUpInside];
    [btnCart setImage:[UIImage imageNamed:@"cart"] withTitle:@"购物车" forState:UIControlStateNormal];
    [self.view addSubview:btnCart];
    
    //立即购买
    CGFloat payW = (IPHONE_SCREEN_WIDTH - cartH)/2;
    UIButton * btnPay = [[UIButton alloc]initWithFrame:CGRectMake(cartW, cartY, payW, cartH)];
    btnPay.backgroundColor = WXColorWithInteger(0xff9c00);
    btnPay.titleLabel.font = common;
    btnPay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnPay setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnPay addTarget:self action:@selector(purchaseAtOnce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPay];
    
    //加入购物车
    UIButton * addCart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnPay.frame), cartY, payW, cartH)];//X:IPHONE_SCREEN_WIDTH -(IPHONE_SCREEN_WIDTH - cartH/2)
    addCart.backgroundColor = [UIColor redColor];
    addCart.titleLabel.font = common;
    addCart.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCart];
}

-(void)initTableView{
    CGFloat tableViewY = 64;
    CGFloat tableViewH = IPHONE_SCREEN_HEIGHT-64-49;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, IPHONE_SCREEN_WIDTH, tableViewH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData{
    _count = 5;
    _proPicMArray = [NSMutableArray array];
    _imageViewsMArray = [NSMutableArray array];
    for (int i = 0; i < _count; i ++) {
        UIImage * imageName = [UIImage imageNamed:@"Default@2x.png"];
        [_proPicMArray addObject:imageName];
    }
    
//    for (int i = 0; i < _count; i ++) {
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i *_scrollView.bounds.size.width,64,_scrollView.bounds.size.width,_scrollView.bounds.size.height)];
//        imageView.contentMode =UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
//        [_scrollView addSubview:imageView];
//        [_imageViewsMArray addObject:imageView];
//    }
    _dataMArray = [[NSMutableArray alloc] initWithObjects:@"图文详情",@"产品参数", nil];
    _picMArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"pic_detail"],[UIImage imageNamed:@"goods_args"],nil];
}

- (void)dynamicLoadingImageView
{
    for (int i = 0; i < _count; i ++) {
        UIImageView *imageView = [_imageViewsMArray objectAtIndex:i];
        imageView.image = [UIImage imageNamed:_proPicMArray[i]];
    }
}

-(void)cartDetail{
}

// 立即购买
-(void)purchaseAtOnce{
}

// 加入购物车
-(void)addToCart{
    NSLog(@"%s",__func__);
    WXTAPNViewController * viewController = [[WXTAPNViewController alloc]init];
    [self.wxNavigationController pushViewController:viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
//    [[_imageViewsMArray objectAtIndex:0] setBackground:[_proPicMArray objectAtIndex:0]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    endContentOffsetX = scrollView.contentOffset.x;
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) {
        //画面从右往左移动，前一页
        [self dynamicLoadingImageView];
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {
        //画面从左往右移动，后一页
        [self dynamicLoadingImageView];
    }
}

#pragma mark - 头部产品图片
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case WXGoodsDetail_Default:
            height = 68;
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case WXGoodsDetail_Default:{
            height = 5;
        }
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return WXGoodsDetail_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    switch (section) {
        case WXGoodsDetail_TopDisplay:
            break;
        case WXGoodsDetail_Default:{
            return 2;
        }
            break;
        default:
            break;
    }
    return row;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = NULL;
    switch (section) {
        case WXGoodsDetail_Default:{
            view = [self headerForProduct];
        }
            break;
        default:
            break;
    }
    return view;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    switch (section) {
        case WXGoodsDetail_Default:
            break;
            
        default:
            break;
    }
    return view;
}


-(UIView*)headerForProduct{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 83)];
    UILabel * lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 150, 18)];
    lbPrice.font = [UIFont systemFontOfSize:12];
    lbPrice.text = @"原价:337.00";
    [view addSubview:lbPrice];
    UILabel * lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 32, IPHONE_SCREEN_WIDTH, 36)];
    lbTitle.text = @"百达翡丽PATEKPHILIPPE复杂功能计时\n5180/1G-010自动机械表";
    lbTitle.numberOfLines = 2;
    lbTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    lbTitle.font = [UIFont systemFontOfSize:12];
    [view addSubview:lbTitle];
    
    CGFloat collectX = IPHONE_SCREEN_WIDTH-62+20;
    CGFloat collectY = (83-16)/2;
    UIButton * btnCollect = [[UIButton alloc]initWithFrame:CGRectMake(collectX, collectY, 17, 15)];
    [btnCollect setImage:[UIImage imageNamed:@"collect_normal"] forState:UIControlStateNormal];
    [btnCollect setImage:[UIImage imageNamed:@"collect_press"] forState:UIControlStateHighlighted];
    [btnCollect addTarget:self action:@selector(collectGoods) forControlEvents:UIControlEventTouchDragInside];
    [view addSubview:btnCollect];
    
    UILabel * lbCollect = [[UILabel alloc]initWithFrame:CGRectMake(collectX, collectY + 25, 36, 10)];
    lbCollect.text = @"收藏";
    lbCollect.font = [UIFont systemFontOfSize:11];
    [view addSubview:lbCollect];
    
    UIView * divideView = [[UIView alloc]initWithFrame:CGRectMake(0, 83, IPHONE_SCREEN_WIDTH, 0.5)];
    divideView.backgroundColor = WXColorWithInteger(0xdbdbdb);
    [view addSubview:divideView];
    return view;
}

-(void)collectGoods{
    NSLog(@"%s",__FUNCTION__);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case WXGoodsDetail_TopDisplay:{
            return 115;
        }
            break;/*
        case WXGoodsDetail_ProductTitle:{
            return 68;
        }
            break;*/
        case WXGoodsDetail_Default:{
            return 40;
        }
            break;
        default:{
            return 40;
        }
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    switch (indexPath.section) {
        case WXGoodsDetail_TopDisplay:{
            cell = [self createTopCell:tableView cellForRowAtIndexPath:indexPath];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
            break;/*
        case WXGoodsDetail_ProductTitle:{
        }
            break;*/
        case WXGoodsDetail_Default:{
            cell = [self createOptionsCell:tableView cellForRowAtIndexPath:indexPath];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(WXHomeTopGoodCell*)createTopCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    static NSString *identifier = @"TopIdentifier";
    WXHomeTopGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL) {
        _topProDisplay = [[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [_topProDisplay setBackgroundColor:[UIColor clearColor]];
//    [_topProDisplay setDelegate:self];
    [_topProDisplay load];
    return _topProDisplay;
}

-(GoodsDetailCell*)createOptionsCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    static NSString * identifier = @"OptionsIdentifier";
    GoodsDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL) {
        cell = [[GoodsDetailCell alloc]init];;
    }
    cell.ivTitle.image = [_picMArray objectAtIndex:indexPath.row];
    cell.lbTitle.text = [_dataMArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
