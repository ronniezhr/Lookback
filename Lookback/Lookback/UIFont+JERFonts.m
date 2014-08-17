//
//  UIFont+JERFonts.m
//  Lookback
//
//  Created by Jooeun Lim on 7/31/14.
//

#import "UIFont+JERFonts.h"

static const NSString * kJERFontDefaultFontName = @"HelveticaNeue-Light";
static const NSString * kJERFontItalicFontName = @"HelveticaNeue-LightItalic";
static const NSString * kJERFontBoldFontName = @"HelveticaNeue-Bold";
static const CGFloat kJERHeaderFontSize = 30.0f;
static const CGFloat kJERBigTitleFontSize = 40.0f;
static const CGFloat kJERRegularFontSize = 20.0f;

@implementation UIFont (JERFonts)

+ (UIFont *)lookbackHeaderFont {
    return [self lookbackFontWithSize:kJERHeaderFontSize];
}

+ (UIFont *)lookbackBigTitleFont {
    return [self lookbackFontWithSize:kJERBigTitleFontSize];
}

+ (UIFont *)lookbackRegularFont {
    return [self lookbackFontWithSize:kJERRegularFontSize];
}


+ (UIFont *)lookbackItalicFont:(CGFloat) size {
    return [UIFont fontWithName:kJERFontItalicFontName size:size];
}

+ (UIFont *)lookbackFontWithSize: (CGFloat) size {
    return [UIFont fontWithName:kJERFontDefaultFontName size:size];
}

+ (UIFont *)lookbackBoldFontWithSize:(CGFloat) size {
    return [UIFont fontWithName:kJERFontBoldFontName size:size];
}

@end
