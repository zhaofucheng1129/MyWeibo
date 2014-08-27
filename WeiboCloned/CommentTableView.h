//
//  CommentTableView.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-14.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseTableView.h"
#import "Status.h"

@interface CommentTableView : BaseTableView

@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, retain) Status *statusData;

@end
