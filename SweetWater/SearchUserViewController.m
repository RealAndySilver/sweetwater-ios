//
//  SearchUserViewController.m
//  SweetWater
//
//  Created by Andres Abril on 17/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()

@end

@implementation SearchUserViewController
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Buscar Cliente"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Crear"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(createUser)];
    self.navigationItem.rightBarButtonItem=rightButton;
    usersArray=[[NSMutableArray alloc]init];
    arrayNombres=[[NSMutableArray alloc]init];
    arrayTelefonos=[[NSMutableArray alloc]init];
    arrayIndicaciones=[[NSMutableArray alloc]init];
    arrayDirecciones=[[NSMutableArray alloc]init];
    leftSearchBar.delegate=self;
    UIView *container=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
    [container setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.9]];
    leftSearchBar.inputAccessoryView=container;
    
    
    UIButton *buttonNuevo=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNuevo.frame=CGRectMake(0, 0, 140, 30);
    buttonNuevo.center=CGPointMake(container.frame.size.width/2, container.frame.size.height/2);
    [container addSubview:buttonNuevo];
    [buttonNuevo setTitle:@"Crear Nuevo" forState:UIControlStateNormal];
    [buttonNuevo setTitleColor:[UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:1] forState:UIControlStateNormal];
    [buttonNuevo setBackgroundColor:[UIColor clearColor]];
    [buttonNuevo addTarget:self action:@selector(createUserWithPreText) forControlEvents:UIControlEventTouchUpInside];
    buttonNuevo.layer.cornerRadius=3;
    buttonNuevo.layer.borderWidth=1;
    buttonNuevo.layer.borderColor=[UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:1].CGColor;
    [buttonNuevo setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [segmentedControl setSelectedSegmentIndex:2];
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
        return @"Selecciona el cliente al cual quieres asignar el pedido:";
    }
    else if (section==1){
        return @"Editar";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    if (section==0) {
//        return @"En esta sección podrás editar la información del usuario que selecciones.";
//    }
//    else if (section==1){
//        return @"En esta sección podrás editar la información del usuario que selecciones.";
//    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [staticArray count];
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.textLabel.text=[staticArray objectAtIndex:indexPath.row];
    }
    else{
        if (segmentedControl.selectedSegmentIndex==0){
            cell.textLabel.text = [arrayNombres objectAtIndex:indexPath.row];
        }
        else if (segmentedControl.selectedSegmentIndex==1){
            cell.textLabel.text = [arrayTelefonos objectAtIndex:indexPath.row];
        }
        else if (segmentedControl.selectedSegmentIndex==2){
            cell.textLabel.text = [arrayIndicaciones objectAtIndex:indexPath.row];
        }
        else if (segmentedControl.selectedSegmentIndex==3){
            cell.textLabel.text = [arrayDirecciones objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (segmentedControl.selectedSegmentIndex==0){
        int index=[arrayNombres indexOfObject:cell.textLabel.text];
        NSDictionary *dic=[usersArray objectAtIndex:index];
        [self.delegate userProcessed:dic];
    }
    else if (segmentedControl.selectedSegmentIndex==1){
        int index=[arrayTelefonos indexOfObject:cell.textLabel.text];
        NSDictionary *dic=[usersArray objectAtIndex:index];
        [self.delegate userProcessed:dic];
    }
    else if (segmentedControl.selectedSegmentIndex==2){
        int index=[arrayIndicaciones indexOfObject:cell.textLabel.text];
        NSDictionary *dic=[usersArray objectAtIndex:index];
        [self.delegate userProcessed:dic];
    }
    else if (segmentedControl.selectedSegmentIndex==3){
        int index=[arrayDirecciones indexOfObject:cell.textLabel.text];
        NSDictionary *dic=[usersArray objectAtIndex:index];
        [self.delegate userProcessed:dic];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - create user delegate
-(void)userCreated:(NSDictionary *)userDic{
    [self.delegate userProcessed:userDic];
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
    [server callServerWithGETMethod:@"GetAllUsers" andParameter:params];
}
#pragma mark server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    //NSLog(@"Clientes:%@",server.dictionary);
    usersArray=nil;
    [arrayNombres removeAllObjects];
    [arrayTelefonos removeAllObjects];
    [arrayIndicaciones removeAllObjects];
    [arrayDirecciones removeAllObjects];

    if ([server.dictionary isKindOfClass:[NSArray class]]) {
        usersArray=(NSMutableArray*)server.dictionary;
    }
    for (NSDictionary *dic in usersArray) {
        [arrayNombres addObject:[dic objectForKey:@"userName"]];
        [arrayTelefonos addObject:[dic objectForKey:@"userPhone"]];
        [arrayIndicaciones addObject:[dic objectForKey:@"userIndication"]];
        [arrayDirecciones addObject:[dic objectForKey:@"userAddress"]];
    }
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
#pragma mark segmented control action
-(IBAction) segmentedControlIndexChanged:(UISegmentedControl*)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [tableview reloadData];
            break;
        case 1:
            [tableview reloadData];
            break;
        case 2:
            [tableview reloadData];
            break;
        case 3:
            [tableview reloadData];
        default:
            break;
    }
    [self filterContentForSearchText:leftSearchBar.text scope:nil];
}
#pragma mark uisearchdisplay controller delegate
- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope{
    NSPredicate *resultPredicate=[NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    if (segmentedControl.selectedSegmentIndex==0) {
        staticArray = [arrayNombres filteredArrayUsingPredicate:resultPredicate];
    }
    else if(segmentedControl.selectedSegmentIndex==1){
        staticArray = [arrayTelefonos filteredArrayUsingPredicate:resultPredicate];
    }
    else if(segmentedControl.selectedSegmentIndex==2){
        staticArray = [arrayIndicaciones filteredArrayUsingPredicate:resultPredicate];
    }
    else if(segmentedControl.selectedSegmentIndex==3){
        staticArray = [arrayDirecciones filteredArrayUsingPredicate:resultPredicate];
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:searchOption]];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    [self.view bringSubviewToFront:headerContainer];
    [self.view bringSubviewToFront:segmentedControl];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
    searchDisplayController.searchResultsTableView.tag=10002;
    tableView.frame = CGRectMake(0, leftSearchBar.frame.origin.y+44, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Cancel pressed");
    [leftSearchBar resignFirstResponder];
}
-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Bookmark pressed");
}
#pragma mark right button action in nav bar
-(void)createUser{
    CreateUserViewController *cuVC=[[CreateUserViewController alloc]init];
    cuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateUser"];
    cuVC.fromSearch=YES;
    cuVC.delegate=self;
    [self.navigationController pushViewController:cuVC animated:YES];
}
-(void)createUserWithPreText{
    CreateUserViewController *cuVC=[[CreateUserViewController alloc]init];
    cuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateUser"];
    cuVC.fromSearch=YES;
    cuVC.delegate=self;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [dic setObject:leftSearchBar.text forKey:@"nombre"];
            break;
        case 1:
            [dic setObject:leftSearchBar.text forKey:@"telefono"];
            break;
        case 2:
            [dic setObject:leftSearchBar.text forKey:@"indicacion"];
            break;
        case 3:
            [dic setObject:leftSearchBar.text forKey:@"direccion"];
        default:
            break;
    }
    cuVC.propertiesDic=dic;
    [self.navigationController pushViewController:cuVC animated:YES];
}
@end
