//
//  JEREvent.m
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import "JEREvent.h"

#import <Parse/PFObject+Subclass.h>

@implementation JEREvent
@dynamic image;
@dynamic text;
@dynamic title;
@dynamic date;
@dynamic photoID;
@dynamic user;

+ (NSString*)parseClassName
{
    return @"JEREvent";
}

- (UIImage *)image
{
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"JERPhoto"];
    PFObject *imageObject = [imageQuery getObjectWithId:self.photoID];
    PFFile *imageFile = [imageObject objectForKey:@"imageFile"];
    NSData *imageData = [imageFile getData];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
}

@end
