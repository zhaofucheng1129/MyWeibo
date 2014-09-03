//
//  PhotoView.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"

@implementation PhotoView

CGFloat width = 50.0f;
CGFloat height = 50.0f;
CGFloat margin = 5.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    
    int count = self.urls.count;
    if (count == 0) {
        return ;
    }
    
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    int column = 0;
    int row = 0;
    UIImage *image = [UIImage imageNamed:@"timeline_image_loading@2x.png"];
    int columnCount = (count > 4 ? 3 : 2);
    for (int i = 0; i < count; i++) {
        row = i / columnCount;
        column = i % columnCount;
        
        CGFloat x = column * (width + margin);
        CGFloat y = row * (height + margin);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(x, y, width, height);
        [self addSubview:imageView];
        [imageView sd_setImageWithURL:[[self.urls objectAtIndex:i] objectForKey:@"thumbnail_pic"] placeholderImage:image];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
}

#pragma mark - Public Methods
+ (CGFloat)getHeight:(int)count
{
    if (count > 4) {
        return (count + 1) / 3 * 55;
    }
    return (count + 1) / 2 * 55;
}

#pragma mark - Setting Methods
- (void)setUrls:(NSArray *)urls
{
    if (_urls != urls) {
        [_urls release];
        _urls = [urls retain];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
