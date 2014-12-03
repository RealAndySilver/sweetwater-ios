//
//  UserListViewController.m
//  SweetWater
//
//  Created by Andres Abril on 14/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"SweetWater"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, self.view.frame.size.height-130) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadUsers];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Selecciona el cliente que quieres editar:";
    }
    else if (section==1){
        return @"Editar";
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
        return [usersArray count];
    }
    else if (section==1){
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0){
        NSDictionary *dic=[usersArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"userName"];
        cell.detailTextLabel.text= [dic objectForKey:@"userVendorName"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Deleting");
        if (indexPath.section==0) {
            [self removeUser:usersArray[indexPath.row]];
            [tableview beginUpdates];
            NSMutableArray *array=usersArray;
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
        EditUserViewController *euVC=[[EditUserViewController alloc]init];
        euVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditUser"];
        euVC.userDictionary=usersArray[indexPath.row];
        [self.navigationController pushViewController:euVC animated:YES];
    }
    else if (indexPath.section==2) {
        NSLog(@"Objeto tocado: %@",usersArray[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadUsers{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Clientes", nil);
    FileSaver *file=[[FileSaver alloc]init];
    NSDictionary *adminDic=[file getDictionary:@"Admin"];
    NSString *params=[NSString stringWithFormat:@"%@/%@",[adminDic objectForKey:@"email"]? [adminDic objectForKey:@"email"]:[adminDic objectForKey:@"vendorEmail"],[adminDic objectForKey:@"password"]? [adminDic objectForKey:@"password"]:[adminDic objectForKey:@"vendorPassword"]];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetAllUsers" andParameter:params];
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
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        NSLog(@"Clientes:%@",server.dictionary);
        if ([server.dictionary isKindOfClass:[NSMutableArray class]]) {
            usersArray=[[NSMutableArray alloc]initWithArray:(NSMutableArray*)server.dictionary];
        }
        [tableview reloadData];
        [self performSelector:@selector(delayedHudHide) withObject:nil afterDelay:0.5];
        return;
    }
    else if (server.tag==2){
        NSLog(@"Cliente borrado");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadUsers];
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
