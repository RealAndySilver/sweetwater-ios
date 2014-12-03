//
//  CreateDeliveryViewController.m
//  SweetWater
//
//  Created by Andres Abril on 17/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "CreateDeliveryViewController.h"

@interface CreateDeliveryViewController ()

@end

@implementation CreateDeliveryViewController
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
    
    
    userId=@"No";
    annotation=@"No";
    priority=@"0";
    deadline=@"0";
    waterQuantity=@"0";
    iceQuantity=@"0";
    waterGalQuantity=@"0";
    littleIceQuantity=@"0";
    littleWaterQuantity=@"0";
    
    quantityArray=[[NSMutableArray alloc]init];
    for (int i=0; i<100; i++) {
        NSString *value=[NSString stringWithFormat:@"%i",i];
        [quantityArray addObject:value];
    }
    priorityArray=[[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        NSString *value=[NSString stringWithFormat:@"%i",i];
        [priorityArray addObject:value];
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
    
    priorityPicker=[[UIPickerView alloc]init];
    priorityPicker.dataSource=self;
    priorityPicker.delegate=self;
    priorityPicker.showsSelectionIndicator = YES;
    priorityPicker.tag=2010;
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 325, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];    
    [datePicker addTarget:self
                   action:@selector(assignDate)
         forControlEvents:UIControlEventValueChanged];
}
-(void)viewWillAppear:(BOOL)animated{
    if (userDic) {
        [tableview reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [tableview scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (userDic) {
        return 3;
    }
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"Crear Pedido";
    }
    else if (section==0){
        return @"Selecciona el cliente al cual quieres asignar el pedido:";
    }
    else if (section==2){
        return @"Información del cliente seleccionado:";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==1) {
        return @"En esta sección podrás crear nuevos pedidos y asignarlos a un cliente existente.";
    }
    else if(section==0){
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 8;
    }
    else if (section==0) {
        return userDic ? 2:1;
    }
    else if (section==2) {
        return 7;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        if (indexPath.row==5) {
            if (![[userDic objectForKey:@"userLatitude"] isEqualToString:@"No"]) {
                return 200;
            }
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
    if ([indexPath section] == 1) {
        if (indexPath.row<=7) {
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0){
                playerTextField.placeholder = @"*alguna observación*";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyDone;
                if (userDic && ![annotation isEqualToString:@"No"]) {
                    playerTextField.text=annotation;
                }
            }
            if ([indexPath row] == 1) {
                playerTextField.placeholder = @"Nivel de prioridad";
                playerTextField.placeholder = @"0";
                playerTextField.inputView=priorityPicker;
                if (userDic && ![priority isEqualToString:@"0"]) {
                    playerTextField.text=priority;
                }
            }
            if ([indexPath row] == 2) {
                playerTextField.placeholder = @"(Opcional)";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyNext;
                playerTextField.inputView=datePicker;
                if (userDic && ![deadline isEqualToString:@"No"]) {
                    playerTextField.text=deadline;
                }
            }
            if ([indexPath row] == 3) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=waterQuantityPicker;
                if (userDic && ![waterQuantity isEqualToString:@"0"]) {
                    playerTextField.text=waterQuantity;
                }
            }
            if ([indexPath row] == 4) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=iceQuantityPicker;
                if (userDic && ![iceQuantity isEqualToString:@"0"]) {
                    playerTextField.text=iceQuantity;
                }
            }
            if ([indexPath row] == 5) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=waterGalQuantityPicker;
                if (userDic && ![waterGalQuantity isEqualToString:@"0"]) {
                    playerTextField.text=waterGalQuantity;
                }
            }
            if ([indexPath row] == 6) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=littleWaterQuantityPicker;
                if (userDic && ![littleWaterQuantity isEqualToString:@"0"]) {
                    playerTextField.text=littleWaterQuantity;
                }
            }
            if ([indexPath row] == 7) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=littleIceQuantityPicker;
                if (userDic && ![littleIceQuantity isEqualToString:@"0"]) {
                    playerTextField.text=littleIceQuantity;
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
    }
    else if (indexPath.section==0){
        if([indexPath row] == 0){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame=CGRectMake(200, 10, 90, 30);
            if (userDic) {
                [button setTitle:@"Cambiar" forState:UIControlStateNormal];
            }
            else{
                [button setTitle:@"Seleccionar" forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(seleccionarUsuario) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=button;
        }
    }
    else if (indexPath.section==2){
        if (indexPath.row<=4) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            UILabel *accesoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 185, 30)];
            accesoryLabel.backgroundColor=[UIColor clearColor];
            NSString *text=@"";
            if ([indexPath row] == 0) {
                text=[userDic objectForKey:@"userName"];
            }
            else if ([indexPath row] == 1){
                text=[userDic objectForKey:@"userPhone"];
            }
            if ([indexPath row] == 2) {
                text=[userDic objectForKey:@"userAddress"];
            }
            if ([indexPath row] == 3) {
                text=[userDic objectForKey:@"userIndication"];
            }
            if ([indexPath row] == 4) {
                text=[userDic objectForKey:@"userVendorName"];
            }
            accesoryLabel.text=text;
            cell.accessoryView=accesoryLabel;
        }
        else if([indexPath row] == 5){
            if (![[userDic objectForKey:@"userLatitude"] isEqualToString:@"No"]) {
                MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(110, 10, 185, 180)];
                [mapView setUserInteractionEnabled:NO];
                mapView.mapType=MKMapTypeHybrid;
                MKCoordinateRegion newRegion;
                newRegion.center.latitude = [[userDic objectForKey:@"userLatitude"] floatValue];
                newRegion.center.longitude = [[userDic objectForKey:@"userLongitude"] floatValue];
                newRegion.span.latitudeDelta = 0.0025;
                newRegion.span.longitudeDelta = 0.0025;
                
                [mapView setRegion:newRegion animated:YES];
                
                UIView *center=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
                center.backgroundColor=[UIColor blueColor];
                center.center=CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
                center.layer.cornerRadius=5;
                [mapView addSubview:center];
                
                cell.accessoryView=mapView;
            }
            
        }
        else if([indexPath row] == 6){
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
    if ([indexPath section] == 1) {
        if ([indexPath row] == 0){
            cell.textLabel.text = @"Anotación";
        }
        else if ([indexPath row] == 1){
            cell.textLabel.text = @"Prioridad";
        }
        else if ([indexPath row] == 2){
            cell.textLabel.text = @"Entrega";
        }
        else if ([indexPath row] == 3){
            cell.textLabel.text = @"Agua";
        }
        else if ([indexPath row] == 4){
            cell.textLabel.text = @"Hielo";
        }
        else if ([indexPath row] == 5){
            cell.textLabel.text = @"Bolsa Galón";
        }
        else if ([indexPath row] == 6){
            cell.textLabel.text = @"Bolsa Paq";
        }
        else if ([indexPath row] == 7){
            cell.textLabel.text = @"Hielo Peq";
        }
    }
    else if ([indexPath section] == 0) {
        if ([indexPath row] == 0){
            cell.textLabel.text = @"Cliente";
        }
        else if ([indexPath row] == 1){
            cell.textLabel.text = [userDic objectForKey:@"userIndication"];;
        }
    }
    else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Nombre:";
        }
        else if ([indexPath row] == 1){
            cell.textLabel.text = @"Teléfono:";
        }
        else if ([indexPath row] == 2){
            cell.textLabel.text = @"Dirección:";
        }
        else if ([indexPath row] == 3){
            cell.textLabel.text = @"Indicación:";
        }
        else if ([indexPath row] == 4){
            cell.textLabel.text = @"Vendedor:";
        }
        else if ([indexPath row] == 5){
            cell.textLabel.text = @"Posición:";
        }
        else if ([indexPath row] == 6){
            cell.textLabel.text = @"";
        }
    }
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        if (textField.tag==0) {
            annotation=textField.text;
        }
        else if (textField.tag==1) {
            priority=textField.text;
        }
        else if (textField.tag==2) {
            //deadline=textField.text;
        }
        else if (textField.tag==3) {
            waterQuantity=textField.text;
        }
        else if (textField.tag==4) {
            iceQuantity=textField.text;
        }
        else if (textField.tag==5) {
            waterGalQuantity=textField.text;
        }
        else if (textField.tag==6) {
            littleWaterQuantity=textField.text;
        }
        else if (textField.tag==7) {
            littleIceQuantity=textField.text;
        }
    }
    else {
        if (textField.tag==0) {
            annotation=@"No";
        }
        else if (textField.tag==1) {
            priority=@"0";
        }
        else if (textField.tag==2) {
            deadline=@"0";
        }
        else if (textField.tag==3) {
            waterQuantity=@"0";
        }
        else if (textField.tag==4) {
            iceQuantity=@"0";
        }
        else if (textField.tag==5) {
            waterGalQuantity=@"0";
        }
        else if (textField.tag==6) {
            littleWaterQuantity=@"0";
        }
        else if (textField.tag==7) {
            littleIceQuantity=@"0";
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTf=textField;
    //    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    //    [tableview scrollToRowAtIndexPath:[tableview indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)assignDate{
    NSDate *fecha = [datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd hh:mm"];
    [tempTf setText:[df stringFromDate:fecha]];
    deadline=[NSString stringWithFormat:@"%@",[df stringFromDate:fecha]];
}
-(NSString*)secondsToDateString:(NSString*)seconds{
    NSTimeInterval interval=[seconds doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/YYYY"];
    NSString *result=[df stringFromDate:date];
    return result;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITextField *tf=(UITextField*)[tableView cellForRowAtIndexPath:indexPath].accessoryView;
    //NSLog(@"Texto interior %@",tf.text);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)dismissKeyboard{
    [tempTf resignFirstResponder];
}
#pragma mark button actions
-(void)seleccionarUsuario{
    SearchUserViewController *suVC=[[SearchUserViewController alloc]init];
    suVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchUser"];
    [self.navigationController pushViewController:suVC animated:YES];
    suVC.delegate=self;
    [self dismissKeyboard];
}
#pragma mark server request
-(void)crear{
    NSLog(@"Crear Pedido");
    [self dismissKeyboard];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Creando Pedido", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    
//deliveryAdminId:req.body.adminId,
//deliveryUserId:req.body.userId,
//deliveryAnnotation: req.body.annotation,
//deliveryPriority: req.body.priority,
//deliveryIsDelivered: req.body.isDelivered,
//deliveryCreationDate: nowDate,
//deliveryDeadline: req.body.deadline,
//deliveryWaterQuantity:req.body.waterQuantity,
//deliveryIceQuantity:req.body.iceQuantity
    
    NSString *params=[NSString stringWithFormat:@"adminId=%@&userId=%@&annotation=%@&priority=%@&isDelivered=0&deadline=%@&waterQuantity=%@&iceQuantity=%@&waterGalQuantity=%@&littleWaterQuantity=%@&littleIceQuantity=%@",adminId,userId,annotation,priority,deadline,waterQuantity,iceQuantity,waterGalQuantity,littleWaterQuantity,littleIceQuantity];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"CreateDelivery" andParameter:params httpMethod:@"POST"];
    NSLog(@"Crear pedido: %@",params);
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        /*for (int i=0; i<tempKeyArray.count; i++) {
         [vendorsArray addObject:[tempKeyArray objectAtIndex:i]];
         }*/
        [tableview reloadData];
    }
    else if (server.tag==2){
        NSLog(@"Response:%@",server.dictionary);
        if ([server.dictionary objectForKey:@"_id"]) {
            NSString *message=[NSString stringWithFormat:@"Nombre:%@\nTeléfono:%@\nDirección:%@\nVendedor:%@",[server.dictionary objectForKey:@"userName"],[server.dictionary objectForKey:@"userPhone"],[server.dictionary objectForKey:@"userAddress"],[server.dictionary objectForKey:@"userVendorId"]];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Pedido creado y asignado a:" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
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
    if (pickerView.tag>2004 && pickerView.tag<2010) {
        return quantityArray.count;
    }
    else if (pickerView.tag==2010){
        return priorityArray.count;
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
        else if (pickerView.tag==2010){
            NSString *strRes=[priorityArray objectAtIndex:row];
            tempTf.text=strRes;
            return;
        }
        
    }
    return;
    
}
#pragma mark Search User delegate method
-(void)userProcessed:(NSDictionary *)user{
    userDic=user;
    userId=[user objectForKey:@"_id"];
    NSLog(@"USER DELEGATED:%@",user);
}
@end
