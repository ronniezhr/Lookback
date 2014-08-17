//
//  JERImageStore.h
//  Lookback
//
//  Created by Jooeun Lim on 7/14/14.
//

#import <Foundation/Foundation.h>

@interface JERImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey: (NSString *)key;
- (UIImage *)imageForKey: (NSString *)key;
- (void)deleteImageForKey: (NSString *)key;

@end
