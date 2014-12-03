//
//  ViewController.h
//  SweetWater
//
//  Created by Andres Abril on 13/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "FileSaver.h"
#import "MainMenuViewController.h"
#import "DataCollectorExclusiveViewController.h"
#import "MBProgressHud.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    MBProgressHUD *hud;
}

@end
