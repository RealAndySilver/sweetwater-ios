//
//  DeliveryListViewController.m
//  SweetWater
//
//  Created by Andres Abril on 20/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "DeliveryListViewController.h"
#define MAP_SIZE 400

@interface DeliveryListViewController ()

@end

@implementation DeliveryListViewController
@synthesize userDic,notEditable;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"SweetWater"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    latitud=@"No";
    longitud=@"No";
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    [self.view addSubview:tableview];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadUsers];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![[userDic objectForKey:@"userLatitude"] isEqualToString:@"No"]) {
        return 2;
    }
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [NSString stringWithFormat:@"Pedidos Activos para el Cliente:\nNombre: %@\nDirección: %@\nIndicación: %@",[userDic objectForKey:@"userName"],[userDic objectForKey:@"userAddress"],[userDic objectForKey:@"userIndication"]];
    }
    else if (section==1){
        return @"Ubicación Georeferenciada:";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return [NSString stringWithFormat:@"Estos pedidos están asignados a:\nVendedor: %@\nId Vendedor: %@",[userDic objectForKey:@"userVendorName"],[userDic objectForKey:@"userVendorId"]];
    }
    else if (section==1){
        return @"Esta posición georeferenciada fue almacenada al momento de crear el cliente. Esta información pudo haber cambiado desde el momento de su creación.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (userArray) {
            return [[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"] count];
        }
    }
    else if (section==1){
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 120;
    }
    else if (indexPath.section==1){
        if (![[userDic objectForKey:@"userLatitude"] isEqualToString:@"No"]) {
            return MAP_SIZE+20;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (indexPath.section==0) {
        for (int i=0; i<[[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"] count]; i++) {
            if (indexPath.row==i) {
                if (userArray) {
                    NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
                    float priorityCounter=[[[array objectAtIndex:i]objectForKey:@"deliveryPriority"]floatValue];
                    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 18)];
                    title.textColor=[UIColor colorWithRed:priorityCounter/5 green:0 blue:0 alpha:1];
                    title.font=[UIFont boldSystemFontOfSize:15];
                    title.backgroundColor=[UIColor clearColor];
                    title.text=[[array objectAtIndex:i]objectForKey:@"deliveryAnnotation"];
                    [cell addSubview:title];
                    
                    UILabel *subTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 18)];
                    subTitle.font=[UIFont systemFontOfSize:15];
                    subTitle.backgroundColor=[UIColor clearColor];
                    subTitle.text=[NSString stringWithFormat:@"A: %i - H: %i - BG: %i - BP: %i - HP: %i",[[[array objectAtIndex:i]objectForKey:@"deliveryWaterQuantity"]intValue],[[[array objectAtIndex:i]objectForKey:@"deliveryIceQuantity"]intValue],[[[array objectAtIndex:i]objectForKey:@"deliveryWaterGalQuantity"]intValue],[[[array objectAtIndex:i]objectForKey:@"deliveryLittleWaterQuantity"]intValue],[[[array objectAtIndex:i]objectForKey:@"deliveryLittleIceQuantity"]intValue]];
                    [cell addSubview:subTitle];
                    
                    UIView *container=[[UIView alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-20, 50)];
                    container.backgroundColor=[UIColor clearColor];
                    
                    UIButton *buttonAceptar=[UIButton buttonWithType:UIButtonTypeCustom];
                    buttonAceptar.tag=i;
                    buttonAceptar.frame=CGRectMake(0, 0, 96, 50);
                    [container addSubview:buttonAceptar];
                    [buttonAceptar setTitle:@"Entregar" forState:UIControlStateNormal];
                    [buttonAceptar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [buttonAceptar setBackgroundColor:[UIColor greenColor]];
                    [buttonAceptar addTarget:self action:@selector(entregarPedido:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *buttonAceptarSitio=[UIButton buttonWithType:UIButtonTypeCustom];
                    buttonAceptarSitio.frame=CGRectMake(101, 0, 96, 50);
                    buttonAceptarSitio.tag=i+2000;
                    [container addSubview:buttonAceptarSitio];
                    [buttonAceptarSitio setTitle:@"Entregar" forState:UIControlStateNormal];
                    [buttonAceptarSitio setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [buttonAceptarSitio setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:1]];
                    [buttonAceptarSitio addTarget:self action:@selector(entregarPedidoEnSitio:) forControlEvents:UIControlEventTouchUpInside];
                
                    UIButton *buttonCancelar=[UIButton buttonWithType:UIButtonTypeCustom];
                    buttonCancelar.frame=CGRectMake(202, 0, 96, 50);
                    buttonCancelar.tag=i+1000;
                    [container addSubview:buttonCancelar];
                    [buttonCancelar setTitle:@"Cancelar" forState:UIControlStateNormal];
                    [buttonCancelar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [buttonCancelar setBackgroundColor:[UIColor redColor]];
                    [buttonCancelar addTarget:self action:@selector(cancelarPedido:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell addSubview:container];
                    
                    
                }
            }
        }
    }
    else if (indexPath.section==1){
        MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(10, 10, 300, MAP_SIZE)];
        [mapView setUserInteractionEnabled:NO];
        mapView.mapType=MKMapTypeHybrid;
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = [[[userArray objectAtIndex:0] objectForKey:@"userLatitude"] floatValue];
        newRegion.center.longitude = [[[userArray objectAtIndex:0] objectForKey:@"userLongitude"] floatValue];
        newRegion.span.latitudeDelta = 0.0025;
        newRegion.span.longitudeDelta = 0.0025;
        
        [mapView setRegion:newRegion animated:YES];
        
        UIView *center=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        center.backgroundColor=[UIColor blueColor];
        center.center=CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
        center.layer.cornerRadius=5;
        [mapView addSubview:center];
        
        [cell addSubview:mapView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //if (!notEditable) {
            for (int i=0; i<[[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"] count]; i++) {
                if (indexPath.row==i) {
                    if (userArray) {
                        NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
                        EditDeliveryViewController *euVC=[[EditDeliveryViewController alloc]init];
                        euVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditDelivery"];
                        euVC.userDic=[array objectAtIndex:i];
                        euVC.userVendorId=[userDic objectForKey:@"userVendorId"];
                        [self.navigationController pushViewController:euVC animated:YES];
                    }
                }
            }
        /*}
        else{
            for (int i=0; i<[[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"] count]; i++) {
                if (indexPath.row==i) {
                    if (userArray) {
                        NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
                        DeliveryDetailViewController *ddVC=[[DeliveryDetailViewController alloc]init];
                        ddVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryDetail"];
                        ddVC.userDic=[array objectAtIndex:i];
                        [self.navigationController pushViewController:ddVC animated:YES];
                    }
                }
            }
        }*/
    }
    else if (indexPath.section==1){
        if (indexPath.row==0) {
            MapDetailViewController *mdVC=[[MapDetailViewController alloc]init];
            mdVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MapDetail"];
            mdVC.userDic=[userArray objectAtIndex:0];
            [self.navigationController pushViewController:mdVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadUsers{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Pedidos", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@/%@",[userDic objectForKey:@"_id"],[adminDic objectForKey:@"email"]?[adminDic objectForKey:@"email"]:[adminDic objectForKey:@"vendorEmail"],[adminDic objectForKey:@"password"]?[adminDic objectForKey:@"password"]:[adminDic objectForKey:@"vendorPassword"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    //[server callServerWithGETMethod:@"GetUserById" andParameter:params];
    [server callServerWithGETMethod:@"GetUserDeliveries" andParameter:params];
}
-(void)entregarPedidoConId:(NSString*)deliveryId{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Actualizando Pedido", nil);
    //    FileSaver *file=[[FileSaver alloc]init];
    //    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSLog(@"AdminDic %@\nUserDic %@",adminDic,userDic);
    NSString *params=[NSString stringWithFormat:@"vendorId=%@&vendorName=%@&userVendorId=%@&userVendorName=%@&deliveryId=%@&deliveryLatitude=%@&deliveryLongitude=%@&userId=%@",[adminDic objectForKey:@"_id"],[adminDic objectForKey:@"name"]?[adminDic objectForKey:@"name"]:[adminDic objectForKey:@"vendorName"],[userDic objectForKey:@"userVendorId"],[userDic objectForKey:@"userVendorName"],deliveryId,latitud,longitud, [userDic objectForKey:@"_id"]];
    NSLog(@"Entregando con id %@",[userDic objectForKey:@"_id"]);
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"DeliveryDelivered" andParameter:params httpMethod:@"PUT"];
    NSLog(@"Actualizar pedido: %@",params);
}
-(void)entregarPedidoEnSitioConId:(NSString*)deliveryId{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Actualizando Pedido", nil);
    //    FileSaver *file=[[FileSaver alloc]init];
    //    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"vendorId=%@&vendorName=%@&userVendorId=%@&userVendorName=%@&deliveryId=%@&deliveryLatitude=%@&deliveryLongitude=%@&userId=%@",[adminDic objectForKey:@"_id"],[adminDic objectForKey:@"name"]?[adminDic objectForKey:@"name"]:[adminDic objectForKey:@"vendorName"],[userDic objectForKey:@"userVendorId"],[userDic objectForKey:@"userVendorName"],deliveryId,latitud,longitud,[userDic objectForKey:@"_id"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"DeliveryDeliveredInPlace" andParameter:params httpMethod:@"PUT"];
    NSLog(@"Actualizar pedido: %@",params);
}
-(void)cancelarPedidoConId:(NSString*)deliveryId{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cancelando Pedido", nil);
    //    FileSaver *file=[[FileSaver alloc]init];
    //    NSString *adminId=[[file getDictionary:@"Admin"]objectForKey:@"_id"];
    
    //NSString *params=[NSString stringWithFormat:@"vendorId=%@&vendorName=%@&deliveryId=%@&userId=%@",[userDic objectForKey:@"userVendorId"],[userDic objectForKey:@"userVendorName"],deliveryId,[userDic objectForKey:@"_id"]];
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"vendorId=%@&vendorName=%@&userVendorId=%@&userVendorName=%@&deliveryId=%@&deliveryLatitude=%@&deliveryLongitude=%@&userId=%@",[adminDic objectForKey:@"_id"],[adminDic objectForKey:@"name"]?[adminDic objectForKey:@"name"]:[adminDic objectForKey:@"vendorName"],[userDic objectForKey:@"userVendorId"],[userDic objectForKey:@"userVendorName"],deliveryId,latitud,longitud,[userDic objectForKey:@"_id"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"DeliveryCanceled" andParameter:params httpMethod:@"PUT"];
    NSLog(@"Cancelar pedido: %@",params);
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        if (userArray==nil) {
            userArray=[[NSMutableArray alloc]init];
        }
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            userArray=(NSMutableArray*)server.dictionary;
        }
        NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
        if (array.count==0) {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        }
    }
    else if (server.tag==2){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadUsers];
    }
    //    NSLog(@"Usuario:%@",userArray);
    [tableview reloadData];
    [self performSelector:@selector(delayedHudHide) withObject:nil afterDelay:0.5];
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
}
-(void)delayedHudHide{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - acciones de pedido
-(void)cancelarPedido:(UIButton*)button{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Cancelar Pedido" message:@"Está seguro que desea marcar este pedido como cancelado? Esta acción no podrá deshacerse." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si, Cancelar", nil];
    alert.tag=button.tag;
    [alert show];
}
-(void)entregarPedido:(UIButton*)button{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Entregar Pedido" message:@"Está seguro que desea marcar este pedido como entregado? Esta acción no podrá deshacerse." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Entregar", nil];
    alert.tag=button.tag;
    [alert show];
}
-(void)entregarPedidoEnSitio:(UIButton*)button{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Entregar Pedido En Sitio?" message:@"Está seguro que desea marcar este pedido como entregado en el sitio? Esta acción no podrá deshacerse." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Entregar", nil];
    alert.tag=button.tag;
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
            NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
            NSString *deliveryId=[[array objectAtIndex:alertView.tag]objectForKey:@"_id"];
            [self entregarPedidoConId:deliveryId];
        }
        else if(alertView.tag>=1000 && alertView.tag<2000){
            // Aceptar
            int tag=alertView.tag-1000;
            NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
            NSString *deliveryId=[[array objectAtIndex:tag]objectForKey:@"_id"];
            [self cancelarPedidoConId:deliveryId];
        }
        else if(alertView.tag>=2000){
            // Aceptar
            int tag=alertView.tag-2000;
            NSArray *array=[[userArray objectAtIndex:0]objectForKey:@"userDeliveries"];
            NSString *deliveryId=[[array objectAtIndex:tag]objectForKey:@"_id"];
            [self entregarPedidoEnSitioConId:deliveryId];
        }
    }
    
}
#pragma mark - location update
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)location fromLocation:(CLLocation *)oldLocation{
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude = location.coordinate.longitude;
    latitud=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
    longitud=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
}
-(void)capturarPosicion{
    latitud=[NSString stringWithFormat:@"%f",zoomLocation.latitude];
    longitud=[NSString stringWithFormat:@"%f",zoomLocation.longitude];
    [tableview reloadData];
}
@end
