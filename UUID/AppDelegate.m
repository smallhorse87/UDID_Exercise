//
//  AppDelegate.m
//  UUID
//
//  Created by chenxiaosong on 2019/2/19.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import "AppDelegate.h"

#import <AdSupport/AdSupport.h>

#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "OpenUDID.h"

#import "FCUUID.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"UUIDString : %@",[[NSUUID UUID] UUIDString]);//唯一ID生成器

    //始终返回 02:00:00:00:00:00
    NSLog(@"mac address : %@",[self macAddress]);
    
    //从iOS 5开始就不能用了
    //[UIDevice currentDevice] uniqueIdentifier]

    //作用域  ：可以在同个vendor App间共享
    //生命周期：删除所有vendor App后再重装，id会变化
    NSLog(@"identifierForVendor : %@", [[UIDevice currentDevice] identifierForVendor]);

    //作用域  ：所有App共享同一个id
    //生命周期：清除广告id会变化
    NSLog(@"advertisingIdentifier : %@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]);
    
    //https://github.com/ylechelle/OpenUDID
    //作用域  ：可以在同个开发者账号下的App间共享
    //生命周期：重装App，会变化
    NSLog(@"OpenUDID : %@",[OpenUDID value]);
    
    //https://github.com/fabiocaccamo/FCUUID
    //作用域  ：可在同个开发者账号下，同个App group间进行共享
    //生命周期：抹掉整个手机内容后，才会变化
    NSLog(@"FCUUID : %@",[FCUUID uuidForDevice]);
    
    return YES;
}

- (NSString*)macAddress
{
    
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macStr = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",*ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macStr;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
