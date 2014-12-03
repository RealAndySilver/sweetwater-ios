//
//  DeliveryDetailViewController.h
//  SweetWater
//
//  Created by Andres Abril on 23/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import <QuartzCore/QuartzCore.h>

@interface DeliveryDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    
    NSString *userId;
    NSString *annotation;
    NSString *priority;
    NSString *deadline;
    NSString *waterQuantity;
    NSString *iceQuantity;
    NSString *waterGalQuantity;
    NSString *littleIceQuantity;
    NSString *littleWaterQuantity;
    
    UITextField *tempTf;
    UIPickerView *waterQuantityPicker;
    UIPickerView *iceQuantityPicker;
    UIPickerView *priorityPicker;
    UIDatePicker *datePicker;
    NSMutableArray *quantityArray;
    NSMutableArray *priorityArray;
    MBProgressHUD *hud;
    NSDictionary *userDic;
}
@property(nonatomic,retain)NSArray *deliveryArray;
@property(nonatomic,retain)NSDictionary *userDic;


@end