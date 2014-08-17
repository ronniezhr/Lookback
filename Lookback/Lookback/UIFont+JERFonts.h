//
//  UIFont+JERFonts.h
//  Lookback
//
//  Created by Jooeun Lim on 7/31/14.
//

#import <UIKit/UIKit.h>

@interface UIFont (JERFonts)

+ (UIFont *)lookbackHeaderFont;
+ (UIFont *)lookbackBigTitleFont;
+ (UIFont *)lookbackRegularFont;
+ (UIFont *)lookbackItalicFont: (CGFloat) size;
+ (UIFont *)lookbackFontWithSize: (CGFloat) size;
+ (UIFont *)lookbackBoldFontWithSize: (CGFloat) size;

@end