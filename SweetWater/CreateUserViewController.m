//
//  CreateUserViewController.m
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "CreateUserViewController.h"

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController
@synthesize propertiesDic,delegate,fromSearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    isComercial=NO;
    
    vendorPicker=[[UIPickerView alloc]init];
    vendorPicker.dataSource=self;
    vendorPicker.delegate=self;
    vendorPicker.showsSelectionIndicator = YES;
    vendorPicker.tag=2005;
    UIView *container=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
    [container setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.9]];

    nombre=[propertiesDic objectForKey:@"nombre"] ? [propertiesDic objectForKey:@"nombre"]:@"No";
    telefono=[propertiesDic objectForKey:@"telefono"] ? [propertiesDic objectForKey:@"telefono"]:@"No";
    direccion=[propertiesDic objectForKey:@"direccion"] ? [propertiesDic objectForKey:@"direccion"]:@"No";
    indicacion=[propertiesDic objectForKey:@"indicacion"] ? [propertiesDic objectForKey:@"indicacion"]:@"No";
    latitud=@"No";
    longitud=@"No";
    idvendedor=@"No";
    nombreVendedor=@"No";
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    [self loadVendors];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Crear Cliente";
    }
    else if (section==1){
        return @"Editar";
    }
    else if (section==2){
        return @"Monitorear";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        //return @"En esta sección podrás crear nuevos vendedores, clientes, o pedidos.";
    }
    else if (section==1){
        return @"En esta sección podrás editar vendedores, clientes, o pedidos.";
    }
    else if (section==1){
        return @"En esta sección podrás revisar los pedidos pendientes para cada vendedor disponible.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 8;
    }
    else if (section==1){
    }
    else if (section==2){
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==6) {
        if ([latitud isEqualToString:@"No"]) {
            
        }
        else{
            return 225;
        }
    }
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath section] == 0) {
        if (indexPath.row<=4) {
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0) {
                playerTextField.placeholder = @"*Requerido*";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyDone;
                if (![nombre isEqualToString:@"No"]) {
                    playerTextField.text=nombre;
                }
            }
            else if ([indexPath row] == 1){
                playerTextField.placeholder = @"Ej: 6782567";
                playerTextField.keyboardType = UIKeyboardTypeNumberPad;
                playerTextField.returnKeyType = UIReturnKeyDone;
                if (![telefono isEqualToString:@"No"]) {
                    playerTextField.text=telefono;
                }
            }
            else if ([indexPath row] == 2) {
                playerTextField.placeholder = @"Ej: Calle 12 carrera 3a";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyNext;
                if (![direccion isEqualToString:@"No"]) {
                    playerTextField.text=direccion;
                }
            }
            else if ([indexPath row] == 3) {
                playerTextField.placeholder = @"Ej: Cerca al estadio";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyNext;
                if (![indicacion isEqualToString:@"No"]) {
                    playerTextField.text=indicacion;
                }
            }
            else if ([indexPath row] == 4) {
                playerTextField.placeholder = @"*Requerido*";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyNext;
                playerTextField.inputView=vendorPicker;
                if (![nombreVendedor isEqualToString:@"No"]) {
                    playerTextField.text=nombreVendedor;
                }
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
        else if ([indexPath row] == 5) {
            UISwitch *theSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(100, 50, 50, 30)];
            [theSwitch setOn:isComercial];
            [cell.contentView addSubview:theSwitch];
            [theSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=theSwitch;
        }
        else if([indexPath row] == 6){
            if ([latitud isEqualToString:@"No"]) {
                UIView *container=[[UIView alloc]initWithFrame:CGRectMake(110, 10, 185, 30)];
                container.backgroundColor=[UIColor clearColor];
                UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame=CGRectMake(0, 0, 185, 30);
                [container addSubview:button];
                [button setTitle:@"Capturar" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(capturarPosicion) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView=container;
            }
            else{
                UIView *container=[[UIView alloc]initWithFrame:CGRectMake(110, 10, 185, 220)];
                container.backgroundColor=[UIColor clearColor];
                UIButton *buttonCapturar=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                buttonCapturar.frame=CGRectMake(0, 0, 185, 30);
                [container addSubview:buttonCapturar];
                [buttonCapturar setTitle:@"Capturar" forState:UIControlStateNormal];
                [buttonCapturar addTarget:self action:@selector(capturarPosicion) forControlEvents:UIControlEventTouchUpInside];
                UIButton *buttonEliminar=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                buttonEliminar.frame=CGRectMake(0, 183, 185, 30);
                [container addSubview:buttonEliminar];
                [buttonEliminar setTitle:@"Eliminar" forState:UIControlStateNormal];
                [buttonEliminar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [buttonEliminar addTarget:self action:@selector(eliminarPosicion) forControlEvents:UIControlEventTouchUpInside];
                
                MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 33, container.frame.size.width, 150)];
                [mapView setUserInteractionEnabled:NO];
                mapView.mapType=MKMapTypeHybrid;
                MKCoordinateRegion newRegion;
                newRegion.center.latitude = [latitud doubleValue];
                newRegion.center.longitude = [longitud doubleValue];
                newRegion.span.latitudeDelta = 0.0025;
                newRegion.span.longitudeDelta = 0.0025;
                
                UIView *center=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
                center.backgroundColor=[UIColor blueColor];
                center.center=CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
                center.layer.cornerRadius=5;
                [mapView addSubview:center];
                
                [mapView setRegion:newRegion animated:YES];
                [container addSubview:mapView];
                cell.accessoryView=container;
            }
            
        }
        else if([indexPath row] == 7){
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
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"Nombre";
        }
        else if ([indexPath row] == 1){
            cell.textLabel.text = @"Teléfono";
        }
        else if ([indexPath row] == 2){
            cell.textLabel.text = @"Dirección";
        }
        else if ([indexPath row] == 3){
            cell.textLabel.text = @"Indicación";
        }
        else if ([indexPath row] == 4){
            cell.textLabel.text = @"Vendedor";
        }
        else if ([indexPath row] == 5){
            cell.textLabel.text = @"Comercial";
        }
        else if ([indexPath row] == 6){
            cell.textLabel.text = @"Posición";
        }
        else if ([indexPath row] == 7){
            cell.textLabel.text = @"";
        }
    }
    else { // Login button section
        cell.textLabel.text = @"Log in";
    }
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {

    if (textField.tag==0) {
        nombre=textField.text;
    }
    else if (textField.tag==1) {
        telefono=textField.text;
    }
    else if (textField.tag==2) {
        direccion=textField.text;
    }
    else if (textField.tag==3) {
        indicacion=textField.text;
    }
    else if (textField.tag==4) {
        
    }
    }
    else{
        if (textField.tag==0) {
            nombre=@"No";
        }
        else if (textField.tag==1) {
            telefono=@"No";
        }
        else if (textField.tag==2) {
            direccion=@"No";
        }
        else if (textField.tag==3) {
            indicacion=@"No";
        }
        else if (textField.tag==4) {
            
        }
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTf=textField;
    [self performSelector:@selector(delayed:) withObject:textField afterDelay:0.3];
}
-(void)delayed:(UITextField*)textField{
    NSLog(@"Delayed");
    CGRect textFieldRect = CGRectMake(0, 100, 320, 200);
    [tableview scrollRectToVisible:textFieldRect animated:YES];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)dismissKeyboard{
    [tempTf resignFirstResponder];
}

#pragma mark server request
-(void)loadVendors{
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[adminDic objectForKey:@"email"]? [adminDic objectForKey:@"email"]:[adminDic objectForKey:@"vendorEmail"],[adminDic objectForKey:@"password"]? [adminDic objectForKey:@"password"]:[adminDic objectForKey:@"vendorPassword"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetAllVendors" andParameter:params];
}
-(void)crear{
    NSLog(@"Crear");
    [self dismissKeyboard];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Creando Cliente", nil);
    //    FileSaver *file=[[FileSaver alloc]init];
    //    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    NSString *params=[NSString stringWithFormat:@"userName=%@&userPhone=%@&userAddress=%@&userIndication=%@&userLatitude=%@&userLongitude=%@&userVendorId=%@&userVendorName=%@&userIsActive=1&userBusiness=%i",nombre,telefono,direccion,indicacion,latitud,longitud,idvendedor,nombreVendedor,(int)isComercial];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"CreateUser" andParameter:params httpMethod:@"POST"];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            vendorsArray=(NSMutableArray*)server.dictionary;
        }
        [tableview reloadData];
    }
    else if (server.tag==2){
        NSLog(@"Response:%@",server.dictionary);
        if ([server.dictionary objectForKey:@"_id"]) {
            NSString *message=[NSString stringWithFormat:@"Nombre:%@\nTeléfono:%@\nDirección:%@\nVendedor:%@",[server.dictionary objectForKey:@"userName"],[server.dictionary objectForKey:@"userPhone"],[server.dictionary objectForKey:@"userAddress"],[server.dictionary objectForKey:@"userVendorId"]];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Cliente Creado" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            if (fromSearch) {
                [delegate userCreated:server.dictionary];
                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
            }
            else
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[server.dictionary objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
}
#pragma mark - picker delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return vendorsArray.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        NSDictionary *dic=[vendorsArray objectAtIndex:row];
        NSString *strRes=[dic objectForKey:@"vendorName"];
        return strRes;
    }
    else{
        return nil;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSDictionary *dic=[vendorsArray objectAtIndex:row];
        NSString *strRes=[dic objectForKey:@"vendorName"];
        tempTf.text=strRes;
        nombreVendedor=strRes;
        idvendedor=[dic objectForKey:@"_id"];
        return;
    }
    return;
}
#pragma mark - location update
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation{
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude = location.coordinate.longitude;
}
-(void)capturarPosicion{
    latitud=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
    longitud=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
    [tableview reloadData];
}
-(void)eliminarPosicion{
    latitud=@"No";
    longitud=@"No";
    [tableview reloadData];
}
#pragma mark - switch value changed
-(void)changeSwitch:(UISwitch*)theSwitch{
    isComercial=theSwitch.on;
    NSLog(@"El valor del switch es %i",(int)isComercial);
}
#pragma mark - keyboard events
- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [tableview setContentInset:edgeInsets];
        [tableview setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [tableview setContentInset:edgeInsets];
        [tableview setScrollIndicatorInsets:edgeInsets];
    }];
}
@end
