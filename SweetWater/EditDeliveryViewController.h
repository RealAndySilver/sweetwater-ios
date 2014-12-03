//
//  EditDeliveryViewController.h
//  SweetWater
//
//  Created by Andres Abril on 20/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "SearchUserViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface EditDeliveryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
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
    UIPickerView *waterGalQuantityPicker;
    UIPickerView *littleIceQuantityPicker;
    UIPickerView *littleWaterQuantityPicker;
    
    UIPickerView *priorityPicker;
    UIDatePicker *datePicker;
    NSMutableArray *quantityArray;
    NSMutableArray *priorityArray;
    MBProgressHUD *hud;
    NSDictionary *userDic;
}
@property(nonatomic,retain)NSArray *deliveryArray;
@property(nonatomic,retain)NSDictionary *userDic;
@property(nonatomic,retain)NSString *userVendorId;


@end