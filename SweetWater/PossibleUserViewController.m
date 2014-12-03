//
//  PossibleUserViewController.m
//  SweetWater
//
//  Created by Andres Abril on 31/07/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "PossibleUserViewController.h"

@interface PossibleUserViewController ()

@end

@implementation PossibleUserViewController
@synthesize vendorDic;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Posibles Clientes"];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    usersArray=[[NSMutableArray alloc]init];
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
        return @"Posibles clientes de hoy:";
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"Esta lista muestra los posibles clientes que podrían necesitar productos el día de hoy.";
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
        cell.detailTextLabel.text= [NSString stringWithFormat:@"Última entrega: %@",[self dateConverterFromString:[dic objectForKey:@"userLastDeliveryDate"]]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        ExpressDeliveryViewController *euVC=[[ExpressDeliveryViewController alloc]init];
        euVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ExpressDelivery"];
        euVC.userDic=usersArray[indexPath.row];
        [self.navigationController pushViewController:euVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark server request
-(void)loadUsers{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=NSLocalizedString(@"Cargando Clientes", nil);
    NSString *params=[NSString stringWithFormat:@"%@/%@/%i",[vendorDic objectForKey:@"_id"],[vendorDic objectForKey:@"vendorPassword"],0];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetTodayPossibleCustomersForVendor" andParameter:params];
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
