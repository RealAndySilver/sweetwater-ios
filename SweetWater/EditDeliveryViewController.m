//
//  EditDeliveryViewController.m
//  SweetWater
//
//  Created by Andres Abril on 20/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "EditDeliveryViewController.h"

@interface EditDeliveryViewController ()

@end

@implementation EditDeliveryViewController
@synthesize deliveryArray,userDic,userVendorId;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    
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
    
    //userDic=[deliveryArray objectAtIndex:0];
    
    userId=[userDic objectForKey:@"deliveryUserId"];
    annotation=[userDic objectForKey:@"deliveryAnnotation"];
    priority=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryPriority"]];
    deadline=[userDic objectForKey:@"deliveryDeadline"];
    waterQuantity=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryWaterQuantity"]];
    iceQuantity=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryIceQuantity"]];
    
    waterGalQuantity=[userDic objectForKey:@"deliveryWaterGalQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryWaterGalQuantity"]]:@"0";
    littleIceQuantity=[userDic objectForKey:@"deliveryLittleIceQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryLittleIceQuantity"]]:@"0";
    littleWaterQuantity=[userDic objectForKey:@"deliveryLittleWaterQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryLittleWaterQuantity"]]:@"0";
    
    NSLog(@"Diccionario %@",userDic);
    
}
-(void)viewWillAppear:(BOOL)animated{

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Editar Pedido";
    }
    else if (section==1){
        return @"Selecciona el cliente al cual quieres asignar el pedido:";
    }
    else if (section==2){
        return @"Información del cliente seleccionado:";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás actualizar el pedido activo.";
    }
    else if(section==1){
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 9;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath section] == 0) {
        if (indexPath.row<=7) {
            UITextField *playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0){
                playerTextField.placeholder = @"*alguna observación*";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyDone;
                    playerTextField.text=annotation;
            }
            if ([indexPath row] == 1) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=priorityPicker;
                playerTextField.text=priority;
            }
            if ([indexPath row] == 2) {
                playerTextField.placeholder = @"*Requerido*";
                playerTextField.keyboardType = UIKeyboardTypeAlphabet;
                playerTextField.returnKeyType = UIReturnKeyNext;
                playerTextField.inputView=datePicker;
                    playerTextField.text=deadline;
            }
            if ([indexPath row] == 3) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=waterQuantityPicker;
                    playerTextField.text=waterQuantity;
            }
            if ([indexPath row] == 4) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=iceQuantityPicker;
                    playerTextField.text=iceQuantity;
            }
            if ([indexPath row] == 5) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=waterGalQuantityPicker;
                playerTextField.text=waterGalQuantity;
            }
            if ([indexPath row] == 6) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=littleWaterQuantityPicker;
                playerTextField.text=littleWaterQuantity;
            }
            if ([indexPath row] == 7) {
                playerTextField.placeholder = @"0";
                playerTextField.inputView=littleIceQuantityPicker;
                playerTextField.text=littleIceQuantity;
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
        else if([indexPath row] == 8){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame=CGRectMake(200, 10, 90, 30);
            [button setTitle:@"Listo" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor greenColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(editar) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=button;
        }
    }

    if ([indexPath section] == 0) {
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
            cell.textLabel.text = @"Bolsa paq";
        }
        else if ([indexPath row] == 7){
            cell.textLabel.text = @"Hielo peq";
        }
        else if ([indexPath row] == 8){
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
            //deadline=textField.text;
        }
        else if (textField.tag==3) {
            waterQuantity=@"0";
        }
        else if (textField.tag==4) {
            iceQuantity=@"0";
        }
        else if (textField.tag==4) {
            waterGalQuantity=@"0";
        }
        else if (textField.tag==4) {
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

#pragma mark server request
-(void)editar{
    NSLog(@"Editar Pedido");
    [self dismissKeyboard];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Actualizando Pedido", nil);
//    FileSaver *file=[[FileSaver alloc]init];
//    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    NSLog(@"Dic Userx %@",userDic);
    NSString *params=[NSString stringWithFormat:@"deliveryId=%@&userId=%@&annotation=%@&priority=%@&deadline=%@&waterQuantity=%@&iceQuantity=%@&waterGalQuantity=%@&littleWaterQuantity=%@&littleIceQuantity=%@&userVendorId=%@",[userDic objectForKey:@"_id"],userId,annotation,priority,deadline,waterQuantity,iceQuantity,waterGalQuantity,littleWaterQuantity,littleIceQuantity,userVendorId];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"UpdateDelivery" andParameter:params httpMethod:@"PUT"];
    NSLog(@"Actualizar pedido: %@",params);
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
            NSString *message=@"Pedido actualizado correctamente";
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Éxito" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
