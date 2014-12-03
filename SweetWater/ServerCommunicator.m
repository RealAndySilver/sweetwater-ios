//
//  ServerCommunicator.m
//  WebConsumer
//
//  Created by Andres Abril on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunicator.h"
//#define ENDPOINT @"http://10.0.1.7:3000"
//#define ENDPOINT @"http://iamstudio-sweetwater.herokuapp.com/"
//#define ENDPOINT @"http://sweetwater.jit.su"
#define ENDPOINT @"http://192.241.187.135:1513"
@implementation ServerCommunicator
@synthesize dictionary,tag,caller,objectDic;
-(id)init {
    self = [super init];
    if (self) {
        tag = 0;
        caller = nil;
        webData = nil;
        theConnection = nil;
    }
    return self;
}
-(void)callServerWithGETMethod:(NSString*)method andParameter:(NSString*)parameter{
    parameter=[parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    parameter=[parameter stringByExpandingTildeInPath];
    method=[NSString stringWithFormat:@"%@/%@",method,parameter];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ENDPOINT,method]];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	dictionary = [[NSDictionary alloc]init];
	if(theConnection) {
		webData = [NSMutableData data];
        NSLog(@"theConnection %@",theRequest);
	}
	else {
		NSLog(@"theConnection is NULL");
	}
}
-(void)callServerWithPOSTMethod:(NSString *)method andParameter:(NSString *)parameter httpMethod:(NSString *)httpMethod{
    parameter=[parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    parameter=[parameter stringByExpandingTildeInPath];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ENDPOINT,method]];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [theRequest setHTTPMethod:httpMethod];
    NSData *data=[NSData dataWithBytes:[parameter UTF8String] length:[parameter length]];
    [theRequest setHTTPBody: data];
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	dictionary = [[NSDictionary alloc]init];
    //NSString *sd=[[NSString alloc]initWithData:theRequest.HTTPBody encoding:NSUTF8StringEncoding];
    //NSLog(@"Body enviado %@",sd);
	if(theConnection) {
		webData = [NSMutableData data];
        NSLog(@"theConnection %@",theRequest);
	}
	else {
		NSLog(@"theConnection is NULL");
	}
}
#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"didFailWithError %@",error);
    if ([caller respondsToSelector:@selector(receivedDataFromServerWithError:)]) {
        [caller performSelector:@selector(receivedDataFromServerWithError:) withObject:self];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    dictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSString *res=[[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"res: %@",res);
    if ([caller respondsToSelector:@selector(receivedDataFromServer:)]) {
        [caller performSelector:@selector(receivedDataFromServer:) withObject:self];
    }
}
@end
