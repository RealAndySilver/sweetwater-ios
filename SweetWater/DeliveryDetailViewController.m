//
//  DeliveryDetailViewController.m
//  SweetWater
//
//  Created by Andres Abril on 23/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "DeliveryDetailViewController.h"

@interface DeliveryDetailViewController ()

@end

@implementation DeliveryDetailViewController
@synthesize deliveryArray,userDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    
    userId=[userDic objectForKey:@"deliveryUserId"];
    annotation=[userDic objectForKey:@"deliveryAnnotation"];
    priority=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryPriority"]];
    deadline=[userDic objectForKey:@"deliveryDeadline"];
    waterQuantity=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryWaterQuantity"]];
    iceQuantity=[NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryIceQuantity"]];
    
    waterGalQuantity=[userDic objectForKey:@"deliveryWaterGalQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryWaterGalQuantity"]]:@"0";
    littleWaterQuantity=[userDic objectForKey:@"deliveryLittleWaterQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryLittleWaterQuantity"]]:@"0";
    littleIceQuantity=[userDic objectForKey:@"deliveryLittleIceQuantity"] ?
    [NSString stringWithFormat:@"%@",[userDic objectForKey:@"deliveryLittleIceQuantity"]]:@"0";
    
    
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
        return @"Detalle del Pedido";
    }

    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás ver todos los detalles del pedido activo.";
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 8;
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
        if (indexPath.row<=8) {
            UILabel *playerTextField = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            playerTextField.adjustsFontSizeToFitWidth = YES;
            playerTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0){
                playerTextField.text=annotation;
            }
            if ([indexPath row] == 1) {
                playerTextField.text=priority;
            }
            if ([indexPath row] == 2) {
                playerTextField.text=deadline;
            }
            if ([indexPath row] == 3) {
                playerTextField.text=waterQuantity;
            }
            if ([indexPath row] == 4) {
                playerTextField.text=iceQuantity;
            }
            if ([indexPath row] == 5) {
                playerTextField.text=waterGalQuantity;
            }
            if ([indexPath row] == 6) {
                playerTextField.text=littleWaterQuantity;
            }
            if ([indexPath row] == 7) {
                playerTextField.text=littleIceQuantity;
            }
            playerTextField.backgroundColor = [UIColor whiteColor];
            playerTextField.textAlignment = NSTextAlignmentCenter;
            
            [cell.contentView addSubview:playerTextField];
            cell.accessoryView=playerTextField;
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
    }
    
    return cell;
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

@end
