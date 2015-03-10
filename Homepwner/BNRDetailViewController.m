//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 朱正晶 on 15/3/9.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)ChangeDate:(UIButton *)sender;

@end

@implementation BNRDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置数字键盘
    self.valueField.keyboardType = UIKeyboardTypeNumberPad;
}

// 视图出现时调用
- (void)viewWillAppear:(BOOL)animated
{
    self.nameField.text = self.item.itemName;
    self.serialNumberField.text = self.item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
}

// 视图将要消失时调用
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

// 触摸view空白，收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)ChangeDate:(UIButton *)sender
{
    
}
@end
