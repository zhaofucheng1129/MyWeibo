//
//  StatusTableViewCell.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIUtils.h"
#import "RegexKitLite.h"

@implementation StatusTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView
{
    _userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_small@2x.png"]];
    [_userImage setBackgroundColor:[UIColor clearColor]];
//    _userImage.layer.cornerRadius = 50;
    _userImage.layer.borderWidth = 0.5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    _screenNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_screenNameLabel setBackgroundColor:[UIColor clearColor]];
    _screenNameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_screenNameLabel];
    
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sourceLabel];
    
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_createLabel];
    
    _statusView = [[StatusView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_statusView];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    selectedBackgroundView.backgroundColor = UIColorMake(218, 218, 218, 1);
    self.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_userImage setFrame:CGRectMake(10, 5, 34, 34)];
    NSString *userImageUrl = self.statusData.user.profile_image_url;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    [_screenNameLabel setFrame:CGRectMake(55, 5, 200, 20)];
    _screenNameLabel.text = self.statusData.user.screen_name;
    
    //微博发布时间
    [_createLabel setFrame:CGRectMake(55, 28, 200, 20)];
    _createLabel.font = [UIFont systemFontOfSize:10.0f];
    NSString *createTime = self.statusData.created_at;
    if (createTime != nil) {
        _createLabel.hidden = NO;
        NSDate *createData = [UIUtils dateFromFomate:createTime formate:@"E M d HH:mm:ss Z yyyy"];
        CGFloat scronds = fabsf([createData timeIntervalSinceNow]);
        NSString *createString = nil;
        if (scronds<120) {
            createString = @"刚刚";
            _createLabel.textColor = [UIColor orangeColor];
        }
        else if(scronds < 3600)
        {
            createString = [NSString stringWithFormat:@"%d分钟前",(int)(scronds/60)];
            _createLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            createString = [UIUtils stringFromFomate:createData formate:@"MM-dd HH-mm"];
            _createLabel.textColor = [UIColor grayColor];
        }
        
        _createLabel.text = createString;
        [_createLabel sizeToFit];

    }
    else
    {
        _createLabel.hidden = YES;
    }
    
    //微博来源
    NSString *source = self.statusData.source;
    source = [NSString stringWithFormat:@"来自:%@",[self parseSource:source] ];
    if (source != nil) {
        _sourceLabel.hidden = NO;
        [_sourceLabel setFrame:CGRectMake(_createLabel.right + 5, _createLabel.top, 200, 20)];
        _sourceLabel.font = _createLabel.font;
        _sourceLabel.text = source;
        [_sourceLabel sizeToFit];
    }
    else
    {
        _sourceLabel.hidden = YES;
    }
    
    _statusView.statusDate = self.statusData;
    CGFloat viewHeight = [StatusView getStatusViewHeight:_statusData isRetweet:NO isDetail:NO];
    [self.statusView setFrame:CGRectMake(0, _userImage.bottom + 10, ScreenWidth, viewHeight)];
    
    
}

- (NSString *)parseSource:(NSString *)source
{
    NSString *regex = @">\\w+\\s*\\w+.*<";
    NSArray *array = [source componentsMatchedByRegex:regex];
    if (array.count > 0) {
        NSString *sourceString = [array lastObject];
        NSRange range;
        range.location = 1;
        range.length = sourceString.length - 2;
        sourceString = [sourceString substringWithRange:range];
        return sourceString;
    }
    return nil;
}

- (void)dealloc {

    [super dealloc];
}
@end
