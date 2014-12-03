//
//  VendorListViewController.m
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "VendorListViewController.h"

@interface VendorListViewController ()

@end

@implementation VendorListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"SweetWater"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    vendorsArray=[[NSMutableArray alloc]init];    
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadVendors];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Selecciona el vendedor que quieres editar:";
    }
    else if (section==1){
        return @"Editar";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"En esta sección podrás editar la información de los vendedores";
    }
    else if (section==1){
        return @"En esta sección podrás editar vendedores, clientes, o pedidos.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [vendorsArray count];
    }
    else if (section==1){
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0){
        NSDictionary *dic=[vendorsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"vendorName"];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Deleting");
        if (indexPath.section==0) {
            [self removeVendor:vendorsArray[indexPath.row]];
            [tableview beginUpdates];
            NSMutableArray *array=vendorsArray;
            [array removeObjectAtIndex:indexPath.row];
            [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableview endUpdates];
        }
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
            EditVendorViewController *evVC=[[EditVendorViewController alloc]init];
            evVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditVendor"];
            evVC.vendorDictionary=vendorsArray[indexPath.row];
            [self.navigationController pushViewController:evVC animated:YES];
    }
    else if (indexPath.section==2) {
        NSLog(@"Objeto tocado: %@",vendorsArray[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadVendors{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Vendedores", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[adminDic objectForKey:@"email"],[adminDic objectForKey:@"password"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetAllVendors" andParameter:params];
}
-(void)removeVendor:(NSDictionary*)vendorDic{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Eliminando Vendedor", nil);
    //FileSaver *file=[[FileSaver alloc]init];
    //NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"vendorId=%@",[vendorDic objectForKey:@"_id"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithPOSTMethod:@"DeleteVendor" andParameter:params httpMethod:@"DELETE"];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        NSLog(@"Vendors:%@",server.dictionary);
        if ([server.dictionary isKindOfClass:[NSArray class]]) {
            vendorsArray=[[NSMutableArray alloc]initWithArray:(NSMutableArray*)server.dictionary];
        }
        [tableview reloadData];
        [self performSelector:@selector(delayedHudHide) withObject:nil afterDelay:0.5];
        return;
    }
    else if (server.tag==2){
        NSLog(@"Vendedor borrado");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadVendors];
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
@end
