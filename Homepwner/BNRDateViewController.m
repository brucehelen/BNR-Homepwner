//
//  BNRDateViewController.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-10.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDateViewController.h"
#import "BNRItem.h"

@interface BNRDateViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation BNRDateViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.datePicker.date = _item.dateCreated;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.item.dateCreated = _datePicker.date;
}

@end
