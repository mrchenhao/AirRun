//
//  RecordDetailViewController.m
//  AirRun
//
//  Created by JasonWu on 4/9/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "RecordDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewDelegate.h"
#import "RunningRecordEntity.h"
#import "DateHelper.h"
#import "RunningImageEntity.h"
#import "DocumentHelper.h"
#import "DateHelper.h"
#import "CustomAnnotation.h"
#import "EditImageView.h"
#import <objc/runtime.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ShareView.h"
#import "ImageHeler.h"
static const char *INDEX = "index";
@interface RecordDetailViewController ()<ShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *tempertureAndPMLable;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MapViewDelegate *mapViewDelegate;

@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLable;
@property (weak, nonatomic) IBOutlet UILabel *durationLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLable;
@property (weak, nonatomic) IBOutlet UILabel *kcalAppleLabel;



@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSArray *imgEntities;
@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self p_getData];
    [self p_setNavgation];
    [self p_layout];
    [self p_setMapView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)p_getData {
   
    NSData *arrayData = [_record.path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:arrayData options:NSJSONReadingMutableContainers error:nil];
    _path = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in dicArray) {
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
        CLLocation *loc = [[CLLocation alloc] initWithCoordinate:coordinate2D
                                                        altitude:[dic[@"altitude"] doubleValue]
                                              horizontalAccuracy:[dic[@"hAccuracy"] doubleValue]
                                                verticalAccuracy:[dic[@"vAccuracy"] doubleValue]
                                                          course:[dic[@"course"] doubleValue]
                                                           speed:[dic[@"speed"] doubleValue]
                                                       timestamp:[formatter dateFromString:dic[@"timestamp"]]];
        [_path addObject:loc];
    }
    
    _imgEntities = [RunningImageEntity getEntitiesWithArrtribut:@"recordid" WithValue:_record.identifer];
    
}

#pragma mark - Layout

- (void)p_setNavgation {
    
    self.title = @"详细记录";
    UIBarButtonItem *sharButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonTouch:)];
    self.navigationItem.rightBarButtonItem = sharButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg127"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)p_layout {
    _topView.layer.cornerRadius = 5;
    _cardView.layer.cornerRadius = 5;
    _cardView.layer.shadowOffset = CGSizeMake(1, 1);
    _cardView.layer.shadowRadius = 5;
    _cardView.layer.shadowOpacity = 0.5;
    
    _locationNameLabel.text = _record.city;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    _timeLable.text = [formatter stringFromDate:_record.finishtime];
    
    _tempertureAndPMLable.text = [NSString stringWithFormat:@"%@\nPM %ld",_record.weather,[_record.pm25 longValue]];
    
    _avgSpeedLable.text = [NSString stringWithFormat:@"%.1f",[_record.averagespeed floatValue]];
    _durationLable.text = [DateHelper converSecondsToTimeString:[_record.time integerValue]];
    _distanceLable.text = [NSString stringWithFormat:@"%.2f",[_record.distance floatValue]/1000];
    
    _kcalAppleLabel.text = _kaclText;
    [_kcalAppleLabel sizeToFit];
}

- (void)p_setMapView {
    _mapViewDelegate = [[MapViewDelegate alloc] initWithMapView:_mapView];
    _mapView.delegate = _mapViewDelegate;
    __weak RecordDetailViewController *this = self;
    _mapViewDelegate.imgAnnotationBlock = ^(CustomAnnotation *annotation){
        
        UIImage *img = annotation.image;
        NSInteger index = [objc_getAssociatedObject(img, INDEX) integerValue];
        
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        
         __block EditImageView *editImageView;
        
        [UIView transitionWithView:currentWindow
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            editImageView = [[EditImageView alloc] initWithImages:this.images InView:currentWindow Editeable:NO];
                        } completion:^(BOOL finished) {
                            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:this action:@selector(edieImageViewTap:)];
                            [editImageView addGestureRecognizer:tapGesture];
                            
                            editImageView.currentIndex = index;
                        }];
        
        
        
    };
    [_mapViewDelegate addMaksGrayWorldOverlay];
    [_mapViewDelegate drawPath:_path IsStart:YES IsTerminate:YES];
    [self p_addPhotoAnnotation];
    
}

#pragma mark - Action

- (void)p_addPhotoAnnotation {
    _images = [[NSMutableArray alloc] init];
    for (RunningImageEntity *imgEntity in _imgEntities) {
        NSString *imgName = [imgEntity.localpath lastPathComponent];
        UIImage *img = [UIImage imageWithContentsOfFile:[DocumentHelper documentsFile:imgName AtFolder:kPathImageFolder]];
        
        if (!img) {
            NSURL *requestURL = [[NSURL alloc] initWithString:imgEntity.remotepath];
            [[[UIImageView alloc] init] setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:requestURL]
                                              placeholderImage:nil
                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        
                                                           NSInteger idx = [_imgEntities indexOfObject:imgEntity];
                                                           objc_setAssociatedObject(img, INDEX, @(idx), OBJC_ASSOCIATION_ASSIGN);
                                                           CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
                                                           [_images insertObject:img atIndex:idx];
                                                           [_mapViewDelegate addimage:img AnontationWithLocation:loc];
                                                           
                                                       } failure:nil];
            continue;
            
        }
        
        NSInteger idx = [_imgEntities indexOfObject:imgEntity];
        objc_setAssociatedObject(img, INDEX, @(idx), OBJC_ASSOCIATION_ASSIGN);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[imgEntity.latitude doubleValue] longitude:[imgEntity.longitude doubleValue]];
        [_images insertObject:img atIndex:idx];
        [_mapViewDelegate addimage:img AnontationWithLocation:loc];
    }
    
}

#pragma mark - Event
#pragma mark Gesture event

- (void)edieImageViewTap:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view.superview;
    
    [UIView transitionWithView:view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [gesture.view removeFromSuperview];
                    } completion:nil];
    
    
}
#pragma mark Button event
- (void)shareButtonTouch:(UIBarButtonItem *)button {

    ShareView *share = [ShareView shareInstance];
    share.delegate  = self;
    [share showInView:self.view];
}
- (IBAction)foucsButtonTouch:(id)sender {
    [_mapViewDelegate zoomToFitMapPoints:_path];
}
- (IBAction)mapPhotoButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 10001) {
        [_mapViewDelegate deletePhotoAnnotation];
        button.tag = 10002;
    } else {
        [self p_addPhotoAnnotation];
        button.tag = 10001;
    }
    
}

#pragma mark Delegate 

- (void)shareview:(ShareView *)shareview didSelectButton:(ShareViewButtonType)buttonType
{
    if(buttonType == ShareViewButtonTypeWeiBo)
    {
        
    }
}
@end
