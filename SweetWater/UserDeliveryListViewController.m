//
//  UserDeliveryListViewController.m
//  SweetWater
//
//  Created by Andres Abril on 19/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "UserDeliveryListViewController.h"

@interface UserDeliveryListViewController ()

@end

@implementation UserDeliveryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"SweetWater"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    usersArray=[[NSMutableArray alloc]init];
    //vendorsHierachyArray=[[NSMutableArray alloc]init];
    vendorsHierachyDictionary=[[NSMutableDictionary alloc]init];

}
-(void)viewWillAppear:(BOOL)animated{
    [self loadUsers];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (usersArray.count==0) {
        return 1;
    }
    return [vendorsHierachyDictionary allKeys].count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (usersArray.count==0) {
        return @"No hay clientes con pedidos activos.";
    }
    NSArray *keysArray=[vendorsHierachyDictionary allKeys];
    for (int i=0; i<keysArray.count; i++) {
        if (section==i) {
            NSString *result=[NSString stringWithFormat:@"%@",keysArray[i]];
            return result;
        }
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (usersArray.count==0) {
        return @"Ningún pedido disponible para actualizar.";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keysArray=[vendorsHierachyDictionary allKeys];
    for (int i=0; i<keysArray.count; i++) {
        if (section==i) {
            NSArray *array=[vendorsHierachyDictionary objectForKey:[keysArray objectAtIndex:i]];
            return array.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSArray *keysArray=[vendorsHierachyDictionary allKeys];
    for (int i=0; i<keysArray.count; i++) {
        if (indexPath.section==i) {
            NSArray *valuesArray=[vendorsHierachyDictionary objectForKey:[keysArray objectAtIndex:i]];
            for (int j=0; j<valuesArray.count; j++) {
                if (indexPath.row==j) {
                    NSDictionary *dictionary=[valuesArray objectAtIndex:j];
                    cell.textLabel.text=[dictionary objectForKey:@"userName"];
                    NSString *deliveryCount=[NSString stringWithFormat:@"Pedidos Activos: %@",[dictionary objectForKey:@"userActiveDeliveries"]];
                    cell.detailTextLabel.text=deliveryCount;
                }
            }
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keysArray=[vendorsHierachyDictionary allKeys];
    for (int i=0; i<keysArray.count; i++) {
        if (indexPath.section==i) {
            NSArray *valuesArray=[vendorsHierachyDictionary objectForKey:[keysArray objectAtIndex:i]];
            for (int j=0; j<valuesArray.count; j++) {
                if (indexPath.row==j) {
                    NSLog(@"Objeto tocado: %@",[valuesArray objectAtIndex:j]);
                    DeliveryListViewController *udlVC=[[DeliveryListViewController alloc]init];
                    udlVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeliveryList"];
                    udlVC.userDic=[valuesArray objectAtIndex:j];
                    [self.navigationController pushViewController:udlVC animated:YES];
                }
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadUsers{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Clientes", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[adminDic objectForKey:@"email"],[adminDic objectForKey:@"password"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetUsersWithActiveDeliveries" andParameter:params];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    //NSLog(@"Clientes:%@",server.dictionary);
    if ([server.dictionary isKindOfClass:[NSArray class]]) {
        usersArray=(NSMutableArray*)server.dictionary;
    }
    NSMutableArray *vendorIdArray=[[NSMutableArray alloc]init];
    for (NSDictionary *userDic in usersArray) {
        if (![vendorIdArray containsObject:[userDic objectForKey:@"userVendorName"]]) {
            [vendorIdArray addObject:[userDic objectForKey:@"userVendorName"]];
        }
    }
    
    for (int i=0; i<vendorIdArray.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [dic setObject:array forKey:[vendorIdArray objectAtIndex:i]];
        [vendorsHierachyDictionary setObject:array forKey:[vendorIdArray objectAtIndex:i]];
        //[vendorsHierachyArray addObject:dic];
    }
    for (NSDictionary *userDic in usersArray) {
        int i=0;
        for (NSString *vendorId in vendorIdArray) {
            if ([vendorId isEqualToString:[userDic objectForKey:@"userVendorName"]]) {
                //NSMutableArray *array=[[vendorsHierachyArray objectAtIndex:i] objectForKey:vendorId];
                NSMutableArray *array2=[vendorsHierachyDictionary objectForKey:vendorId];
                [array2 addObject:userDic];
            }
            i++;
        }
    }
    NSLog(@"Arreglo de vendors :%@",vendorsHierachyDictionary);
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
@end