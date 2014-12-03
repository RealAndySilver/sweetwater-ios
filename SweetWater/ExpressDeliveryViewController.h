//
//  ExpressDeliveryViewController.h
//  SweetWater
//
//  Created by Andres Abril on 31/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSaver.h"
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MapDetailViewController.h"
@interface ExpressDeliveryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>{
    UITableView *tableview;
    
    NSString *nombre;
    NSString *telefono;
    NSString *direccion;
    NSString *latitud;
    NSString *longitud;
    NSString *indicacion;
    NSString *idvendedor;
    NSString *nombreVendedor;
    NSString *waterQuantity;
    NSString *iceQuantity;
    NSString *waterGalQuantity;
    NSString *littleIceQuantity;
    NSString *littleWaterQuantity;
    
    NSString *latitudPedido;
    NSString *longitudPedido;
    
    UITextField *tempTf;

    UIPickerView *waterQuantityPicker;
    UIPickerView *iceQuantityPicker;
    UIPickerView *waterGalQuantityPicker;
    UIPickerView *littleIceQuantityPicker;
    UIPickerView *littleWaterQuantityPicker;

    
    NSMutableArray *quantityArray;
    NSMutableArray *priorityArray;
    MBProgressHUD *hud;
    NSDictionary *userDic;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D zoomLocation;
}
@property(nonatomic,retain)NSArray *deliveryArray;
@property(nonatomic,retain)NSDictionary *userDic;
@end