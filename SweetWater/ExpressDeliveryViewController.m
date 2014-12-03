//
//  ExpressDeliveryViewController.m
//  SweetWater
//
//  Created by Andres Abril on 31/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "ExpressDeliveryViewController.h"

@interface ExpressDeliveryViewController ()

@end

@implementation ExpressDeliveryViewController

@synthesize deliveryArray,userDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    
    nombre=[userDic objectForKey:@"userName"];
    telefono=[userDic objectForKey:@"userPhone"];
    direccion=[userDic objectForKey:@"userAddress"];
    indicacion=[userDic objectForKey:@"userIndication"];
    latitud=[userDic objectForKey:@"userLatitude"];
    longitud=[userDic objectForKey:@"userLongitude"];
    idvendedor=[userDic objectForKey:@"userVendorId"];
    nombreVendedor=[userDic objectForKey:@"userVendorName"];
    NSLog(@"Diccionario %@",userDic);
    
    quantityArray=[[NSMutableArray alloc]init];
    for (int i=0; i<100; i++) {
        NSString *value=[NSString stringWithFormat:@"%i",i];
        [quantityArray addObject:value];
    }
    waterQuantityPicker=[[UIPickerView alloc]init];
    waterQuantityPicker.dataSource=self;
    waterQuantityPicker.delegate=self;
    waterQuantityPicker.showsSelectionIndicator = YES;
    waterQuantityPicker.tag=2005;
    
    iceQuantityPicker=[[UIPickerView alloc]init];
    iceQuantityPicker.dataSource=self;
    iceQuantityPicker.delegate=self;
    iceQuantityPicker.showsSelectionIndicator = YES;
    iceQuantityPicker.tag=2006;
    
    waterGalQuantityPicker=[[UIPickerView alloc]init];
    waterGalQuantityPicker.dataSource=self;
    waterGalQuantityPicker.delegate=self;
    waterGalQuantityPicker.showsSelectionIndicator = YES;
    waterGalQuantityPicker.tag=2007;
    
    littleWaterQuantityPicker=[[UIPickerView alloc]init];
    littleWaterQuantityPicker.dataSource=self;
    littleWaterQuantityPicker.delegate=self;
    littleWaterQuantityPicker.showsSelectionIndicator = YES;
    littleWaterQuantityPicker.tag=2008;
    
    littleIceQuantityPicker=[[UIPickerView alloc]init];
    littleIceQuantityPicker.dataSource=self;
    littleIceQuantityPicker.delegate=self;
    littleIceQuantityPicker.showsSelectionIndicator = YES;
    littleIceQuantityPicker.tag=2009;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tap];
    
    latitudPedido=@"No";
    longitudPedido=@"No";
    waterQuantity=@"0";
    iceQuantity=@"0";
    waterGalQuantity=@"0";
    littleIceQuantity=@"0";
    littleWaterQuantity=@"0";
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Detalle del Cliente";
    }
    else if (section==1) {
        return @"Entrega Express";
    }
    
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"Estos fueron los detalles del Cliente";
    }
    else if (section==1) {
        return @"Si este cliente no tiene un pedido asignado en el sistema en esta sección podrá crear una entrega.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    else if (section==1){
        return 6;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==4) {
            return 200;
        }
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath section] == 0) {
        if (indexPath.row<=4) {
            UILabel *playerTextField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0){
                playerTextField.text=nombre;
            }
            if ([indexPath row] == 1) {
                playerTextField.text=telefono;
            }
            if ([indexPath row] == 2) {
                playerTextField.text=direccion;
            }
            if ([indexPath row] == 3) {
                playerTextField.text=indicacion;
            }
            if ([indexPath row] == 4) {
                MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 180)];
                [mapView setUserInteractionEnabled:NO];
                mapView.mapType=MKMapTypeHybrid;
                MKCoordinateRegion newRegion;
                newRegion.center.latitude = [latitud floatValue];
                newRegion.center.longitude = [longitud floatValue];
                newRegion.span.latitudeDelta = 0.0025;
                newRegion.span.longitudeDelta = 0.0025;
                
                [mapView setRegion:newRegion animated:YES];
                
                UIView *center=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
                center.backgroundColor=[UIColor blueColor];
                center.center=CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
                center.layer.cornerRadius=5;
                [mapView addSubview:center];
                
                [cell addSubview:mapView];
            }
            if (indexPath.row!=4) {
                playerTextField.backgroundColor = [UIColor whiteColor];
                playerTextField.textAlignment = NSTextAlignmentCenter;
                
                [cell.contentView addSubview:playerTextField];
                cell.accessoryView=playerTextField;
            }
        }
    }
    if ([indexPath section] == 1) {
        UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        playerTextField.adjustsFontSizeToFitWidth = YES;
        playerTextField.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"Agua";
            playerTextField.placeholder = @"0";
            playerTextField.inputView=waterQuantityPicker;
            playerTextField.text=waterQuantity;
        }
        else if ([indexPath row] == 1) {
            cell.textLabel.text = @"Hielo";
            playerTextField.placeholder = @"0";
            playerTextField.inputView=iceQuantityPicker;
            playerTextField.text=iceQuantity;
        }
        else if ([indexPath row] == 2) {
            cell.textLabel.text = @"Bolsa Galón";
            playerTextField.placeholder = @"0";
            playerTextField.inputView=waterGalQuantityPicker;
            playerTextField.text=waterGalQuantity;
        }
        else if ([indexPath row] == 3) {
            cell.textLabel.text = @"Bolsa paq";
            playerTextField.placeholder = @"0";
            playerTextField.inputView=littleWaterQuantityPicker;
            playerTextField.text=littleWaterQuantity;
        }
        else if ([indexPath row] == 4) {
            cell.textLabel.text = @"Hielo peq";
            playerTextField.placeholder = @"0";
            playerTextField.inputView=littleIceQuantityPicker;
            playerTextField.text=littleIceQuantity;
        }
        else if ([indexPath row] == 5){
            cell.textLabel.text = @"Entregar";
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame=CGRectMake(200, 10, 90, 30);
            [button setTitle:@"Entregar" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor greenColor]];
            [button addTarget:self action:@selector(entregarPedido:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=button;
        }
        if (indexPath.row!=5) {
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
        
        
    }
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0){
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
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Touched index %i",indexPath.row);
    if (indexPath.section==0){
        if (indexPath.row==4) {
            MapDetailViewController *mdVC=[[MapDetailViewController alloc]init];
            mdVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MapDetail"];
            mdVC.userDic=userDic;
            [self.navigationController pushViewController:mdVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - picker delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag>2004 && pickerView.tag<2010) {
        return quantityArray.count;
    }
    return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        NSString *strRes=[quantityArray objectAtIndex:row];
        return strRes;
    }
    else{
        return nil;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (pickerView.tag>2004 && pickerView.tag<2010) {
            NSString *strRes=[quantityArray objectAtIndex:row];
            tempTf.text=strRes;
            return;
        }
    }
    return;
    
}
#pragma mark - textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        if (textField.tag==0) {
            waterQuantity=textField.text;
        }
        else if (textField.tag==1) {
            iceQuantity=textField.text;
        }
        else if (textField.tag==2) {
            waterGalQuantity=textField.text;
        }
        else if (textField.tag==3) {
            littleWaterQuantity=textField.text;
        }
        else if (textField.tag==4) {
            littleIceQuantity=textField.text;
        }
    }
    else {
        if (textField.tag==0) {
            waterQuantity=@"0";
        }
        else if (textField.tag==1) {
            iceQuantity=@"0";
        }
        else if (textField.tag==2) {
            waterGalQuantity=@"0";
        }
        else if (textField.tag==3) {
            littleWaterQuantity=@"0";
        }
        else if (textField.tag==4) {
            littleIceQuantity=@"0";
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTf=textField;
    [self performSelector:@selector(delayed:) withObject:textField afterDelay:0.3];
}
-(void)delayed:(UITextField*)textField{
    NSLog(@"Delayed");
    CGRect textFieldRect = CGRectMake(0, tableview.frame.size.height, 320, 40);
    [tableview scrollRectToVisible:textFieldRect animated:YES];
}
-(void)dismissKeyboard{
    [tempTf resignFirstResponder];
}
#pragma mark - location update
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation{
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude = location.coordinate.longitude;
    latitudPedido=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
    longitudPedido=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
}
-(void)capturarPosicion{
    latitudPedido=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
    longitudPedido=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
    [tableview reloadData];
}
#pragma mark - acciones de pedido
-(void)entregarPedido:(UIButton*)button{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Entregar Pedido" message:@"Está seguro que desea crear este pedido y entregarlo? Esta acción no podrá deshacerse." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Entregar", nil];
    alert.tag=button.tag;
    [alert show];
}
-(void)alertaPedidoEntregado{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Pedido entregado" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //       Cancelar
    }
    else if (buttonIndex==1) {
        if (alertView.tag<1000) {
            // Aceptar
            [self entregarPedido];
        }
        else if(alertView.tag>=1000){
        }
    }
    
}
-(void)entregarPedido{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Entregando Pedido", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"adminId=%@&userId=%@&waterQuantity=%@&iceQuantity=%@&waterGalQuantity=%@&littleWaterQuantity=%@&littleIceQuantity=%@&deliveryLatitude=%@&deliveryLongitude=%@",[adminDic objectForKey:@"_id" ],[userDic objectForKey:@"_id"],waterQuantity,iceQuantity,waterGalQuantity,littleWaterQuantity,littleIceQuantity,latitudPedido,longitudPedido];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithPOSTMethod:@"CreateExpressDelivery" andParameter:params httpMethod:@"POST"];
    NSLog(@"Actualizar pedido: %@",params);
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (server.tag==1) {
        if ([[server.dictionary objectForKey:@"response"]isEqualToString:@"Ok"]) {
            [self alertaPedidoEntregado];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
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