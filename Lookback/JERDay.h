//
//  JERDay.h
//  Lookback
//
//  Created by Huirong Zhu on 7/12/14.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "JEREvent.h"

@interface JERDay : PFObject<PFSubclassing>

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) NSInteger mood; // an integer from 1-5
@property (nonatomic, copy) NSArray *events;
@property (nonatomic, assign) BOOL special;
@property (nonatomic, strong) PFUser *user;

- (void)addEvent:(JEREvent *)event;
- (void)removeEvent:(JEREvent *)event;
- (void)addEventsFromArray:(NSArray *)array;

@end
