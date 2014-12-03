//
//  VendorListViewController.h
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "EditVendorViewController.h"
#import "MBProgressHud.h"
@interface VendorListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    NSMutableArray *vendorsArray;
    MBProgressHUD *hud;
}

@end
