//
//  HttpManager.h
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

typedef void (^SuccessBlock) (int resultCode,  id responseObject);
typedef void (^FailureBlock) (NSError *error);


/**
 *  Post网络请求
 *
 *  @param urlStr url
 *  @param parameters 参数
 *  @param success    成功后回调
 *  @param failure    失败后回调
 *
 */
+ (void)POST:(NSString *)urlStr
  parameters:(id)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;


/**
 *  get网络请求
 *
 *  @param urlStr  url
 *  @param parameters 参数
 *  @param success    成功后回调的block
 *  @param failure    失败后回调的block
 *
 */
+(void) GET:(NSString*)urlStr
 parameters:(id)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;
@end
