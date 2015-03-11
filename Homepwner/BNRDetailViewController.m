//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 朱正晶 on 15/3/9.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRDateViewController.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)backgroundTapped:(id)sender;

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
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    self.dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    self.imageView.image = imageToDisplay;
}

// 视图将要消失时调用，保存数据
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

// 触摸view空白处，收回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 收回键盘的第二种方法：修改xib的Custom Class为UIControl，加入control的action方法
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

// 修改日期，弹出修改日期视图
- (IBAction)ChangeDate:(UIButton *)sender
{
    BNRDateViewController *dateViewController = [[BNRDateViewController alloc] init];
    dateViewController.item = self.item;
    [self.navigationController pushViewController:dateViewController animated:YES];
}

#pragma mark - UIToolBar上面的相机拍照按钮
- (IBAction)takePicture:(UIBarButtonItem *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    // 以模态的形式显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// 清除UIImageView上面显示的图片
- (IBAction)clearImageView:(id)sender
{
    self.imageView.image = nil;
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
}

// 选中图片，显示在UIImageView上
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    // 关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
