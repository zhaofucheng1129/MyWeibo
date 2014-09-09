//
//  CommentCell.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-16.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"


@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    _userImage = [(UIImageView *)[self viewWithTag:100] retain];
    _screenNameLabel = [(UILabel *)[self viewWithTag:101] retain];
    _createLabel = [(UILabel *)[self viewWithTag:102] retain];
    
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(_createLabel.left, _createLabel.bottom, ScreenWidth - 10 - _createLabel.left, 10)];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    
    _contentLabel.linkAttributes = [NSDictionary   dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    NSString *urlString = self.commentData.user.profile_image_url;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //昵称
    _screenNameLabel.text = self.commentData.user.screen_name;
    
    //创建时间
    NSString *createTime = self.commentData.created_at;
    if (createTime != nil) {
        _createLabel.hidden = NO;
        NSDate *createData = [UIUtils dateFromFomate:createTime formate:@"E M d HH:mm:ss Z yyyy"];
        CGFloat scronds = fabsf([createData timeIntervalSinceNow]);
        NSString *createString = nil;
        if (scronds<120) {
            createString = @"刚刚";
        }
        else if(scronds < 3600)
        {
            createString = [NSString stringWithFormat:@"%d分钟前",(int)(scronds/60)];
        }
        else
        {
            createString = [UIUtils stringFromFomate:createData formate:@"MM-dd HH-mm"];
        }
        _createLabel.textColor = [UIColor grayColor];
        _createLabel.text = createString;
        [_createLabel sizeToFit];
        
    }
    else
    {
        _createLabel.hidden = YES;
    }

    NSString *commentText = self.commentData.text;
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    
}

#pragma mark - Public Methods
+ (CGFloat)getCommentHeight:(Comment *)comment
{
   
    RTLabel *rtlabel = [[[RTLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 10 - 49, 0)] autorelease];
    rtlabel.font = [UIFont systemFontOfSize:14.0f];
    rtlabel.text = comment.text;
    
    return rtlabel.optimumSize.height;
}

@end
