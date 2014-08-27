//
//  SkinsViewController.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"

@interface SkinsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *skins;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
