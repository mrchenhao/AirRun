//
//  MapViewDelegate.h
//  AirRun
//
//  Created by jasonWu on 4/1/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CustomAnnotation;
typedef void(^imgAnnotationTapBlock)(CustomAnnotation *annotation);

@interface MapViewDelegate : NSObject <MKMapViewDelegate>

@property (copy, nonatomic) imgAnnotationTapBlock imgAnnotationBlock;

- (instancetype)initWithMapView:(MKMapView *)mapView;

- (void)clearAnnotation;
- (void)addMaksGrayWorldOverlay;
- (void)drawLineWithPoints:(NSArray *)points;
- (void)drawGradientPolyLineWithPoints:(NSArray *)pointArray;
- (void)addImage:(UIImage *)image AtLocation:(CLLocation *)location;
- (void)drawPath:(NSArray *)path IsStart:(BOOL)start IsTerminate:(BOOL)terminate;
- (void)addimage:(UIImage *)image AnontationWithLocation:(CLLocation *)location;
- (void)zoomToFitMapPoints:(NSArray *)path;
- (UIImage *)captureMapView;

@end
