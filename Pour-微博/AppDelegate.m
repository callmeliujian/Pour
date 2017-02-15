//
//  AppDelegate.m
//  Pour-微博
//
//  Created by 😄 on 2016/11/29.
//  Copyright © 2016年 😄. All rights reserved.
//

#import "AppDelegate.h"
#import "LJMainViewController.h"
#import "LJUserAccount.h"

#import "LJWelcomeViewController.h"
#import "LJNewFeatureViewController.h"

@interface AppDelegate ()

- (BOOL)isNewVersion;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //self.window.rootViewController = [self defaultViewController];
    self.window.rootViewController = [[LJMainViewController alloc] init];
    //设置全局UINavigationBar／UITabBar为黄色
    UINavigationBar *item = [UINavigationBar appearance];
    item.tintColor = [UIColor orangeColor];
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = [UIColor orangeColor];
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"%@", [LJUserAccount loadUserAccout]);
    
    [self isNewVersion];
    
    return YES;
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

- (UIViewController *)defaultViewController {
    // 1.判断是否登陆
    if ([LJUserAccount isLogin]) {
        // 2.判断是否有新版本
        if ([self isNewVersion]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LJNewFeatureViewController" bundle:nil];
            LJNewFeatureViewController *vc = [sb instantiateInitialViewController];
            return vc;
        }
        // 没有新版本
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LJWelcomeViewController" bundle:nil];
        LJWelcomeViewController *vc = [sb instantiateInitialViewController];
        return vc;
    }
    // 没有登陆
    return [[LJMainViewController alloc] init];
    
}

- (BOOL)isNewVersion {
    // 1.加载info.plist
    // 2.获取当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 3.获取以前的软件版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sandboxVersion;
    if ([defaults objectForKey:@"version"] == nil)
        sandboxVersion = @"0.0";
    sandboxVersion = [defaults objectForKey:@"version"];
    
    // 4.用当前的版本号和以前的版本号进行比较4.用当前的版本号和以前的版本号进行比较
    if ([currentVersion compare:sandboxVersion] == NSOrderedDescending) {
        // 如果当前的大于以前的, 有新版本
        NSLog(@"有新版本");
        // 更新本地版本号
        [defaults setObject:currentVersion forKey:@"version"];
        return true;
    }
    NSLog(@"没有新版本");
    return false;
}

@end
