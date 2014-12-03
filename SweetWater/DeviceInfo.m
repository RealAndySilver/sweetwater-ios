//
//  DeviceInfo.m
//  DroidSecure
//
//  Created by Andres Abril on 30/10/12.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "DeviceInfo.h"
@interface DeviceInfo(){
    
}
@end
@implementation DeviceInfo

+ (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}
+(NSString*)getDeviceName{
    NSString *name=[[UIDevice currentDevice]name];
    return name;
}
+(NSString *)getDeviceLanguage{
    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
    return lang;
}
+ (NSString*)getSystemVersion{
    NSString *version=[[UIDevice currentDevice]systemVersion];
    return version;
}
+(NSString*)getBatteryLevel{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float level=[[UIDevice currentDevice] batteryLevel];
    NSString *levelstring=[NSString stringWithFormat:@"%.2f",level];
    return levelstring;
}
+(NSString*)getBatteryState{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    int level=[[UIDevice currentDevice] batteryState];
    if (level==3) {
        NSString *res=@"Full Charge";
        return res;
    }
    else if (level==2) {
        NSString *res=@"Charging";
        return res;
    }
    else if (level==1) {
        NSString *res=@"Unplugged";
        return res;
    }
    else if (level==0) {
        NSString *res=@"Unknown";
        return res;
    }
    else{
        NSString *res=@"Not defined";
        return res;
    }
}
+ (NSString *)getMacAddress{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    if (errorFlag != NULL)
    {
        //NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    free(msgBuffer);
    return macAddressString;
}

static processor_info_array_t cpuInfo, prevCpuInfo;
static mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
+(NSMutableDictionary *)getCPUUsage{
    
    unsigned numCPUs;
    NSLock *CPUUsageLock;
    
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if(status)
        numCPUs = 1;
    
    CPUUsageLock = [[NSLock alloc] init];
    
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    if(err == KERN_SUCCESS) {
        [CPUUsageLock lock];
        
        for(unsigned i = 0U; i < numCPUs; ++i) {
            float inUse, total;
            if(prevCpuInfo) {
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            //NSLog(@"Core: %u Usage: %f",i,inUse / total);
            NSString *formatCore=[NSString stringWithFormat:@"Core%i",i];
            NSString *formatUse=[NSString stringWithFormat:@"Core%i",i];

            [dic setObject:[NSNumber numberWithInt:i] forKey:formatCore];
            [dic setObject:[NSNumber numberWithFloat:inUse/total] forKey:formatUse];
        }
        [CPUUsageLock unlock];
        
        if(prevCpuInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCpuInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);
        }
        
        prevCpuInfo = cpuInfo;
        numPrevCpuInfo = numCpuInfo;
        
        cpuInfo = NULL;
        numCpuInfo = 0U;
        return dic;
    } else {
        //NSLog(@"Error!");
        return dic;
        //[NSApp terminate:nil];
    }
}
+ (NSMutableDictionary*)freeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    NSMutableDictionary *resDic=[[NSMutableDictionary alloc]init];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        float totalSpaceFloat=((totalSpace/1024ll)/1024ll);
        float totalFreeSpaceFloat=((totalFreeSpace/1024ll)/1024ll);
        float used=totalSpaceFloat-totalFreeSpaceFloat;
        [resDic setObject:[NSNumber numberWithFloat:totalSpaceFloat] forKey:@"TotalSpace"];
        [resDic setObject:[NSNumber numberWithFloat:used] forKey:@"UsedSpace"];
        [resDic setObject:[NSNumber numberWithFloat:totalFreeSpaceFloat] forKey:@"FreeSpace"];        
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    return resDic;
}


+ (NSArray *)runningProcesses {
    
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];

                    [array addObject:dict];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    return nil;
}

+(NSMutableDictionary*)freeMemory {
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t mem_inactive = vm_stat.inactive_count *pagesize;
    natural_t mem_wired = vm_stat.wire_count *pagesize;
    natural_t mem_active = vm_stat.active_count *pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    
    float memUsed  = (mem_used/1024ll)/1024ll;
    float memInactive = (mem_inactive/1024ll)/1024ll;
    float memWired = (mem_wired/1024ll)/1024ll;
    float memActive = (mem_active/1024ll)/1024ll;
    float memFree  = (mem_free/1024ll)/1024ll;
    float memTotal = (mem_total/1024ll)/1024ll;


    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:[NSNumber numberWithFloat:memUsed] forKey:@"UsedMemory"];
    [dic setObject:[NSNumber numberWithFloat:memInactive] forKey:@"InactiveMemory"];
    [dic setObject:[NSNumber numberWithFloat:memWired] forKey:@"WiredMemory"];
    [dic setObject:[NSNumber numberWithFloat:memActive] forKey:@"ActiveMemory"];
    [dic setObject:[NSNumber numberWithFloat:memFree] forKey:@"FreeMemory"];
    [dic setObject:[NSNumber numberWithFloat:memTotal] forKey:@"TotalMemory"];

    return dic;
}
+ (NSMutableDictionary*)getIPAddress{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    if (wifiAddress) {
        [dic setObject:wifiAddress forKey:@"WiFiAddress"];
    }
    else{
        [dic setObject:@"N/A" forKey:@"WiFiAddress"];
    }
    if (cellAddress) {
        [dic setObject:cellAddress forKey:@"CellAddress"];
    }
    else{
        [dic setObject:@"N/A" forKey:@"CellAddress"];
    }
    return dic;
}
+ (NSString*)getCarrier{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    NSString *res=[carrier carrierName];
    return res;
}
+ (NSString *)getCountry{
    NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}
+(NSString *)getUUDID{
    NSString *res=@"";//[[UIDevice currentDevice]uniqueIdentifier];
    return res;
}
@end
