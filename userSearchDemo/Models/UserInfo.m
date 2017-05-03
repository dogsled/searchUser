//
//  UserInfo.m
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(JSONKeyMapper*)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"login":@"login_name", @"id":@"u_id"}];
}
@end
