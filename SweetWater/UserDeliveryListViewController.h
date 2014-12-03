//
//  UserDeliveryListViewController.h
//  SweetWater
//
//  Created by Andres Abril on 19/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "EditVendorViewController.h"
#import "MBProgressHud.h"
#import "EditUserViewController.h"
#import "DeliveryListViewController.h"
@interface UserDeliveryListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSMutableArray *usersArray;
    NSMutableArray *vendorsHierachyArray;
    NSMutableDictionary *vendorsHierachyDictionary;

    MBProgressHUD *hud;
}
@end
