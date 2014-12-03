//
//  UserSearchViewController.h
//  SweetWater
//
//  Created by Andres Abril on 11/10/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ServerCommunicator.h"
#import "MBProgressHud.h"
#import "FileSaver.h"
#import "EditUserViewController.h"
#import "ExpressDeliveryViewController.h"
@interface UserSearchViewController : UIViewController<UITextFieldDelegate,UISearchBarDelegate,UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>{
    IBOutlet UITableView *tableview;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIView *headerContainer;
    IBOutlet UISearchDisplayController *searchDisplayController;
    IBOutlet UISearchBar *leftSearchBar;
    
    NSArray *staticArray;
    NSMutableArray *usersArray;
    NSMutableArray *arrayNombres;
    NSMutableArray *arrayTelefonos;
    NSMutableArray *arrayIndicaciones;
    NSMutableArray *arrayDirecciones;
    
    MBProgressHUD *hud;
}
@property (nonatomic) BOOL esExpress;
@end
