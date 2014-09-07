//
//  SendViewController.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-9-2.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendViewController : UIViewController
{
    CGFloat _longitude;
    CGFloat _latitude;
}

@property (nonatomic,retain) UITextView *textView;
@property (nonatomic,retain) UIView *buttonView;
@property (nonatomic,retain) NSDictionary *locationDictionary;



@end
