//
//  MapDetailViewController.h
//  SweetWater
//
//  Created by Andres Abril on 5/11/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapDetailViewController : UIViewController{
    IBOutlet MKMapView *mapView;

}
@property(nonatomic,retain)NSDictionary *userDic;
@end
