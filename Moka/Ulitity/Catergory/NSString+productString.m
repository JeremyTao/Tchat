//
//  NSString+productString.m
//  InnerBuy
//
//  Created by 郑克 on 16/5/17.
//  Copyright © 2016年 sanfenqiu. All rights reserved.
//

#import "NSString+productString.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation NSString (productString)

+(NSArray *)getMyString:(NSString *)allString{
    if (allString.length > 2) {
        NSArray *tempArr = [NSArray array];
        NSMutableArray *lastArr = [NSMutableArray array];
        allString = [allString substringToIndex:allString.length - 1];
        allString = [allString substringFromIndex:1];
        tempArr = [allString componentsSeparatedByString:@","];
        
        for (NSString *str in tempArr) {
            NSString *tempStr;
            tempStr = [str substringToIndex:str.length - 1];
            
            tempStr = [tempStr substringFromIndex:1];
            [lastArr addObject:tempStr];
        }
        return lastArr;

    }else{
        return nil;
    }
    

}

+(NSArray *)getMyStringTwo:(NSString *)allString{
    if (allString.length > 2) {
        NSArray *tempArr = [NSArray array];
        NSMutableArray *lastArr = [NSMutableArray array];
        allString = [allString substringToIndex:allString.length - 1];
        allString = [allString substringFromIndex:1];
        tempArr = [allString componentsSeparatedByString:@","];
        
        for (NSString *str in tempArr) {

            [lastArr addObject:str];
        }
        return lastArr;
        
    }else{
        return nil;
    }
    
    
}



+(NSString *)getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
//    NSDictionary *addresses = nil;
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    NSLog(@"addresses: %@", addresses);
    
    NSString *adressString = addresses[@"en0/ipv4"];
    
    //    __block NSString *address;
    //    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
    //     {
    //         address = addresses[key];
    //         if(address) *stop = YES;
    //     } ];
    //    return address ? address : @"0.0.0.0";
    return adressString;

}


@end
