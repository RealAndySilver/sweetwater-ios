//
//  CreateVendorViewController.h
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
@interface CreateVendorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *tableview;
    
    NSString *nombre;
    NSString *email;
    NSString *password;
    
    UITextField *tempTf;
    MBProgressHUD *hud;
}
@end
