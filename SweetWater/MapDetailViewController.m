//
//  MapDetailViewController.m
//  SweetWater
//
//  Created by Andres Abril on 5/11/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "MapDetailViewController.h"

@interface MapDetailViewController ()

@end

@implementation MapDetailViewController
@synthesize userDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
   
}
-(void)viewWillAppear:(BOOL)animated{
    mapView.mapType = MKMapTypeHybrid;
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([[userDic objectForKey:@"userLatitude"] floatValue], [[userDic objectForKey:@"userLongitude"] floatValue]);
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (coordinate, 50, 50);
    [mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = coordinate;
    annotationPoint.title = [userDic objectForKey:@"userIndication"];
    annotationPoint.subtitle = [userDic objectForKey:@"userName"];
    
    [mapView addAnnotation:annotationPoint];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
