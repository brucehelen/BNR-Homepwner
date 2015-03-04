//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-4.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

#define CELL_ID @"UITableViewCell"

@interface BNRItemsViewController()

@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    
    // 初始化数组
    self.bigArray = [NSMutableArray array];
    self.leftArray = [NSMutableArray array];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if (item.valueInDollars > 50) {
            [self.bigArray addObject:item];
        } else {
            [self.leftArray addObject:item];
        }
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建cell的过程交由系统管理--告诉视图，如果对象池中没有UITableViewCell对象，应该初始化哪种类型的UITableViewCell对象
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID];
}

// 返回有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case 0:
            // 第一个，显示大于50美元的表格
            number = [self.bigArray count];
            break;
        case 1:
            // 第二个，显示其余的表格
            number = [self.leftArray count];
            break;
        default:
            break;
    }
    return number;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = @"大于50美元";
            break;
        case 1:
            title = @"其余";
       default:
            break;
    }

    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItem *item;
    
    // 使用这种方法，必须调用registerClass注册
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            // 大于50美元
            item = self.bigArray[indexPath.row];
            break;
        case 1:
            // 其余的
            item = self.leftArray[indexPath.row];
            break;
        default:
            break;
    }
    cell.textLabel.text = [item description];
    
    return cell;
}

@end
