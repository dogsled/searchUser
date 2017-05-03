//
//  AppDelegate.m
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "HttpManager.h"
#import "AppMacro.h"
#import "GitHubOAuthController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    self.window.rootViewController = nav;
   [self.window makeKeyAndVisible];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _token = [userDefaults objectForKey:@"access-token"];
    if (_token == nil) {
       [self oAuth];
    }
    
    
    return YES;
}

-(void)oAuth
{
   
    GitHubOAuthController *oauthController = [[GitHubOAuthController alloc] initWithClientId:KAPP_CLIENT_ID clientSecret:KAPP_CLIENT_SECRET scope:@"sd2348274" success:^(NSString *accessToken, NSDictionary *raw) {
        _token = accessToken;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:accessToken forKey:@"access-token"];
        [userDefaults synchronize];
        NSLog(@"access token: %@ \nraw: %@", accessToken, raw);
    } failure:nil];
    
    [oauthController showModalFromController:self.window.rootViewController];
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
