//
//  ProfileViewController.h
//  WeiboCloned
//  个人视图控制器
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
	
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
