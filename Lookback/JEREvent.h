//
//  JEREvent.h
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface JEREvent : PFObject<PFSubclassing>
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, strong) PFUser *user;
@end
