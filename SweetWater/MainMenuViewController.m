//
//  MainMenuViewController.m
//  SweetWater
//
//  Created by Andres Abril on 13/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FileSaver.h"
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Salir"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(logout)];
    /*UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Recargar"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(update)];*/
    //self.navigationItem.leftBarButtonItem=leftButton;
    
    self.navigationItem.rightBarButtonItem=rightButton;
    [self.navigationItem setHidesBackButton:YES];
    [self setTitle:@"SweetWater"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-45) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    crearArray=@[@"Crear Vendedor",@"Crear Cliente",@"Crear Pedido"];
    editarArray=@[@"Editar Vendedor",@"Editar Cliente",@"Editar Pedido"];
    vendorsArray=[[NSMutableArray alloc]init];

    reportsArray=[[NSMutableArray alloc]init];
    [reportsArray addObject:@"Reporte del día"];
//    FileSaver *file=[[FileSaver alloc]init];
//    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    
    //[self loadVendors];
    //Esto borra el interior del diccionario
    //[file setDictionary:@{@"algo":@"nada"} withKey:@"Admin"];
    //Fin del borrado
    
//    if (![adminDic objectForKey:@"_id"]) {
//        LoginViewController *loginVC=[[LoginViewController alloc]init];
//        loginVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        [self.navigationController presentViewController:loginVC animated:NO completion:nil];
//    }
}
-(void)viewDidAppear:(BOOL)animated{
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    if ([[adminDic objectForKey:@"type"] isEqualToString:@"admin"]) {
        [self loadVendors];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Crear";
    }
    else if (section==1){
        return @"Editar";
    }
    else if (section==2){
        return @"Monitorear";
    }
    else if (section==3){
        return @"Reportes";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás crear nuevos vendedores, clientes, o pedidos.";
    }
    else if (section==1){
        return @"En esta sección podrás editar vendedores, clientes, o pedidos.";
    }
    else if (section==2){
        return @"En esta sección podrás revisar los pedidos pendientes para cada vendedor disponible, además de ver su última posición registrada.";
    }
    else if (section==3){
        return @"En esta sección podrás revisar los reportes de entregas de pedido del día.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [crearArray count];
    }
    else if (section==1){
        return [editarArray count];
    }
    else if (section==2){
        return vendorsArray.count;
    }
    else if (section==3){
        return reportsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = [crearArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==1){
        cell.textLabel.text = [editarArray objectAtIndex:indexPath.row];

    }
    else if (indexPath.section==2){
        NSDictionary *dic=[vendorsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"vendorName"];
        
    }
    else if (indexPath.section==3){
        NSString *str=[reportsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = str;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            CreateVendorViewController *cvVC=[[CreateVendorViewController alloc]init];
            cvVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateVendor"];
            [self.navigationController pushViewController:cvVC animated:YES];
        }
        else if (indexPath.row==1) {
            CreateUserViewController *cuVC=[[CreateUserViewController alloc]init];
            cuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateUser"];
            [self.navigationController pushViewController:cuVC animated:YES];
        }
        else if (indexPath.row==2) {
            CreateDeliveryViewController *cdVC=[[CreateDeliveryViewController alloc]init];
            cdVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateDelivery"];
            [self.navigationController pushViewController:cdVC animated:YES];
        }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            VendorListViewController *vlVC=[[VendorListViewController alloc]init];
            vlVC=[self.storyboard instantiateViewControllerWithIdentifier:@"VendorList"];
            [self.navigationController pushViewController:vlVC animated:YES];
        }
        else if (indexPath.row==1) {
            UserListViewController *ulVC=[[UserListViewController alloc]init];
            ulVC=[self.storyboard instantiateViewControllerWithIdentifier:@"UserList"];
            [self.navigationController pushViewController:ulVC animated:YES];
        }
        else if (indexPath.row==2) {
            UserDeliveryListViewController *udVC=[[UserDeliveryListViewController alloc]init];
            udVC=[self.storyboard instantiateViewControllerWithIdentifier:@"UserDeliveryList"];
            [self.navigationController pushViewController:udVC animated:YES];
        }
    }
    else if (indexPath.section==2) {
        NSLog(@"Objeto tocado: %@",vendorsArray[indexPath.row]);
        MonitorViewController *mvC=[[MonitorViewController alloc]init];
        mvC=[self.storyboard instantiateViewControllerWithIdentifier:@"Monitor"];
        mvC.vendorDic=vendorsArray[indexPath.row];
        [self.navigationController pushViewController:mvC animated:YES];
    }
    else if (indexPath.section==3) {
        ReportViewController *rVC=[[ReportViewController alloc]init];
        rVC=[self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
        [self.navigationController pushViewController:rVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadVendors{
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[adminDic objectForKey:@"email"],[adminDic objectForKey:@"password"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetAllVendors" andParameter:params];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{

    if ([server.dictionary isKindOfClass:[NSArray class]]) {
        vendorsArray=(NSMutableArray*)server.dictionary;
    }
    /*for (int i=0; i<tempKeyArray.count; i++) {
        [vendorsArray addObject:[tempKeyArray objectAtIndex:i]];
    }*/
    [tableview reloadData];
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Ha ocurrido un error con la conexión a internet. Por favor verifique y vuelva a intentarlo." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableview reloadData];
}
-(void)logout{
    NSLog(@"Bye");
    FileSaver *file=[[FileSaver alloc]init];
    [file setDictionary:@{@"algo":@"nada"} withKey:@"Admin"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)update{
    [self loadVendors];
}
@end
