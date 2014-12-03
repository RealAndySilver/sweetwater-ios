//
//  DataCollectorExclusiveViewController.h
//  SweetWater
//
//  Created by Andres Abril on 31/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ServerCommunicator.h"
#import "CreateVendorViewController.h"
#import "VendorListViewController.h"
#import "CreateUserViewController.h"
#import "UserListViewController.h"
#import "CreateDeliveryViewController.h"
#import "UserDeliveryListViewController.h"
#import "MonitorViewController.h"
#import "VendorExclusiveViewController.h"

@interface DataCollectorExclusiveViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSArray *crearArray;
    NSArray *editarArray;
    NSMutableArray *vendorsArray;
}

@end
