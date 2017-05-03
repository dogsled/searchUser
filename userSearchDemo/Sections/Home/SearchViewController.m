//
//  SearchViewController.m
//  userSearchDemo
//
//  Created by 全博伟 on 17/5/3.
//  Copyright © 2017年 doqi. All rights reserved.
//

#import "SearchViewController.h"
#import "UtilsMacro.h"
#import "HttpManager.h"
#import "AppMacro.h"
#import "UserInfo.h"
#import "JSONModel.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *userArray;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
  
}
-(void)initUI
{
    [self setTitle:@"用户信息查询"];
    
    //初始化tableView 显示查询结果
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //初始化searchBar
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _searchBar.delegate = self;
    [_searchBar setPlaceholder:@"请输入用户名"];
    _searchBar.showsCancelButton = true;
    _tableView.tableHeaderView = _searchBar;
    
    //去除底部分割线
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _tableView.tableFooterView = footerView;
    
    [self.view addSubview:_tableView];
}


#pragma mark - tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.userArray ? self.userArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserID = @"UserInfo_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuserID];
    }
    
    UserInfo * userInfo =self.userArray[indexPath.row];
    
    cell.textLabel.text = userInfo.login_name;
    NSURL * imageUrl = [NSURL URLWithString:userInfo.avatar_url];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"search_group"]];
    
    //判断是否统计出使用最多语言
    if (userInfo.language != nil && ![userInfo.language isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = userInfo.language;
    }
    else
    {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

//滑动隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark -  searchBar 代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"输入内容：%@", searchText);
    if (searchText.length == 0) {
        [_userArray removeAllObjects];
        [_tableView reloadData];
        
    }else{
        NSString * searchStr  = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self searchUser:searchStr];
    }
};


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_userArray removeAllObjects];
    [_tableView reloadData];
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
}

-(void)searchUser:(NSString*)userName
{
    NSString * root_path = [KROOT_PATH stringByAppendingString:userName];
    [HttpManager GET:root_path parameters:nil success:^(int resultCode, id responseObject) {
        NSLog(@"查询用户信息成功");
        _userArray = [UserInfo arrayOfModelsFromDictionaries:[responseObject objectForKey:@"items"]];
        [_tableView reloadData];
        
        //获取统计使用最多语言
        for (int index = 0; index < _userArray.count; index++) {
            
            UserInfo * userInfo = [_userArray objectAtIndex:index];
            __block int currentIndex = index;
            
            [HttpManager GET:userInfo.repos_url parameters:nil success:^(int resultCode, id responseObject) {
                NSArray *repos_info_arr = responseObject;
                //缓存所有语言
                NSMutableDictionary * allLanguageDic =[NSMutableDictionary dictionary];
                //使用最多语言
                NSString* mostUseLanguage = @"";
                //最多使用语言，使用次数
                int  useCount = 0;
                //遍历所有语言
                for (NSDictionary * repos_dic  in repos_info_arr) {
                    NSString * language =   [repos_dic objectForKey:@"language"];
                    //已缓存，计数加1
                    if ([allLanguageDic.allKeys containsObject:language]) {
                        int  count =  [[allLanguageDic objectForKey:language] intValue]+1;
                        [allLanguageDic setValue:[NSNumber numberWithInt:count] forKey:language];
                        //判断最多使用次数，赋值并计数
                        if (useCount<count) {
                            mostUseLanguage = language;
                            useCount = count;
                        }
                    }
                    else
                    {
                        //未缓存，加入缓存字典
                        [allLanguageDic setValue:[NSNumber numberWithInt:1] forKey:language];
                        if (useCount == 0) { //第一次获取到数据，初始化最多使用语言和计数器
                            mostUseLanguage = language;
                            useCount = 1;
                        }
                    }
                }
                //刷新数组
                userInfo.language = mostUseLanguage;
                if (_userArray.count > currentIndex) { //数组可能被置空
                   [_userArray replaceObjectAtIndex:currentIndex withObject:userInfo];
                    //刷新tableview cell 显示使用最多语言
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                    NSLog(@"刷新第：%d条, 语言是：%@", currentIndex, mostUseLanguage);
                }
                
                
            } failure:^(NSError *error) {
                
                
                NSString * errorMsg = error.description;
                NSLog(@"刷新第条失败：%@", errorMsg);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"刷新使用最多语言失败，错误码：%@", error.localizedDescription]];
            }];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"查询用户信息失败，错误码：%d", error.code]];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
