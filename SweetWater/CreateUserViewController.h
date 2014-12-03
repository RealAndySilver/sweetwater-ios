//
//  CreateUserViewController.h
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol CreateUserDelegate
@optional
-(void)userCreated:(NSDictionary*)userDic;
@end
@interface CreateUserViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    UITableView *tableview;
    
    NSString *nombre;
    NSString *telefono;
    NSString *direccion;
    NSString *latitud;
    NSString *longitud;
    NSString *indicacion;
    NSString *idvendedor;
    NSString *nombreVendedor;

    UITextField *tempTf;
    UIPickerView *vendorPicker;
    NSMutableArray *vendorsArray;
    MBProgressHUD *hud;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D zoomLocation;
    
    BOOL isComercial;

}
@property(nonatomic,retain)NSDictionary *propertiesDic;
@property(nonatomic)BOOL fromSearch;
@property(nonatomic,retain)id <CreateUserDelegate> delegate;

@end
