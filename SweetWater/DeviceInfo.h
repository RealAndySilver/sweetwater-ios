//
//  DeviceInfo.h
//  DroidSecure
//
//  Created by Andres Abril on 30/10/12.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <mach/mach.h>
#import <mach/processor_info.h>
#import <mach/mach_host.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


@interface DeviceInfo : NSObject
+ (NSString *)getModel;
+ (NSString *)getDeviceName;
+ (NSString *)getDeviceLanguage;
+ (NSString *)getSystemVersion;
+ (NSString *)getBatteryLevel;
+ (NSString *)getBatteryState;
+ (NSString *)getMacAddress;
+ (NSMutableDictionary *)getCPUUsage;
+ (NSMutableDictionary *)freeDiskspace;
+ (NSArray *)runningProcesses;
+ (NSMutableDictionary *)freeMemory;
+ (NSMutableDictionary *)getIPAddress;
+ (NSString *)getCarrier;
+ (NSString *)getCountry;
+ (NSString *)getUUDID;


@end
