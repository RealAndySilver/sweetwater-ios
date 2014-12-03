//
//  PossibleUserViewController.h
//  SweetWater
//
//  Created by Andres Abril on 31/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "EditVendorViewController.h"
#import "MBProgressHud.h"
#import "ExpressDeliveryViewController.h"
@interface PossibleUserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSMutableArray *usersArray;
    MBProgressHUD *hud;
}
@property(nonatomic,retain)NSDictionary *vendorDic;
@end
