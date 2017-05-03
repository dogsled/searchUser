//
//  HttpManager.m
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import "AFNetworking.h"
#import "HttpManager.h"

@implementation HttpManager
+ (void)POST:(NSString *)urlStr
  parameters:(id)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure
{
    
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval  = 30.0f;
    
    //发送请求
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int code =  [[responseObject objectForKey:@"code"] intValue];
        if(success)
        {
            success(code, responseObject);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+(void) GET:(NSString*)urlStr
 parameters:(id)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure
{
;
    //获得管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval  = 30.0f;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:@"access-token"];
    
    if ([urlStr containsString:@"?"]) {
        urlStr =  [urlStr stringByAppendingString:@"&"];
    }
    else
    {
      urlStr =  [urlStr stringByAppendingString:@"?"];
    }
    urlStr =  [urlStr stringByAppendingString:[NSString stringWithFormat:@"access_token=%@", token]];
    //发送请求
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取头部数据
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
        int code =  [[response.allHeaderFields[@"Status"] componentsSeparatedByString:@" "].firstObject intValue];
        
        if(success)
        {
            success(code, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            if(failure)
                failure(error);
        }
    }];
}

@end
