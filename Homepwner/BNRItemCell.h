//
//  BNRItemCell.h
//  Homepwner
//
//  Created by 朱正晶 on 15-3-23.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) void (^actionBlock)(void);
@end
