//
//  TimelineController.m
//  AirRun
//
//  Created by ChenHao on 4/4/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "TimelineController.h"
#import "UConstants.h"
#import "TimelineTableViewCell.h"
#import <BlurImageProcessor/ALDBlurImageProcessor.h>

@interface TimelineController ()

@property (nonatomic, strong) UIImageView *headerbackgroundImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *headerShadow;

@end

@implementation TimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"timelineCell";
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    RunningRecordModel *model = [[RunningRecordModel alloc] init];
    model.weather = @"dd";
    model.distance = 10000;
    model.averagespeed = 12.1;
    model.time = 1222;
    
    
    if (cell == nil) {
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer runningRecord:model];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *cell = (TimelineTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
    
    _headerbackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 200)];
    
    ALDBlurImageProcessor *blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage: [UIImage imageNamed:@"header1.jpg"]];

    [blurImageProcessor asyncBlurWithRadius:50 iterations:7 successBlock:^(UIImage *blurredImage) {
        [_headerbackgroundImageView setImage:blurredImage];
    } errorBlock:^(NSNumber *errorCode) {
        
    }];
    [header addSubview:_headerbackgroundImageView];
    
    _headerShadow= [[UIView alloc] initWithFrame: CGRectMake((Main_Screen_Width-80)/2, 50, 80, 80)];
    
    // setup shadow layer and corner
    _headerShadow.layer.shadowColor = [UIColor redColor].CGColor;
    _headerShadow.layer.shadowOffset = CGSizeMake(0, 1);
    _headerShadow.layer.shadowOpacity = 1;
    _headerShadow.layer.shadowRadius = 9.0;
    _headerShadow.layer.cornerRadius = 4.0;
    _headerShadow.clipsToBounds = NO;
    
    // combine the views
    [header addSubview: _headerShadow];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_headerImageView setImage:[UIImage imageNamed:@"header1.jpg"]];
    [[_headerImageView layer] setMasksToBounds:YES];
    [[_headerImageView layer] setCornerRadius:40.0];
    [[_headerImageView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[_headerImageView layer] setShadowColor:[UIColor redColor].CGColor];
    [[_headerImageView layer] setShadowRadius:20];
    [[_headerImageView layer] setShadowOpacity:1];
    
    [_headerShadow addSubview:_headerImageView];
    
    
    return header;
}



#pragma mark KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    else
    {
        [self scrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    if(offsetY < 0) {
        CGRect currentFrame = _headerbackgroundImageView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = 200+(-1)*offsetY;
        NSLog(@"height:%f", currentFrame.size.height);
        _headerbackgroundImageView.frame = currentFrame;
    }
    
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

@end
