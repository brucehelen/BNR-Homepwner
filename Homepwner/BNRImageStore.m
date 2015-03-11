//
//  BNRImageStore.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRImageStore.h"


@interface BNRImageStore()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation BNRImageStore

+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (sharedStore == nil) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dict[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dict[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dict removeObjectForKey:key];
}


@end
