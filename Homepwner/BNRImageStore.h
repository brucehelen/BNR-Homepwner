//
//  BNRImageStore.h
//  Homepwner
//
//  Created by 朱正晶 on 15-3-11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
