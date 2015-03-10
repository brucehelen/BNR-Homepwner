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
#import "BNRDetailViewController.h"
#define CELL_ID @"UITableViewCell"

@interface BNRItemsViewController()
//@property (nonatomic, strong) IBOutlet UIView *headerView;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for (int i = 0; i < 5; i++) {
//            [[BNRItemStore sharedStore] createItem];
//        }
        
        self.navigationItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    
    //self.tableView.tableHeaderView = self.headerView;
}

//- (UIView *)headerView
//{
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _headerView;
//}

- (IBAction)addNewItem:(id)sender
{
    //NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

// 使用UINavigationBar对象后就不需要HeaderView.xib文件了。
//// 进入编辑状态
//- (IBAction)toggleEditingMode:(id)sender
//{
//    NSLog(@"toggleEditingMode");
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}

// 显示多少行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

// 每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用这种方法，必须调用registerClass注册
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    // 显示正常的数据行
    if (indexPath.row < [[[BNRItemStore sharedStore] allItems] count]) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        
        cell.textLabel.text = [item description];
    } else {
        // row == count
        cell.textLabel.text = @"No more items!";
    }
    
    cell.showsReorderControl = YES;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {    // 删除行
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 修改删除按钮显示的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}


// 移动行
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

// 设置最后一行不能被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return NO;
    }
    
    return YES;
}

// 如果不实现，默认为：UITableViewCellEditingStyleDelete
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //return UITableViewCellEditingStyleNone;
//    return UITableViewCellEditingStyleInsert;
//}

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}


// 设置行移动的范围：不能移动到最后一行（No more items!）的下面
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *indexPath;
    NSUInteger count = [[[BNRItemStore sharedStore] allItems] count] - 1;
    if (proposedDestinationIndexPath.row >= count) {
        indexPath = [NSIndexPath indexPathForRow:count inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row
                                       inSection:proposedDestinationIndexPath.section];
    }
    
    return indexPath;
}

// 选中某一行，进行修改（进入另一个视图界面）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中最后一行：No more items!时不要进行操作
    if (indexPath.row >= [[[BNRItemStore sharedStore] allItems] count])
        return;

    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectItem = items[indexPath.row];
    NSLog(@"selectItem = %p", selectItem);
    detailViewController.item = selectItem;
    NSLog(@"item = %p", detailViewController.item);
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}



@end
