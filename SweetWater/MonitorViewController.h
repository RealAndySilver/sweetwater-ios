//
//  MonitorViewController.h
//  SweetWater
//
//  Created by Andres Abril on 23/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "DeliveryListViewController.h"
#import "PossibleUserViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MonitorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSMutableArray *usersArray;
    NSMutableArray *dispatchedArray;
    MBProgressHUD *hud;
}
@property(nonatomic,retain)NSDictionary *vendorDic;
@end
