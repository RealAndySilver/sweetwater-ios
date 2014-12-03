//
//  MonitorViewController.m
//  SweetWater
//
//  Created by Andres Abril on 23/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "MonitorViewController.h"
#define MAP_SIZE 400
@interface MonitorViewController ()

@end

@implementation MonitorViewController
@synthesize vendorDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Monitorear"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    usersArray=[[NSMutableArray alloc]init];
    dispatchedArray=[[NSMutableArray alloc]init];
    [self loadVendor];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadUsers];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Información disponible:";
    }
    else if (section==1){
        return @"Clientes con pedidos activos asignados a este vendedor:";
    }
    else if (section==2){
        int hielo=0;
        int agua=0;
        int aguagalon=0;
        int aguapaq=0;
        int hielopeq=0;
        for (NSDictionary *dic in dispatchedArray) {
            agua += [[dic objectForKey:@"deliveryWaterQuantity"]intValue];
            hielo += [[dic objectForKey:@"deliveryIceQuantity"]intValue];
            aguagalon += [[dic objectForKey:@"deliveryWaterGalQuantity"]intValue];
            aguapaq += [[dic objectForKey:@"deliveryLittleWaterQuantity"]intValue];
            hielopeq += [[dic objectForKey:@"deliveryLittleIceQuantity"]intValue];
        }
        return [NSString stringWithFormat:@"Pedidos entregados hoy: %i\nTotal Agua: %i\nTotal Hielo: %i\nTotal Bolsa Galón: %i\nTotal Bolsa paq: %i\nTotal Hielo peq: %i",dispatchedArray.count,agua,hielo,aguagalon,aguapaq,hielopeq];
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás editar la información del cliente que selecciones.";
    }
    else if (section==1){
        return @"En esta sección podrás editar la información del cliente que selecciones.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 7;
    }
    else if (section==1){
        return [usersArray count];
    }
    else if (section==2){
        return [dispatchedArray count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==4) {
            return MAP_SIZE+40;
        }
        if (indexPath.row==6) {
            return 50;
        }
    }
    
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (indexPath.section==0){
        UILabel *accesoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 185, 30)];
        accesoryLabel.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
        if (indexPath.row==0) {
            cell.textLabel.text =@"Nombre:";
            accesoryLabel.text=[vendorDic objectForKey:@"vendorName"];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==1) {
            cell.textLabel.text = @"Correo:";
            accesoryLabel.text=[vendorDic objectForKey:@"vendorEmail"];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==2) {
            cell.textLabel.text = @"ID interno:";
            accesoryLabel.text=[vendorDic objectForKey:@"_id"];
            accesoryLabel.textColor=[UIColor redColor];
            accesoryLabel.font=[UIFont systemFontOfSize:12];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==3) {
            cell.textLabel.text = @"Activo:";
            accesoryLabel.text=[[vendorDic objectForKey:@"vendorIsActive"] boolValue] ? @"Si":@"No";
            accesoryLabel.textColor=[[vendorDic objectForKey:@"vendorIsActive"] boolValue] ? [UIColor greenColor]:[UIColor redColor];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==4){
            MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, MAP_SIZE)];
            [mapView setUserInteractionEnabled:NO];
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = [[vendorDic objectForKey:@"vendorLatitude"] floatValue];
            newRegion.center.longitude = [[vendorDic objectForKey:@"vendorLongitude"] floatValue];
            newRegion.span.latitudeDelta = 0.0025;
            newRegion.span.longitudeDelta = 0.0025;
            mapView.mapType=MKMapTypeHybrid;

            [mapView setRegion:newRegion animated:YES];
            
            UIView *center=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            center.backgroundColor=[UIColor blueColor];
            center.center=CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
            center.layer.cornerRadius=5;
            [mapView addSubview:center];
            
            UIFont *font=[UIFont systemFontOfSize:12];
            UIColor *textColor=[UIColor whiteColor];
            UIColor *backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
            UIView *infoBar=[[UIView alloc]initWithFrame:CGRectMake(20, mapView.frame.origin.y+mapView.frame.size.height, mapView.frame.size.width, 20)];
            infoBar.backgroundColor=backgroundColor;
            UILabel *carrier=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, (infoBar.frame.size.width/2)-5, 16)];
            carrier.backgroundColor=[UIColor clearColor];
            carrier.textColor=textColor;
            carrier.font=font;
            carrier.text=[NSString stringWithFormat:@"%@",[vendorDic objectForKey:@"carrier"]];
            [infoBar addSubview:carrier];
            
            
            UILabel *batterySection=[[UILabel alloc]initWithFrame:CGRectMake(infoBar.frame.size.width/2, 0, infoBar.frame.size.width/2, 20)];
            batterySection.backgroundColor=[UIColor clearColor];
            [infoBar addSubview:batterySection];
            
            UIView *batteryContainer=[[UILabel alloc]initWithFrame:CGRectMake(batterySection.frame.size.width-32, 4, 28, 12)];
            batteryContainer.backgroundColor=[UIColor clearColor];
            batteryContainer.layer.cornerRadius=2;
            batteryContainer.layer.borderColor=textColor.CGColor;
            batteryContainer.layer.borderWidth=1;
            [batterySection addSubview:batteryContainer];

            float batteryLevelFloat=[[vendorDic objectForKey:@"batteryLevel"] floatValue];
            float levelWidth=(batteryContainer.frame.size.width-4)*batteryLevelFloat;
            UIView *batteryLevel=[[UILabel alloc]initWithFrame:CGRectMake(2, 2, levelWidth, batteryContainer.frame.size.height-4)];
            if (batteryLevelFloat>=0.5) {
                batteryLevel.backgroundColor=[UIColor greenColor];
            }
            else if (batteryLevelFloat<0.5 && batteryLevelFloat>0.2) {
                batteryLevel.backgroundColor=[UIColor orangeColor];
            }
            else if (batteryLevelFloat<=0.2) {
                batteryLevel.backgroundColor=[UIColor redColor];
            }
            batteryLevel.layer.cornerRadius=1;
            [batteryContainer addSubview:batteryLevel];
            
            UILabel *batteryLevelText=[[UILabel alloc]initWithFrame:CGRectMake(batterySection.frame.size.width-32-batteryContainer.frame.size.width-6, 2, 40, 16)];
            batteryLevelText.backgroundColor=[UIColor clearColor];
            batteryLevelText.textColor=textColor;
            batteryLevelText.font=font;
            batteryLevelText.text=[NSString stringWithFormat:@"%.0f%%",(batteryLevelFloat*100)];
            [batterySection addSubview:batteryLevelText];
            
            [cell addSubview:mapView];
            [cell addSubview:infoBar];

        }
        else if (indexPath.row==5) {
            cell.textLabel.text = @"Fecha:";
            accesoryLabel.text=[vendorDic objectForKey:@"lastPositionDate"] ? [self dateConverterFromString:[vendorDic objectForKey:@"lastPositionDate"]]:@"No registra";
            accesoryLabel.font=[UIFont systemFontOfSize:12];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==6) {
//            cell.textLabel.text = @"Posibles clientes del día";
//            cell.selectionStyle=UITableViewCellSelectionStyleGray;
//            cell.textLabel.textAlignment=NSTextAlignmentCenter;
//            cell.textLabel.textColor=[UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1];
            UIButton *buttonNuevo=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonNuevo.frame=CGRectMake(10, 10, cell.frame.size.width-20, 30);
            //buttonNuevo.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
            [cell addSubview:buttonNuevo];
            [buttonNuevo setTitle:@"Posibles clientes del día" forState:UIControlStateNormal];
            [buttonNuevo setTitleColor:[UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:1] forState:UIControlStateNormal];
            [buttonNuevo setBackgroundColor:[UIColor clearColor]];
            [buttonNuevo setUserInteractionEnabled:NO];
            //[buttonNuevo addTarget:self action:@selector(createUserWithPreText) forControlEvents:UIControlEventTouchUpInside];
            buttonNuevo.layer.cornerRadius=3;
            buttonNuevo.layer.borderWidth=1;
            buttonNuevo.layer.borderColor=[UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:1].CGColor;
            [buttonNuevo setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
    }
    
    else if (indexPath.section==1){
        NSDictionary *dic=[usersArray objectAtIndex:indexPath.row];
        float priorityCounter=0;
        int i=0;
        for (NSDictionary *deliveryDic in [dic objectForKey:@"userDeliveries"]) {
            priorityCounter+=[[deliveryDic objectForKey:@"deliveryPriority"] floatValue];
            i++;
        }
        if (priorityCounter>0) {
            cell.textLabel.textColor=[UIColor colorWithRed:(1*(priorityCounter/i))/5 green:0 blue:0 alpha:1];
        }
        NSLog(@"Priority for this user is %f",priorityCounter/i);
        i=0;
        cell.textLabel.text = [dic objectForKey:@"userName"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"Pedidos Activos: %@",[dic objectForKey:@"userActiveDeliveries"]];
    }
    else if (indexPath.section==2){
        NSDictionary *dic=[dispatchedArray objectAtIndex:indexPath.row];
        NSDictionary *miniUser=[[dic objectForKey:@"deliveryDeliveredTo"] objectAtIndex:0];
        
        cell.textLabel.text = [miniUser objectForKey:@"userName"];
        //cell.detailTextLabel.text=[NSString stringWithFormat:@"Agua: %@ - Hielo: %@",[dic objectForKey:@"deliveryWaterQuantity"],[dic objectForKey:@"deliveryIceQuantity"]];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"A: %i - H: %i - BG: %i - BP: %i - HP: %i",[[dic objectForKey:@"deliveryWaterQuantity"]intValue],[[dic objectForKey:@"deliveryIceQuantity"]intValue],[[dic objectForKey:@"deliveryWaterGalQuantity"]intValue],[[dic objectForKey:@"deliveryLittleWaterQuantity"]intValue],[[dic objectForKey:@"deliveryLittleIceQuantity"]intValue]];
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"Deleting");
//        [self removeUser:usersArray[indexPath.row]];
//    }
//}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==6) {
            PossibleUserViewController *puVC=[[PossibleUserViewController alloc]init];
            puVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PossibleUser"];
            puVC.vendorDic=vendorDic;
            [self.navigationController pushViewController:puVC animated:YES];
        }
    }
    
    else if (indexPath.section==1) {
        DeliveryListViewController *udlVC=[[DeliveryListViewController alloc]init];
        udlVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryList"];
        udlVC.userDic=[usersArray objectAtIndex:indexPath.row];
        udlVC.notEditable=YES;
        [self.navigationController pushViewController:udlVC animated:YES];
        NSLog(@"Objeto tocado: %@",usersArray[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadUsers{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Clientes", nil);
    //FileSaver *file=[[FileSaver alloc]init];
    //NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[vendorDic objectForKey:@"_id"],[vendorDic objectForKey:@"vendorPassword"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetUsersForVendor" andParameter:params];
}
-(void)loadDispatched{
    NSString *params=[NSString stringWithFormat:@"%@",[vendorDic objectForKey:@"_id"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=4;
    [server callServerWithGETMethod:@"GetTodayDispatched" andParameter:params];
}
-(void)removeUser:(NSDictionary*)userDic{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Eliminando Cliente", nil);
    //FileSaver *file=[[FileSaver alloc]init];
    //NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"userId=%@",[userDic objectForKey:@"_id"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"DeleteUser" andParameter:params httpMethod:@"DELETE"];
}
-(void)loadVendor{
    NSString *params=[NSString stringWithFormat:@"%@/%@",[vendorDic objectForKey:@"vendorEmail"],[vendorDic objectForKey:@"vendorPassword"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.tag=3;
    server.caller=self;
    [server callServerWithGETMethod:@"GetVendor" andParameter:params];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        NSLog(@"Clientes:%@",server.dictionary);
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            usersArray=(NSMutableArray*)server.dictionary;
        }
        [tableview reloadData];
        [self performSelector:@selector(delayedHudHide) withObject:nil afterDelay:0.5];
        [self loadDispatched];
        return;
    }
    else if (server.tag==2){
        NSLog(@"Cliente borrado");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadUsers];
    }
    else if (server.tag==3){
        vendorDic=nil;
        vendorDic=server.dictionary;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else if (server.tag==4) {
        NSLog(@"Dispatched:%@",server.dictionary);
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            dispatchedArray=(NSMutableArray*)server.dictionary;
        }
        [tableview reloadData];
        return;
    }
    [tableview reloadData];
    
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
}
-(void)delayedHudHide{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - date converter
-(NSString*)dateConverterFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    NSLog(@"El date %@",dateFromString);
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter2 setDateFormat:@"dd 'de' MMMM, HH:mm"];
    NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
    return strDate;
}
@end