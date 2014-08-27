//
//  CommentCell.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-16.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class Comment;

@interface CommentCell : UITableViewCell <RTLabelDelegate> {
    UIImageView *_userImage;
    UILabel *_screenNameLabel;
    UILabel *_createLabel;
    RTLabel *_contentLabel;
}
@property (nonatomic, retain) Comment *commentData;

+ (CGFloat)getCommentHeight:(Comment *)comment;

@end
