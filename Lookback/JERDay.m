//
//  JERDay.m
//  Lookback
//
//  Created by Huirong Zhu on 7/12/14.
//

#import "JERDay.h"
#import <Parse/PFObject+Subclass.h>
#import "JEREvent.h"

@interface JERDay ()
{
    NSMutableArray *_events;
}
@end

@implementation JERDay
@dynamic mood;
@dynamic special;
@dynamic date;
@dynamic user;

+ (NSString*)parseClassName
{
    return @"JERDay";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _events = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addEvent:(JEREvent *)event
{
    [_events addObject:event];
}

- (void)removeEvent:(JEREvent *)event
{
    [_events removeObject:event];
}

- (NSArray *)events
{
    return [NSArray arrayWithArray:_events];
}

- (void)addEventsFromArray:(NSArray *)array
{
    [_events addObjectsFromArray:array];
}

@end
