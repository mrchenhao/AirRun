//
//  CompleteDisplayCard.m
//  AirRun
//
//  Created by ChenHao on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "CompleteDisplayCard.h"
#import "UConstants.h"
#import "UIView+CHQuartz.h"
#import "MapViewDelegate.h"
#import <MapKit/MapKit.h>

@interface CompleteDisplayCard()<UIScrollViewDelegate>


@property (nonatomic, strong) UIView *titleView;
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MKMapView *mapView;


@property (nonatomic, strong) UIPageControl* pagecontrol;

@property (nonatomic, strong) UIView *speedAndTime;
@property (nonatomic, strong) UIView *distanceAndCarl;

@property (nonatomic, strong) UILabel *heartLabel;
@property (nonatomic, strong) UIButton *shareButton;


@property (nonatomic, strong) NSString *heart;//新的体会


@end

@implementation CompleteDisplayCard


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInit];
    }
    return self;
}


- (void)commomInit
{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), 50)];
    [self addSubview:_titleView];
    
    UIImageView *location = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    [location setFrame:CGRectMake(10, 10, 30, 30)];
    [_titleView addSubview:location];
    
    UILabel *degree = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self)/2+10, 10, 130, 30)];
    [degree setTextColor:[UIColor whiteColor]];
    [degree setText:@"24℃"];
    [degree setFont:[UIFont systemFontOfSize:16]];
    [_titleView addSubview:degree];
    
    
    UILabel *pm25 = [[UILabel alloc] init];
    [pm25 setTextColor:[UIColor whiteColor]];
    [pm25 setText:@"200"];
    [pm25 setFont:[UIFont boldSystemFontOfSize:16]];
    [pm25 sizeToFit];
    [pm25 setFrame:CGRectMake(WIDTH(self)-WIDTH(pm25)-10, 10, WIDTH(pm25), HEIGHT(pm25))];
    [_titleView addSubview:pm25];
    
    UILabel *pm25d = [[UILabel alloc] init];
    [pm25d setTextColor:[UIColor whiteColor]];
    [pm25d setText:@"PM"];
    [pm25d setFont:[UIFont systemFontOfSize:12]];
    [pm25d sizeToFit];
    [pm25d setFrame:CGRectMake(WIDTH(self)-WIDTH(pm25)-10, MaxY(pm25), WIDTH(pm25), HEIGHT(pm25d))];
    [pm25d setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:pm25d];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, MaxY(_titleView), WIDTH(self), 300)];
    [self addSubview:_mapView];
    
    _mapDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapDelegate;
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MaxY(_titleView), WIDTH(self), 300)];
//    [_scrollView setContentSize:CGSizeMake(WIDTH(self)*3, 300)];
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    _scrollView.scrollEnabled = YES;
//    _scrollView.pagingEnabled = YES; //使用翻页属性
//    _scrollView.bounces = NO;
//    
//    UIImageView *map = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.jpg"]];
//    [map setFrame:CGRectMake(0, 0, WIDTH(self), 300)];
//    
//    [_scrollView addSubview:map];
//    
//    [self addSubview:_scrollView];
    
    
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxY(_mapView), WIDTH(self), 20)];
    _pagecontrol.numberOfPages =3;
    _pagecontrol.alpha = 0;
    [self addSubview:_pagecontrol];
    
    _distanceAndCarl = [self creatDistance:@"3.45" andCarl:@"4000"];
    [_distanceAndCarl setFrame:CGRectMake(0, MaxY(_pagecontrol)+10, WIDTH(self), 50)];
    
    [self addSubview:_distanceAndCarl];
    
     _speedAndTime = [self creatSpeed:@"44.3" andTime:@"19:23"];
    [_speedAndTime setFrame:CGRectMake(0, MaxY(_distanceAndCarl)+15, WIDTH(self), 50)];
    
    [self addSubview:_speedAndTime];
    
    
}

- (UIView *)creatDistance:(NSString *)distance andCarl:(NSString *)carl
{
    
    UIView *view = [[UIView alloc] init];
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    [flag setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:distance];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+2, MaxY(distanceLabel), WIDTH(distanceLabel), 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"距离Km"];
    [km setTextAlignment:NSTextAlignmentCenter];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 20, 20)];
    
    [water setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:carl];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+2, MaxY(calLabel), WIDTH(calLabel), 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里Kcal"];
    [ca setTextAlignment:NSTextAlignmentCenter];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}


- (UIView *)creatSpeed:(NSString *)speed andTime:(NSString *)time
{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 20, 20)];
    
    [flag setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:flag];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+5, 0, 0, 0)];
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [distanceLabel setText:speed];
    [distanceLabel sizeToFit];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:distanceLabel];
    
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(flag)+2, MaxY(distanceLabel), WIDTH(distanceLabel), 14)];
    [km setFont:[UIFont boldSystemFontOfSize:12]];
    [km setText:@"距离Km"];
    [km setTextAlignment:NSTextAlignmentCenter];
    [km setTextColor:[UIColor whiteColor]];
    [view addSubview:km];
    
    
    UIImageView *water = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self)/2+30,  15, 20, 20)];
    
    [water setImage:[UIImage imageNamed:@"setting"]];
    [view addSubview:water];
    
    UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+5, 0, 0, 0)];
    [calLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [calLabel setText:time];
    [calLabel sizeToFit];
    [calLabel setTextColor:[UIColor whiteColor]];
    [view addSubview:calLabel];
    
    
    UILabel *ca = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(water)+2, MaxY(calLabel), WIDTH(calLabel), 14)];
    [ca setFont:[UIFont boldSystemFontOfSize:12]];
    [ca setText:@"卡路里Kcal"];
    [ca setTextAlignment:NSTextAlignmentCenter];
    [ca setTextColor:[UIColor whiteColor]];
    [view addSubview:ca];
    
    return view;
}

- (void)adjust:(NSString *)heart
{
    if (![heart isEqualToString:@""]) {
        if (_heartLabel==nil) {
            _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, MaxY(_speedAndTime)+10, WIDTH(self)-60, 30)];
        }
        _heart = heart;
        [_heartLabel setNumberOfLines:0];
        [_heartLabel setFont:[UIFont systemFontOfSize:12]];
        _heartLabel.text = heart;
        [_heartLabel setTextColor:[UIColor whiteColor]];
        [_heartLabel sizeToFit];
        [self addSubview:_heartLabel];
        
        UILabel *signname = [[UILabel alloc] initWithFrame:CGRectMake(40, MaxY(_heartLabel)+5, 100, 20)];
        [signname setFont:[UIFont systemFontOfSize:12]];
        [signname setTextColor:[UIColor whiteColor]];
        [signname setText:@"--Yeti"];
        [self addSubview:signname];
        
    }
    else
    {
        if (_heartLabel == nil) {
            _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(_speedAndTime)+10, 0, 0)];
        }
        _heartLabel.text = heart;
        [_heartLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_heartLabel];
    }
    
    if (_shareButton ==nil) {
        _shareButton = [[UIButton alloc] init];
    }
    [_shareButton setFrame:CGRectMake(0, 0, 140, 30)];
    _shareButton.center = CGPointMake(WIDTH(self)/2, MaxY(_heartLabel)+45);
    
    [_shareButton setTitle:@"分享跑步卡片" forState:UIControlStateNormal];
    [[_shareButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [_shareButton setBackgroundColor:RGBCOLOR(97, 187, 162)];
    [self addSubview:_shareButton];
    

    if (MaxY(_shareButton)+20>Main_Screen_Height+1) {
        [self setFrame:CGRectMake(10, 10, WIDTH(self), MaxY(_shareButton)+10)];
    }
    else
    {
        [self setFrame:CGRectMake(10, 10, WIDTH(self), Main_Screen_Height-20)];
       
    }
    
    [self setNeedsDisplay];
    
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    int page = _scrollView.contentOffset.x / WIDTH(self);
//    _pagecontrol.currentPage = page;
//}

- (void)drawRect:(CGRect)rect
{
    [self drawLineFrom:CGPointMake(20, MaxY(_distanceAndCarl)+7.5) to:CGPointMake(WIDTH(self)-20, MaxY(_distanceAndCarl)+7.5) color:RGBCOLOR(145, 194, 235) width:1];
    
    
    if (_heart !=nil) {
        [self drawLineFrom:CGPointMake(20, MaxY(_speedAndTime)+7.5) to:CGPointMake(WIDTH(self)-20, MaxY(_speedAndTime)+7.5) color:RGBCOLOR(145, 194, 235) width:1];
    }
    

}


@end
