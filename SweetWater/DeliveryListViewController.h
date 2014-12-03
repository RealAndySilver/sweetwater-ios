//
//  DeliveryListViewController.h
//  SweetWater
//
//  Created by Andres Abril on 20/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "EditVendorViewController.h"
#import "MBProgressHud.h"
#import "EditDeliveryViewController.h"
#import "DeliveryDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapDetailViewController.h"
@interface DeliveryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CLLocationManagerDelegate>{
    UITableView *tableview;
    NSMutableArray *userArray;
    MBProgressHUD *hud;
    NSString *latitud;
    NSString *longitud;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D zoomLocation;
}
@property(nonatomic,retain)NSDictionary *userDic;
@property(nonatomic)BOOL notEditable;
@end
