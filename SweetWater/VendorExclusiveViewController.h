//
//  VendorExclusiveViewController.h
//  SweetWater
//
//  Created by Andres Abril on 29/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "DeliveryListViewController.h"
#import "LoginViewController.h"
#import "DeviceInfo.h"
#import "CreateUserViewController.h"
#import "UserListViewController.h"
#import "UserSearchViewController.h"

@interface VendorExclusiveViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    UITableView *tableview;
    NSMutableArray *usersArray;
    NSMutableArray *dispatchedArray;

    MBProgressHUD *hud;
    NSString *latitud;
    NSString *longitud;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D zoomLocation;
    int locationCounter;
    int maxLoopsForLocation;

}
@property(nonatomic,retain)NSDictionary *vendorDic;
@end