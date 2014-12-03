//
//  CreateDeliveryViewController.h
//  SweetWater
//
//  Created by Andres Abril on 17/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "SearchUserViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CreateDeliveryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SearchUserViewControllerDelegate>{
    UITableView *tableview;
    
    NSString *userId;
    NSString *annotation;
    NSString *priority;
    NSString *deadline;
    NSString *waterQuantity;
    NSString *waterGalQuantity;
    NSString *iceQuantity;
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
-(void)userProcessed:(NSDictionary*)user;
@end
