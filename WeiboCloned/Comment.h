//
//  Comment.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-16.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"
#import "Status.h"

@interface Comment : BaseModel

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) NSNumber *previous_cursor;
@property (nonatomic, retain) NSNumber *next_cursor;
@property (nonatomic, retain) NSNumber *total_number;

@end
