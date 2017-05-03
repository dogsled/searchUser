//
//  UserInfo.h
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface UserInfo : JSONModel
@property (nonatomic, strong) NSString              *login_name;
@property (nonatomic, strong) NSString              *u_id;
@property (nonatomic, strong) NSString              *avatar_url;
@property (nonatomic, strong) NSString              *repos_url;
@property (nonatomic, strong) NSString<Optional>    *language;

@end
