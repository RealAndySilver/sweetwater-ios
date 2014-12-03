//
//  ReportViewController.m
//  SweetWater
//
//  Created by Andres Abril on 30/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Enviar"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(sendMail)];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    UIWebView *webView=[[UIWebView alloc]init];
    webView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-20);
    [self.view addSubview:webView];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://192.241.187.135:1513/GetTodayReportHTML"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    [webView loadRequest: request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - server request
-(void)sendMail{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetTodayReportMail" andParameter:@""];
}
-(void)getReportHTML{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    [server callServerWithGETMethod:@"GetTodayReportHTML" andParameter:@""];
}
#pragma mark - server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    if (server.tag==1) {
        NSString *message=[server.dictionary objectForKey:@"message"];
        [[[UIAlertView alloc] initWithTitle:@"Correo enviado!"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
    else if (server.tag==2){
        
    }
   
}
@end
