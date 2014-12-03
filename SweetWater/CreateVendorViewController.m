//
//  CreateVendorViewController.m
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "CreateVendorViewController.h"

@interface CreateVendorViewController ()

@end

@implementation CreateVendorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    nombre=@"";
    email=@"";
    password=@"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Crear Vendedor";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás crear nuevos vendedores.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath section] == 0) {
            if (indexPath.row<=2) {
                UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
                playerTextField.adjustsFontSizeToFitWidth = YES;
                playerTextField.textColor = [UIColor blackColor];
                if ([indexPath row] == 0) {
                    playerTextField.placeholder = @"*Requerido*";
                    playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                    playerTextField.returnKeyType = UIReturnKeyDone;
                }
                else if ([indexPath row] == 1){
                    playerTextField.placeholder = @"*Requerido*";
                    playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                    playerTextField.returnKeyType = UIReturnKeyDone;
                }
                if ([indexPath row] == 2) {
                    playerTextField.placeholder = @"*Requerido*";
                    playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                    playerTextField.returnKeyType = UIReturnKeyNext;
                }
                [playerTextField setBorderStyle:UITextBorderStyleRoundedRect];
                playerTextField.backgroundColor = [UIColor whiteColor];
                playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                playerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
                playerTextField.textAlignment = NSTextAlignmentCenter;
                //playerTextField.delegate = self;
                playerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                playerTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
                [playerTextField setEnabled: YES];
                playerTextField.delegate=self;
                playerTextField.tag=indexPath.row;
                
                [cell.contentView addSubview:playerTextField];
                cell.accessoryView=playerTextField;
            }
            if([indexPath row] == 3){
                UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame=CGRectMake(200, 10, 90, 30);
                [button setTitle:@"Crear" forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor greenColor]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(crear) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView=button;
            }
        }
    }
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Nombre";
        }
        else if ([indexPath row] == 1){
            cell.textLabel.text = @"Email";
        }
        else if ([indexPath row] == 2){
            cell.textLabel.text = @"Contraseña";
        }
        else if ([indexPath row] == 3){
            cell.textLabel.text = @"";
        }
    }
    else { // Login button section
        cell.textLabel.text = @"Log in";
    }
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==0) {
        nombre=textField.text;
    }
    else if (textField.tag==1) {
        email=textField.text;
    }
    else if (textField.tag==2) {
        password=textField.text;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTf=textField;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)dismissKeyboard{
    [tempTf resignFirstResponder];
}

#pragma mark server request
-(void)crear{
    [self dismissKeyboard];
    NSLog(@"Crear");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Creando Vendedor", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    NSString *params=[NSString stringWithFormat:@"vendorName=%@&vendorEmail=%@&vendorPassword=%@&vendorAdminId=%@",nombre,email,password,adminId];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    [server callServerWithPOSTMethod:@"CreateVendor" andParameter:params httpMethod:@"POST"];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    NSLog(@"Response:%@",server.dictionary);
    if ([server.dictionary objectForKey:@"_id"]) {
        NSString *message=[NSString stringWithFormat:@"Nombre:%@\nEmail:%@\nContraseña:%@",[server.dictionary objectForKey:@"vendorName"],[server.dictionary objectForKey:@"vendorEmail"],[server.dictionary objectForKey:@"vendorPassword"]];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Vendedor Creado" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[server.dictionary objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
}
@end
