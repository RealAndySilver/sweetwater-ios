//
//  VendorExclusiveViewController.m
//  SweetWater
//
//  Created by Andres Abril on 29/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "VendorExclusiveViewController.h"
#define MAP_SIZE 400

@interface VendorExclusiveViewController ()

@end

@implementation VendorExclusiveViewController
@synthesize vendorDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Salir"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(logout)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Recargar"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(update)];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationItem.rightBarButtonItem=rightButton;

    [self.navigationItem setHidesBackButton:YES];
    [self setTitle:@"Pedidos"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    latitud=@"No";
    longitud=@"No";
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    locationCounter=0;
    maxLoopsForLocation=3;
    [self performSelector:@selector(beginLocationForSendingRequest) withObject:nil afterDelay:3];
    [self.view addSubview:tableview];
    usersArray=[[NSMutableArray alloc]init];
    dispatchedArray=[[NSMutableArray alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:@"notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"update" object:nil];

}
-(void)viewDidAppear:(BOOL)animated{
    [self loadUsers];
}
-(void)beginLocationForSendingRequest{
    [locationManager startUpdatingLocation];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Crear y editar clientes";
    }
    else if (section==1){
        return @"Información disponible:";
    }
    else if (section==2){
        return [NSString stringWithFormat:@"Clientes con pedidos activos: %i",usersArray.count];
    }
    else if (section==3){
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
        return @"";
    }
    else if (section==1){
        return @"";
    }
    else if (section==2){
        return @"";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    else if (section==1){
        return 4;
    }
    else if (section==2){
        return [usersArray count];
    }
    else if (section==3){
        return [dispatchedArray count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==5) {
            return MAP_SIZE+20;
        }
        else if (indexPath.row==2 || indexPath.row==3) {
            return 50;
        }
    }
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text =@"Crear Cliente";
        }
        else if (indexPath.row==1) {
            cell.textLabel.text = @"Editar Cliente";
        }
    }
    else if (indexPath.section==1){
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
//            cell.textLabel.text = @"Posibles clientes del día";
//            cell.selectionStyle=UITableViewCellSelectionStyleGray;
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
        else if (indexPath.row==3) {
            //            cell.textLabel.text = @"Posibles clientes del día";
            //            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            UIButton *buttonNuevo=[UIButton buttonWithType:UIButtonTypeCustom];
            buttonNuevo.frame=CGRectMake(10, 10, cell.frame.size.width-20, 30);
            //buttonNuevo.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
            [cell addSubview:buttonNuevo];
            [buttonNuevo setTitle:@"Entrega Express" forState:UIControlStateNormal];
            [buttonNuevo setTitleColor:[UIColor colorWithRed:0.1 green:1 blue:0.1 alpha:1] forState:UIControlStateNormal];
            [buttonNuevo setBackgroundColor:[UIColor clearColor]];
            [buttonNuevo setUserInteractionEnabled:NO];
            //[buttonNuevo addTarget:self action:@selector(createUserWithPreText) forControlEvents:UIControlEventTouchUpInside];
            buttonNuevo.layer.cornerRadius=3;
            buttonNuevo.layer.borderWidth=1;
            buttonNuevo.layer.borderColor=[UIColor colorWithRed:0.1 green:1 blue:0.1 alpha:1].CGColor;
            [buttonNuevo setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        else if (indexPath.row==4) {
            cell.textLabel.text = @"ID interno:";
            accesoryLabel.text=[vendorDic objectForKey:@"_id"];
            accesoryLabel.textColor=[UIColor redColor];
            accesoryLabel.font=[UIFont systemFontOfSize:12];
            cell.accessoryView=accesoryLabel;
        }
        
        else if (indexPath.row==4) {
            cell.textLabel.text = @"Activo:";
            accesoryLabel.text=[[vendorDic objectForKey:@"vendorIsActive"] boolValue] ? @"Si":@"No";
            accesoryLabel.textColor=[[vendorDic objectForKey:@"vendorIsActive"] boolValue] ? [UIColor greenColor]:[UIColor redColor];
            cell.accessoryView=accesoryLabel;
        }
        else if (indexPath.row==5){
            MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(10, 10, 300, MAP_SIZE)];
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
            
            [cell addSubview:mapView];
        }
        else if (indexPath.row==6) {
//            cell.textLabel.text = @"Fecha mapa:";
//            accesoryLabel.text=[vendorDic objectForKey:@"lastPositionDate"] ? [vendorDic objectForKey:@"lastPositionDate"]:@"No registra";
//            accesoryLabel.font=[UIFont systemFontOfSize:12];
//            cell.accessoryView=accesoryLabel;
            
        }
    }
    
    else if (indexPath.section==2){
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
    
    else if (indexPath.section==3){
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
        if (indexPath.row==0) {
            CreateUserViewController *cuVC=[[CreateUserViewController alloc]init];
            cuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateUser"];
            [self.navigationController pushViewController:cuVC animated:YES];
        }
        else if (indexPath.row==1) {
//            UserListViewController *ulVC=[[UserListViewController alloc]init];
//            ulVC=[self.storyboard instantiateViewControllerWithIdentifier:@"UserList"];
//            [self.navigationController pushViewController:ulVC animated:YES];
            
            UserSearchViewController *ulVC=[[UserSearchViewController alloc]init];
            ulVC=[self.storyboard instantiateViewControllerWithIdentifier:@"UserList"];
            [self.navigationController pushViewController:ulVC animated:YES];
        }
    }
    
    else if (indexPath.section==1) {
        if (indexPath.row==2) {
            PossibleUserViewController *puVC=[[PossibleUserViewController alloc]init];
            puVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PossibleUser"];
            puVC.vendorDic=vendorDic;
            [self.navigationController pushViewController:puVC animated:YES];
        }
        else if (indexPath.row==3) {
            UserSearchViewController *ulVC=[[UserSearchViewController alloc]init];
            ulVC=[self.storyboard instantiateViewControllerWithIdentifier:@"UserList"];
            ulVC.esExpress=YES;
            [self.navigationController pushViewController:ulVC animated:YES];
        }
    }
    
    else if (indexPath.section==2) {
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
-(void)updateVendorInfo{
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"vendorId=%@&vendorPassword=%@&vendorToken=%@&vendorLatitude=%@&vendorLongitude=%@&batteryLevel=%@&batteryState=%@&discSpace=%@&carrier=%@&deviceModel=%@&deviceName=%@&systemVersion=%@",
                      [adminDic objectForKey:@"_id"],
                      [adminDic objectForKey:@"vendorPassword"],
                      [file getToken],
                      latitud,
                      longitud,
                      [DeviceInfo getBatteryLevel],
                      [DeviceInfo getBatteryState],
                      [[DeviceInfo freeDiskspace]objectForKey:@"FreeSpace"],
                      [DeviceInfo getCarrier],
                      [DeviceInfo getModel],
                      [DeviceInfo getDeviceName],
                      [DeviceInfo getSystemVersion]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=3;
    [server callServerWithPOSTMethod:@"UpdateVendorInfo" andParameter:params httpMethod:@"PUT"];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        NSLog(@"Clientes:%@",server.dictionary);
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            usersArray=(NSMutableArray*)server.dictionary;
        }
        [tableview reloadData];
        [self beginLocationForSendingRequest];
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
        NSLog(@"Información de vendedor actualizada %@",server.dictionary);
        return;
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
-(void)logout{
    FileSaver *file=[[FileSaver alloc]init];
    [file setDictionary:@{@"algo":@"nada"} withKey:@"Admin"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)update{
    [self loadUsers];
}
#pragma mark - location update
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation{
    if (locationCounter<maxLoopsForLocation) {
        zoomLocation.latitude = location.coordinate.latitude;
        zoomLocation.longitude = location.coordinate.longitude;
        latitud=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
        longitud=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
        locationCounter++;
    }
    else{
        locationCounter=0;
        [locationManager stopUpdatingLocation];
        [self updateVendorInfo];
    }
    
}
#pragma mark - notification received
-(void)notificationReceived:(NSNotification*)notification{
    NSDictionary *dic=notification.object;
    NSLog(@"Notification received: %@",dic);
    if ([[dic objectForKey:@"action"] isEqualToString:@"pedido nuevo"]) {
        [self loadUsers];
    }
    else if ([[dic objectForKey:@"action"] isEqualToString:@"pedido actualizado"]) {
        [self loadUsers];
    }
}

@end
