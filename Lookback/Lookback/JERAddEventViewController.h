//
//  JERAddEventViewController.h
//  Lookback
//
//  Created by Jooeun Lim on 7/14/14.
//

#import <UIKit/UIKit.h>

#import "JERDay.h"

@interface JERAddEventViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JERDay *today;
@property (nonatomic,strong) JEREvent *event;
- (instancetype)initWithReadOnly;

@end
