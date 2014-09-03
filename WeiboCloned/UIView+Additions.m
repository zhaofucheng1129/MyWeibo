//
//  UIView+Additions.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-29.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "UIView+Additions.h"
#import "HomeViewController.h"

@implementation UIView (Additions)


- (UIViewController *)viewController
{
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[HomeViewController class]]) {
            return (HomeViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
}

@end
