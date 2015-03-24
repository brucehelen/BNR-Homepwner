//
//  BNRItemCell.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-23.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRItemCell.h"

@interface BNRItemCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@end

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark - 当NIB文件被解析为对象后调用
- (void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(updateInterfaceForDynamicTypeSize)
                          name:UIContentSizeCategoryDidChangeNotification
                        object:nil];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDict;
    if (!imageSizeDict) {
        imageSizeDict = @{UIContentSizeCategoryExtraSmall: @40,
                          UIContentSizeCategorySmall: @40,
                          UIContentSizeCategoryMedium:@40,
                          UIContentSizeCategoryLarge:@40,
                          UIContentSizeCategoryExtraLarge:@45,
                          UIContentSizeCategoryExtraExtraLarge:@55,
                          UIContentSizeCategoryExtraExtraExtraLarge:@65};
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDict[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    self.imageViewWidthConstraint.constant = imageSize.floatValue;
}




@end
