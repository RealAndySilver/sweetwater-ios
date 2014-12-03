//
//  ViewController.m
//  SweetWater
//
//  Created by Andres Abril on 13/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    UITextField *usernameTF;
    UITextField *passwordTF;
}

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    FileSaver *file=[[FileSaver alloc]init];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor=[UIColor viewFlipsideBackgroundColor];
    UIView *textFieldContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    textFieldContainer.center=CGPointMake(self.view.frame.size.width/2, 180);
    textFieldContainer.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:textFieldContainer];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
    title.center=CGPointMake(textFieldContainer.frame.size.width/2, 60);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:30];
    title.text=@"Bienvenido";
    [textFieldContainer addSubview:title];
    usernameTF=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    usernameTF.center=CGPointMake(textFieldContainer.frame.size.width/2, 100);
    [usernameTF setBorderStyle:UITextBorderStyleNone];
    usernameTF.backgroundColor=[UIColor whiteColor];
    usernameTF.placeholder=@"nombre del cliente";
    usernameTF.text=@"";
    usernameTF.textAlignment=NSTextAlignmentCenter;
    usernameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    usernameTF.delegate=self;
    usernameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameTF.autocorrectionType =  UITextAutocorrectionTypeNo;
    passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    passwordTF.center=CGPointMake(textFieldContainer.frame.size.width/2, usernameTF.frame.origin.y+usernameTF.frame.size.height+20);
    [passwordTF setBorderStyle:UITextBorderStyleRoundedRect];
    passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTF.textAlignment=NSTextAlignmentCenter;
    passwordTF.placeholder=@"Contraseña";
    passwordTF.text=@"1234";
    passwordTF.secureTextEntry=YES;
    passwordTF.delegate=self;
    [textFieldContainer addSubview:usernameTF];
    [textFieldContainer addSubview:passwordTF];
    
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame=CGRectMake(0, 0, 200, 30);
    loginButton.center=CGPointMake(textFieldContainer.frame.size.width/2, passwordTF.frame.origin.y+passwordTF.frame.size.height+20);
    [loginButton setTitle:@"Entrar" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAsVendor) forControlEvents:UIControlEventTouchUpInside];
    [textFieldContainer addSubview:loginButton];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    if ([[file getDictionary:@"Admin"] objectForKey:@"_id"]) {
        [self decideInitialViewController:[file getDictionary:@"Admin"]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)dismissKeyboard{
    [usernameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
}
-(void)loginAsVendor{
    [self dismissKeyboard];
    NSLog(@"Login Vendor");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Verificando Datos", nil);
    NSString *params=[NSString stringWithFormat:@"%@/%@",usernameTF.text,passwordTF.text];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.tag=1;
    server.caller=self;
    [server callServerWithGETMethod:@"GetVendor" andParameter:params];
}
-(void)loginAsAdmin{
    NSLog(@"Login Admin");
    NSString *params=[NSString stringWithFormat:@"%@/%@",usernameTF.text,passwordTF.text];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.tag=2;
    server.caller=self;
    [server callServerWithGETMethod:@"GetAdmin" andParameter:params];
}
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    NSLog(@"Response:%@",server.dictionary);
    if ([server.dictionary objectForKey:@"_id"]) {
        FileSaver *file=[[FileSaver alloc]init];
        [file setDictionary:server.dictionary withKey:@"Admin"];
        [self decideInitialViewController:server.dictionary];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        if (server.tag==1) {
            [self loginAsAdmin];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[server.dictionary objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)decideInitialViewController:(NSDictionary*)dictionary{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([[dictionary objectForKey:@"type"]isEqualToString:@"admin"]) {
        MainMenuViewController *mmVC=[[MainMenuViewController alloc]init];
        mmVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
        [self.navigationController pushViewController:mmVC animated:YES];
    }
    else if ([[dictionary objectForKey:@"type"]isEqualToString:@"vendor"]) {
        FileSaver *file=[[FileSaver alloc]init];
        VendorExclusiveViewController *veVC=[[VendorExclusiveViewController alloc]init];
        veVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VendorExclusive"];
        veVC.vendorDic=[file getDictionary:@"Admin"];
        [self.navigationController pushViewController:veVC animated:YES];
    }
    else if ([[dictionary objectForKey:@"type"]isEqualToString:@"collector"]) {
        DataCollectorExclusiveViewController *veVC=[[DataCollectorExclusiveViewController alloc]init];
        veVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DataCollector"];
        [self.navigationController pushViewController:veVC animated:YES];
    }
}
@end
