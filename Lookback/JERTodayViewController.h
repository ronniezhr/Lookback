//
//  JERTodayViewController.h
//  Lookback
//
//  Created by Emily Scharff on 7/14/14.
//

#import <UIKit/UIKit.h>
#import "JERDay.h"

@interface JERTodayViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    NSArray *emoji_choice;
}

@property (nonatomic, strong) JERDay *today;
- (instancetype)initWithReadOnly;

@end
