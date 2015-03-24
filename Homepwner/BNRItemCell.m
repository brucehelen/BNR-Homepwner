//
//  BNRItemCell.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-23.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
