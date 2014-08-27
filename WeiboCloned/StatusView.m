//
//  StatusView.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "StatusView.h"
#import "UIFactory.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

#define LIST_FONT   14.0f
#define LIST_RETWEET_FONT   13.0f
#define DETAIL_FONT 18.0f
#define DETAIL_RETWEET_FONT 17.0f

@implementation StatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        _parsedText = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)initView
{
    //微博内容
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    [_textLabel setDelegate:self];
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.linkAttributes = [NSDictionary   dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博图片
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loading@2x.png"];
    [self addSubview:_image];
    
    //微博背景图片
    _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_retweet_background@2x.png"]];
    UIImage *bgImage = [_backgroundImage.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _backgroundImage.image = bgImage;
    _backgroundImage.backgroundColor = [UIColor clearColor];
    [self insertSubview:_backgroundImage atIndex:0];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置微博内容
    CGFloat fontSize = [StatusView getFontSize:self.isDetail isRetweet:self.isRetweet];
    [_textLabel setFrame:CGRectMake(10, 5, ScreenWidth - 20, 0)];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.text = _parsedText;
    
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
    //设置转发微博
    Status *retweet = self.statusDate.retweeted_status;
    if (retweet != nil) {
        _retweetView.hidden = NO;
        _retweetView.statusDate = retweet;
        
        CGFloat height = [StatusView getStatusViewHeight:retweet isRetweet:YES isDetail:self.isDetail];
        
        [_retweetView setFrame:CGRectMake(0, _textLabel.bottom + 5, ScreenWidth, height)];
    }
    else
    {
        _retweetView.hidden = YES;
    }
    //设置微博图片
    if (self.isDetail) {
        NSString *imageStr = self.statusDate.bmiddle_pic;
        if (imageStr != nil && ![imageStr isEqualToString:@""]) {
            _image.hidden = NO;
            [_image setFrame:CGRectMake(10, _textLabel.bottom + 5, ScreenWidth - 20, 200)];
            //加载网络图片
            [_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//            [_image setContentMode:UIViewContentModeScaleAspectFill ];
        }
        else
        {
            _image.hidden = YES;
        }
    }
    else
    {
        NSString *imageStr = self.statusDate.thumbnail_pic;
        if (imageStr != nil && ![imageStr isEqualToString:@""]) {
            _image.hidden = NO;
            [_image setFrame:CGRectMake(10, _textLabel.bottom + 5, 120, 200)];
            //加载网络图片
            [_image sd_setImageWithURL:[NSURL URLWithString:imageStr]];
            [_image setContentMode:UIViewContentModeScaleAspectFit | UIViewContentModeTopLeft ];
        }
        else
        {
            _image.hidden = YES;
        }
    }
    
    //转发微博的背景
    if (self.isRetweet) {
        _backgroundImage.frame = self.bounds;
        _backgroundImage.hidden = NO;
    }
    else
    {
        _backgroundImage.hidden = YES;
    }
}

- (void)parseLink {
    
    [_parsedText setString:@""];
    
    if (_isRetweet) {
        NSString *nickName = [NSString stringWithFormat:@"@%@",_statusDate.user.screen_name];
        NSString *encodeName = [nickName URLEncodedString];
        [_parsedText appendString:[NSString stringWithFormat:@"<a href='user://%@'>%@</a> :",encodeName,nickName]];
    }
    
    NSString *text = self.statusDate.text;
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    NSString *replaceStr = @"";
    for (NSString *linkString in matchArray) {
        
        if ([linkString hasPrefix:@"@"]) {
            replaceStr = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        else if ([linkString hasPrefix:@"#"])
        {
            replaceStr = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        else if ([linkString hasPrefix:@"http"])
        {
            replaceStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString];
        }
        
        if (![replaceStr isEqualToString:@""]) {
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replaceStr];
        }
    }
    
    [_parsedText appendString:text];
    
}

#pragma mark - Public Methods

+ (CGFloat)getFontSize:(BOOL)isDetail isRetweet:(BOOL)isRetweet
{
    CGFloat fontSize = 14.0f;
    if (!isDetail && !isRetweet) {
        return LIST_FONT;
    }
    else if (!isDetail && isRetweet)
    {
        return LIST_RETWEET_FONT;
    }
    else if (isDetail && !isRetweet)
    {
        return DETAIL_FONT;
    }
    else if(isDetail && isRetweet)
    {
        return DETAIL_RETWEET_FONT;
    }
    else
    {
        return fontSize;
    }
}



+ (CGFloat)getStatusViewHeight:(Status *)status isRetweet:(BOOL)isRetweet isDetail:(BOOL)isDetail
{
    CGFloat height = 0;
    
    //微博视图高度
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    CGFloat fontSize = [StatusView getFontSize:isDetail isRetweet:isRetweet];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    textLabel.width = ScreenWidth - 20;
    textLabel.text = status.text;
    height += textLabel.optimumSize.height + 20;
    
    //微博图片的高度
    if (isDetail) {
        NSString *imageStr = status.bmiddle_pic;
        if (imageStr != nil && ![imageStr isEqualToString:@""]) {
            //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
            height += (200 + 10);
        }
    }
    else
    {
        NSString *imageStr = status.thumbnail_pic;
        if (imageStr != nil && ![imageStr isEqualToString:@""]) {
    //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
            height += (120 + 10);
        }
    }
    
    //转发原微博高度
    Status *retStatus = status.retweeted_status;
    
    if (retStatus != nil) {
        height += [StatusView getStatusViewHeight:retStatus isRetweet:YES isDetail:isDetail];
    }
    
//    if (isRetweet) {
//        height += 20;
//    }
    
    return height;
}

#pragma mark - Override Methods
- (void)setStatusDate:(Status *)statusDate
{
    if (_statusDate != statusDate) {
        [_statusDate release];
        _statusDate = [statusDate retain];
    }
    
    if (_retweetView == nil) {
        _retweetView = [[StatusView alloc] initWithFrame:CGRectZero];
        _retweetView.isRetweet = YES;
        _retweetView.isDetail = self.isDetail;
        [self addSubview:_retweetView];
    }
    
    [self parseLink];
}

#pragma mark - RTLabel Delegate Methods
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *absoluteString = [url absoluteString];
    NSString *urlString = [url host];
    urlString = [urlString URLDecodedString];
    
    if ([absoluteString hasPrefix:@"user"]) {
        NSLog(@"user:%@",urlString);
    }
    else if ([absoluteString hasPrefix:@"topic"]) {
        NSLog(@"topic:%@",urlString);
    }
    else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"http:%@",absoluteString);
    }

    
}

#pragma mark - Memory Management
- (void)dealloc {
    [super dealloc];
}

@end
