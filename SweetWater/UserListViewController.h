//
//  UserListViewController.h
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "EditVendorViewController.h"
#import "MBProgressHud.h"
#import "EditUserViewController.h"
@interface UserListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSMutableArray *usersArray;
    MBProgressHUD *hud;
}
@end
